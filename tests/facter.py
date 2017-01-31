#!/usr/bin/env python

import subprocess
from subprocess import Popen, PIPE
import json, os

def facter():
    binary = "/opt/puppetlabs/puppet/bin/facter"
    if os.path.isfile(binary):
        output = json.loads(subprocess.Popen([binary, '-p', '-j'], stdout=PIPE, stderr=PIPE).stdout.read().rstrip('\n'))
    else:
        output = None
    return {
        'facter': output
    }

print facter()
