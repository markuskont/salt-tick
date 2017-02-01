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
USRS = json.loads(ARGS.data)
CHK = ARGS.check

def show_users():
    query = {
        'u': USER,
        'p': PASW,
        'q': 'SHOW USERS'
    }
    req = request(query)
    ret = requests.get(req, verify=False).text
    data = json.loads(ret)
    arr = []
    for r in data["results"][0]["series"][0]["values"]:
        arr.append(r[0])
    return arr

def get_missing(result, pillar):
    diff = []
    for item in pillar:
        if item not in result:
            diff.append(item)
    return diff

def create_missing(users):
    resp = {}
    for user, pw in users.items():
        query = {
            'u': USER,
            'p': PASW,
            'q': 'CREATE USER \"' + user + '\" WITH PASSWORD \'' + pw + '\''
        }
        req = request(query)
        ret = requests.post(req, verify=False, data=None).text
        resp[user] = ret
    return resp

def request(query):
    return 'https://' + HOST + ':8086/query?' + urllib.urlencode(query)

us = show_users()
missing = get_missing(us, USRS)

if CHK == True:
    if not missing:
        sys.exit(0)
    else:
        for user in missing:
            print user
        sys.exit(1)
else:
    create = {}
    for user in list(USRS):
        if user not in missing:
            del USRS[user]
    print json.dumps(create_missing(USRS))
