#!/usr/bin/env python

# usage:
# ./check_grants.py  -u admin -p test1234 -f influx -d '{"telegraf":{"perms":{"telegraf":"WRITE","test":"READ"},"pass":"asdasdd"},"vova":{"perms":{"test5":"WRITE","test4":"READ"},"pass":"test234"},"asd":{"perms":{"telegraf":"READ","test5": "ALL"},"pass":"asdmk"}}'

import sys, json, argparse
import requests, urllib

from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)



def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument('-u', '--user', default='admin')
    parser.add_argument('-p', '--password', default='admin')
    parser.add_argument('-f', '--fqdn', default='localhost')
    parser.add_argument('-d','--data',)
    parser.add_argument('-c','--check', action='store_true', default=False)
    return parser.parse_args()

ARGS = parse_arguments()
HOST = ARGS.fqdn
USER = ARGS.user
PASW = ARGS.password
PILLAR = json.loads(ARGS.data)
CHK = ARGS.check

def show_databases():
    query = auth()
    query['q'] = 'SHOW DATABASES'
    req = request(query)
    ret = requests.get(req, verify=False).text
    data = json.loads(ret)
    arr = []
    for r in data["results"][0]["series"][0]["values"]:
        arr.append(r[0])
    return arr

def show_users():
    query = auth()
    query['q'] = 'SHOW USERS'
    req = request(query)
    ret = requests.get(req, verify=False).text
    data = json.loads(ret)
    arr = []
    for r in data["results"][0]["series"][0]["values"]:
        # only collect non-admin users
        if r[1] == False:
            arr.append(r[0])
    return arr

def show_grants(pillar):
    current = {}
    query = auth()
    for user in pillar.keys():
        query['q'] = 'SHOW GRANTS FOR ' + user
        req = request(query)
        ret = requests.get(req, verify=False).text
        data = json.loads(ret)
        if 'series' in data['results'][0]:
            current[user] = {}
            grants = data["results"][0]["series"][0]
            if 'values' in grants:
                for val in grants['values']:
                    current[user][val[0]] = val[1]
            else:
                current[user] = None
    return current

def check_list(result, pillar):
    diff = []
    for item in pillar:
        if item not in result:
            diff.append(item)
    return diff

def check_grants(result, pillar):
    diff = {}
    for user in pillar.keys():
        perms = pillar[user]['perms']
        if user in result:
            if result[user] == None:
                diff[user] = perms
            else:
                for db, perm in perms.items():
                    if db in result[user]:
                        if perm != result[user][db]:
                            if perm == 'ALL' and result[user][db] == 'ALL PRIVILEGES':
                                pass
                            else:
                                if user not in diff:
                                    diff[user] = {}
                                diff[user][db] = perm
                    else:
                        pass
        else:
            diff[user] = perms
    return diff

def set_databases(databases):
    resp = {}
    for db in databases:
        query = auth()
        query['q'] = 'CREATE DATABASE ' + db
        req = request(query)
        ret = requests.post(req, verify=False, data=None).text
        resp[db] = ret
    return resp

def set_users(users, pillar):
    resp = {}
    for user in users:
        query = auth()
        pw = pillar[user]['pass']
        query['q'] = 'CREATE USER \"' + user + '\" WITH PASSWORD \'' + pw + '\''
        req = request(query)
        ret = requests.post(req, verify=False, data=None).text
        resp[user] = ret
    return resp

def set_grants(data):
    resp = {}
    query = auth()
    for user, databases in data.items():
        for db, perm in databases.items():
            if user not in resp:
                resp[user] = {}
            query['q'] = 'GRANT ' + perm + ' ON ' + db + ' TO ' + user
            req = request(query)
            ret = requests.post(req, verify=False, data=None).text
            resp[user][db] = ret
    return resp

def normalize_pillar(data):
    users = []
    databases = []
    for user, params in data.items():
        users.append(user)
        for db, grant in params['perms'].items():
            databases.append(db)
    return list(set(databases)), list(set(users))

def request(query):
    return 'https://' + HOST + ':8086/query?' + urllib.urlencode(query)

def auth():
    return  {
                'u': USER,
                'p': PASW
            }

databases = show_databases()
users = show_users()
grants = show_grants(PILLAR)

p_databases, p_users = normalize_pillar(PILLAR)

missing_databases = check_list(databases, p_databases)
missing_users = check_list(users, p_users)
missing_grants = check_grants(grants, PILLAR)

if CHK == True:
    if missing_databases:
        print 'Missing databases:'
        print json.dumps(missing_databases)
        sys.exit(1)
    elif missing_users:
        print 'Missing users:'
        print json.dumps(missing_users)
        sys.exit(1)
    elif missing_grants:
        print 'Missing grants:'
        print json.dumps(missing_grants)
        sys.exit(1)
    else:
        sys.exit(0)
else:
    if missing_databases:
        print 'Created databases:'
        print json.dumps(set_databases(missing_databases))
        grants = show_grants(PILLAR)
        missing_grants = check_grants(grants, PILLAR)
    if missing_users:
        print 'Created users:'
        print json.dumps(set_users(missing_users, PILLAR))
        grants = show_grants(PILLAR)
        missing_grants = check_grants(grants, PILLAR)
    if missing_grants:
        print 'Created permissions:'
        print missing_grants
        print json.dumps(set_grants(missing_grants))
