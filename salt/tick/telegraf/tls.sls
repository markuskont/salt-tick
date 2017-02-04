{% from "tick/telegraf/map.jinja" import map with context %}

include:
  - tick.common.m2crypto

{{ map.conf_dir }}/ssl:
  file.directory:
    {% if grains.kernel == 'Linux' %}
    - mode: 750
    {% endif %}
    - user: {{ map.user }}
    - require:
      {% if grains.kernel == 'Linux' %}
      - pkg: telegraf
      {% elif grains.kernel == 'Windows' %}
      - cmd: install_win_service
      {% endif %}

{{ map.conf_dir }}/ssl/telegraf.private:
  x509.private_key_managed:
    - bits: 4096
    - require:
      - {{ map.conf_dir }}/ssl
      {% if grains.kernel == 'Linux' %}
      - pkg: python-m2crypto
      {% endif %}

{{ map.conf_dir }}/ssl/telegraf.cert:
  x509.certificate_managed:
    - ca_server: {{ pillar.metrix.pki.server }}
    - signing_policy: {{ pillar.metrix.pki.policy }}
    - CN: {{ grains.fqdn }}
    - days_remaining: 30
    - backup: True
    - public_key: {{ map.conf_dir }}/ssl/telegraf.private
    #- managed_private_key:
    #  - name: {{ map.conf_dir }}/ssl/telegraf.private
    #  - bits: 4096
    - require:
      {% if grains.kernel == 'Linux' %}
      - pkg: python-m2crypto
      {% endif %}
      - file: {{ map.conf_dir }}/ssl
      - x509: {{ map.conf_dir }}/ssl/telegraf.private

{{ map.conf_dir }}/ssl/key.pem:
  file.managed:
    - source: '{{ map.conf_dir }}/ssl/telegraf.private'
    - user: {{ map.user }}
    {% if grains.kernel == 'Linux' %}
    - mode: 640
    {% endif %}
    - require:
      - '{{ map.conf_dir }}/ssl/telegraf.private'
      - '{{ map.conf_dir }}/ssl/telegraf.cert'

{{ map.conf_dir }}/ssl/cert.pem:
  file.managed:
    - source: '{{ map.conf_dir }}/ssl/telegraf.cert'
    - user: {{ map.user }}
    {% if grains.kernel == 'Linux' %}
    - mode: 644
    {% endif %}
    - require:
      - '{{ map.conf_dir }}/ssl/telegraf.private'
      - '{{ map.conf_dir }}/ssl/telegraf.cert'

{{ map.conf_dir }}/ssl/ca.pem:
  file.managed:
    - source:
      - salt://{{pillar.metrix.pki.server}}/files{{pillar.metrix.pki.dir}}/ca.crt
