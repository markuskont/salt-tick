salt-minion:
  service.running:
    - enable: True
    - listen:
      - file: /etc/salt/minion.d/signing_policies.conf

/etc/salt/minion.d/signing_policies.conf:
  file.managed:
    - source: salt://tick/pki/files/signing_policies.jinja
    - template: jinja

{{ pillar.metrix.pki.dir }}:
  file.directory: []

{{ pillar.metrix.pki.dir }}/issued_certs:
  file.directory: []

{{ pillar.metrix.pki.dir }}/ca.crt:
  x509.certificate_managed:
    - signing_private_key: {{ pillar.metrix.pki.dir }}/ca.key
    - CN: {{ grains.fqdn }}
    - C: {{ pillar.metrix.pki.country }}
    - ST: {{ pillar.metrix.pki.state }}
    - L: {{ pillar.metrix.pki.location }}
    - O: {{ pillar.metrix.pki.org }}
    - basicConstraints: "critical CA:true"
    - keyUsage: "critical cRLSign, keyCertSign"
    - subjectKeyIdentifier: hash
    - authorityKeyIdentifier: keyid,issuer:always
    - days_valid: 3650
    - days_remaining: 0
    - backup: True
    - managed_private_key:
        name: {{ pillar.metrix.pki.dir }}/ca.key
        bits: 4096
        backup: True
    - require:
      - file: {{ pillar.metrix.pki.dir }}

mine.send:
  module.run:
    - func: x509.get_pem_entries
    - kwargs:
        glob_path: {{ pillar.metrix.pki.dir }}/ca.crt
    - onchanges:
      - x509: {{ pillar.metrix.pki.dir }}/ca.crt
