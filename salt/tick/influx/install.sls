influxdb:
  pkg.installed:
    - require:
      - pkgrepo: tick_repo
  service.running:
    - enable: True
    - watch:
      - file: /etc/influxdb/influxdb.conf
      - file: /etc/influxdb/ssl/key.pem
      - file: /etc/influxdb/ssl/cert.pem
    - require:
      - file: /etc/influxdb/influxdb.conf
      - file: /etc/influxdb/ssl/key.pem
      - file: /etc/influxdb/ssl/cert.pem

/etc/influxdb/influxdb.conf:
  file.managed:
    - mode: 644
    - source: salt://tick/influx/etc/influxdb/influxdb.conf
    - template: jinja
    - default:
      key: /etc/influxdb/ssl/key.pem
      cert: /etc/influxdb/ssl/cert.pem
    - require:
      - file: /etc/influxdb/ssl/key.pem
      - file: /etc/influxdb/ssl/cert.pem

#create_telegraf_db:
#  cmd.run:
#    - name: influx -execute "CREATE DATABASE telegraf"
#    - unless: influx -execute "SHOW DATABASES" | grep telegraf
#    - require:
#      - service: influxdb
