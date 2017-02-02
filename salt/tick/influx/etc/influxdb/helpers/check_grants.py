#!/usr/bin/env python

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
GRNT = json.loads(ARGS.data)
CHK = ARGS.check

def show_grants(pillar):
    current = {}
    query = auth()
    for user, perm in pillar.items():
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

def get_missing(result, pillar):
    diff = {}
    for user, grants in pillar.items():
        #if not result[user]:
        #    diff[user] = {}
        if user in result:
            if result[user] == None:
                diff[user] = pillar[user]
            else:
                for db, perm in grants.items():
                    if db in result[user]:
                        if perm != result[user][db]:
                            diff[user][db] = perm
                    else:
                        pass
                #if db in result[user]:
                #    pass
                #    #print db + ' : ' + perm
                #else:
                #    diff[user][db] = None
                #pass
        else:
            #if result[user]:
            diff[user] = grants
                #if result[user][db]:
                #    if result[user][db] != perm:
                #        print perm
    return diff

def create_missing(databases):
    resp = {}
    for db in databases:
        query = {
            'u': USER,
            'p': PASW,
            'q': 'CREATE DATABASE ' + db
        }
        req = request(query)
        ret = requests.post(req, verify=False, data=None).text
        resp[db] = ret
    return resp

def request(query):
    return 'https://' + HOST + ':8086/query?' + urllib.urlencode(query)

def auth():
    return {
                'u': USER,
                'p': PASW
            }

existing = show_grants(GRNT)
missing = get_missing(existing, GRNT)
print json.dumps(existing)
print json.dumps(missing)
#
#if CHK == True:
#    if not missing:
#        sys.exit(0)
#    else:
#        print missing
#        sys.exit(1)
#else:
#    print json.dumps(create_missing(missing))
