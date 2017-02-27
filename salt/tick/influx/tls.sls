include:
  - tick.common.deps

{% set conf_dir = '/etc/influxdb' %}

{{ conf_dir }}/ssl:
  file.directory:
    - mode: 750
    - user: influxdb
    - require:
      - pkg: influxdb
      - pkg: tick.dep

{{ conf_dir }}/ssl/influx.private:
  x509.private_key_managed:
    - bits: 4096
    - require:
      - {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/influx.cert:
  x509.certificate_managed:
    - ca_server: {{ pillar.metrix.pki.server }}
    - signing_policy: {{ pillar.metrix.pki.policy }}
    - CN: {{ grains.fqdn }}
    - days_remaining: 30
    - backup: True
    - public_key: {{ conf_dir }}/ssl/influx.private
    - require:
      - file: {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/key.pem:
  file.managed:
    - source:
      - {{ conf_dir }}/ssl/influx.private
    - user: influxdb
    - mode: 640
    - require:
      - {{ conf_dir }}/ssl/influx.private
      - {{ conf_dir }}/ssl/influx.cert

{{ conf_dir }}/ssl/cert.pem:
  file.managed:
    - source:
      - {{ conf_dir }}/ssl/influx.cert
    - user: influxdb
    - mode: 644
    - require:
      - {{ conf_dir }}/ssl/influx.private
      - {{ conf_dir }}/ssl/influx.cert

{{ conf_dir }}/ssl/ca.pem:
  file.managed:
    - source:
      - salt://{{pillar.metrix.pki.server}}/files{{pillar.metrix.pki.dir}}/ca.crt
