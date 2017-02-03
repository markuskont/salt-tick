#!/usr/bin/env python

import socket
import yaml
import subprocess

hostname = socket.gethostname()
grains = {
    'roles': [ 'metrix' ]
}
command = ['service', 'salt-minion', 'restart']

if 'influx' in hostname:
    grains['roles'].append('influx')
    grains['roles'].append('kapacitor')
    grains['roles'].append('chronograf')
    grains['roles'].append('grafana')
    grains['roles'].append('ca')
if 'alerta' in hostname:
    grains['roles'].append('alerta')

with open('/etc/salt/grains', 'w') as outfile:
    yaml.dump(grains, outfile, default_flow_style=False)

subprocess.call(command, shell=False)
