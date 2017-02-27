include:
  - tick.common.deps

{% set conf_dir = '/etc/kapacitor' %}

{{ conf_dir }}/ssl:
  file.directory:
    - mode: 750
    - user: kapacitor
    - require:
      - pkg: kapacitor
      - pkg: tick.dep

{{ conf_dir }}/ssl/ca.pem:
  file.managed:
    - source:
      - salt://{{pillar.metrix.pki.server}}/files{{pillar.metrix.pki.dir}}/ca.crt
    - require:
      - {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/kapacitor.private:
  x509.private_key_managed:
    - bits: 4096
    - require:
      - {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/kapacitor.cert:
  x509.certificate_managed:
    - ca_server: {{ pillar.metrix.pki.server }}
    - signing_policy: {{ pillar.metrix.pki.policy }}
    - CN: {{ grains.fqdn }}
    - days_remaining: 30
    - backup: True
    - public_key: {{ conf_dir }}/ssl/kapacitor.private
    #- managed_private_key:
    #  - name: {{ conf_dir }}/ssl/kapacitor.private
    #  - bits: 4096
    - require:
      - file: {{ conf_dir }}/ssl

{{ conf_dir }}/ssl/key.pem:
  file.managed:
    - source:
      - {{ conf_dir }}/ssl/kapacitor.private
    - user: kapacitor
    - mode: 640
    - require:
      - {{ conf_dir }}/ssl/kapacitor.private
      - {{ conf_dir }}/ssl/kapacitor.cert

{{ conf_dir }}/ssl/cert.pem:
  file.managed:
    - source:
      - {{ conf_dir }}/ssl/kapacitor.cert
    - user: kapacitor
    - mode: 644
    - require:
      - {{ conf_dir }}/ssl/kapacitor.private
      - {{ conf_dir }}/ssl/kapacitor.cert
