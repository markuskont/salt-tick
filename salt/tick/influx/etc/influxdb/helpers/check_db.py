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
    parser.add_argument('-d','--databases', nargs='+', default=['telegraf'])
    parser.add_argument('-c','--check', action='store_true', default=False)
    return parser.parse_args()

ARGS = parse_arguments()
HOST = ARGS.fqdn
USER = ARGS.user
PASW = ARGS.password
DATB = ARGS.databases
CHK = ARGS.check

def show_databases():
    query = {
        'u': USER,
        'p': PASW,
        'q': 'SHOW DATABASES'
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

db = show_databases()
missing = get_missing(db, DATB)

if CHK == True:
    if not missing:
        sys.exit(0)
    else:
        print missing
        sys.exit(1)
else:
    print json.dumps(create_missing(missing))
