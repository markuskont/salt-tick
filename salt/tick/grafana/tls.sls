include:
  - tick.common.deps

{% set conf_dir = '/etc/grafana' %}

{{ conf_dir }}/ssl:
  file.directory:
    - mode: 750
    - user: grafana
    - require:
      - pkg: grafana
      - pkg: tick.dep

{{ conf_dir }}/ssl/ca.pem:
  file.managed:
    - source:
      - salt://{{pillar.metrix.pki.server}}/files{{pillar.metrix.pki.dir}}/ca.crt
    - require:
      - {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/grafana.private:
  x509.private_key_managed:
    - bits: 4096
    - require:
      - {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/grafana.cert:
  x509.certificate_managed:
    - ca_server: {{ pillar.metrix.pki.server }}
    - signing_policy: {{ pillar.metrix.pki.policy }}
    - CN: {{ grains.fqdn }}
    - days_remaining: 30
    - backup: True
    - public_key: {{ conf_dir }}/ssl/grafana.private
    - require:
      - file: {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/key.pem:
  file.managed:
    - source:
      - {{ conf_dir }}/ssl/grafana.private
    - user: grafana
    - mode: 640
    - require:
      - {{ conf_dir }}/ssl/grafana.private
      - {{ conf_dir }}/ssl/grafana.cert

{{ conf_dir }}/ssl/cert.pem:
  file.managed:
    - source:
      - {{ conf_dir }}/ssl/grafana.cert
    - user: grafana
    - mode: 644
    - require:
      - {{ conf_dir }}/ssl/grafana.private
      - {{ conf_dir }}/ssl/grafana.cert
