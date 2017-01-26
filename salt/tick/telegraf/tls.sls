include:
  - tick.common.m2crypto

/etc/telegraf/ssl:
  file.directory:
    - mode: 750
    - user: telegraf
    - require:
      - pkg: telegraf

/etc/telegraf/ssl/telegraf.private:
  x509.private_key_managed:
    - bits: 4096
    - require:
      - /etc/telegraf/ssl

/etc/telegraf/ssl/telegraf.cert:
  x509.certificate_managed:
    - ca_server: {{ pillar.metrix.pki.server }}
    - signing_policy: {{ pillar.metrix.pki.policy }}
    - CN: {{ grains.fqdn }}
    - days_remaining: 30
    - backup: True
    - public_key: /etc/telegraf/ssl/telegraf.private
    #- managed_private_key:
    #  - name: /etc/telegraf/ssl/telegraf.private
    #  - bits: 4096
    - require:
      - file: /etc/telegraf/ssl
      - x509: /etc/telegraf/ssl/telegraf.private

/etc/telegraf/ssl/key.pem:
  file.managed:
    - source:
      - /etc/telegraf/ssl/telegraf.private
    - user: telegraf
    - mode: 640
    - require:
      - /etc/telegraf/ssl/telegraf.private
      - /etc/telegraf/ssl/telegraf.cert

/etc/telegraf/ssl/cert.pem:
  file.managed:
    - source:
      - /etc/telegraf/ssl/telegraf.cert
    - user: telegraf
    - mode: 644
    - require:
      - /etc/telegraf/ssl/telegraf.private
      - /etc/telegraf/ssl/telegraf.cert

/etc/telegraf/ssl/ca.pem:
  file.managed:
    - source:
      - salt://{{pillar.metrix.pki.server}}/files{{pillar.metrix.pki.dir}}/ca.crt
