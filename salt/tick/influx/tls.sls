include:
  - tick.common.m2crypto

/etc/influxdb/ssl:
  file.directory:
    - mode: 750
    - user: influxdb
    - require:
      - pkg: influxdb

/etc/influxdb/ssl/influx.private:
  x509.private_key_managed:
    - bits: 4096
    - require:
      - /etc/influxdb/ssl

/etc/influxdb/ssl/influx.cert:
  x509.certificate_managed:
    - ca_server: {{ pillar.metrix.pki.server }}
    - signing_policy: {{ pillar.metrix.pki.policy }}
    - CN: {{ grains.fqdn }}
    - days_remaining: 30
    - backup: True
    - public_key: /etc/influxdb/ssl/influx.private
    #- managed_private_key:
    #  - name: /etc/influxdb/ssl/influx.private
    #  - bits: 4096
    - require:
      - file: /etc/influxdb/ssl

/etc/influxdb/ssl/key.pem:
  file.managed:
    - source:
      - /etc/influxdb/ssl/influx.private
    - user: influxdb
    - mode: 640
    - require:
      - /etc/influxdb/ssl/influx.private
      - /etc/influxdb/ssl/influx.cert

/etc/influxdb/ssl/cert.pem:
  file.managed:
    - source:
      - /etc/influxdb/ssl/influx.cert
    - user: influxdb
    - mode: 644
    - require:
      - /etc/influxdb/ssl/influx.private
      - /etc/influxdb/ssl/influx.cert
