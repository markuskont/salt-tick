{% from "tick/telegraf/map.jinja" import map with context %}

{{ map.conf_dir }}/{{ map.service }}.conf:
  file.managed:
    - source: salt://tick/telegraf/config/main.jinja
    - template: jinja
    - default:
      outputs: {{ pillar.metrix.outputs }}
    #  key: /etc/telegraf/ssl/key.pem
    #  cert: /etc/telegraf/ssl/cert.pem
    #  cacert: /etc/telegraf/ssl/ca.pem
    #- require:
    #  - file: /etc/telegraf/ssl/key.pem
    #  - file: /etc/telegraf/ssl/cert.pem
    #  - file: /etc/telegraf/ssl/ca.pem
