{% from "tick/telegraf/map.jinja" import map with context %}

{{ map.conf_dir }}/{{ map.service }}.conf:
  file.managed:
    - source: salt://tick/telegraf/config/main.jinja
    - template: jinja
    - default:
      outputs: {{ pillar.metrix.outputs }}
      key: {{ map.conf_dir }}/ssl/key.pem
      cert: {{ map.conf_dir }}/ssl/cert.pem
      cacert: {{ map.conf_dir }}/ssl/ca.pem
    - require:
      - file: {{ map.conf_dir }}/ssl/key.pem
      - file: {{ map.conf_dir }}/ssl/cert.pem
      - file: {{ map.conf_dir }}/ssl/ca.pem
