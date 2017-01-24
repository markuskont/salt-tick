DEVEL:
#  'G@kernel:linux and G@os_family:Debian and G@roles:metrix':
#    - match: compound
#    - tick.repo.deb
#  'G@kernel:linux and G@os_family:RedHat and G@roles:metrix':
#    - match: compound
#    - tick.repo.redhat
  'G@roles:metrix':
    - match: compound
    - tick.telegraf
  'G@roles:influx':
    - match: compound
    - tick.influx
  'G@roles:grafana':
    - match: compound
    - tick.grafana
