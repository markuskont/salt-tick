include:
  - tick.common.m2crypto

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

{{ pillar.metrix.pki.dir }}/ca.key:
  x509.private_key_managed:
    - bits: 4096

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
    - require:
      - file: {{ pillar.metrix.pki.dir }}
      - pkg: python-m2crypto
      - x509: {{ pillar.metrix.pki.dir }}/ca.key

cp.push ca.crt:
  module.wait:
    - name: cp.push
    - path: {{ pillar.metrix.pki.dir }}/ca.crt
    - watch:
      - x509: {{ pillar.metrix.pki.dir }}/ca.crt

#mine.send:
#  module.run:
#    - func: x509.get_pem_entries
#    - kwargs:
#        glob_path: {{ pillar.metrix.pki.dir }}/ca.crt
#    - onchanges:
#      - x509: {{ pillar.metrix.pki.dir }}/ca.crt
