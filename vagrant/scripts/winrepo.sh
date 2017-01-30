#!/usr/bin/env bash

REPODIR=/srv/salt/base/win/

salt-run winrepo.update_git_repos
service salt-master restart
