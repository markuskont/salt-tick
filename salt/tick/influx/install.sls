influxdb:
  pkg.installed:
    - require:
      - pkgrepo: tick_repo
  service.running:
    - enable: True
#    - watch:
#      - file: /etc/influxdb/influxdb.conf
