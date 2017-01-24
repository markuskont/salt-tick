{% from "tick/telegraf/map.jinja" import map with context %}

{{ map.conf_dir }}/{{ map.service }}.conf:
  file.managed:
    - source: salt://tick/telegraf/config/main.jinja
    - template: jinja
    - default:
      outputs: {{ pillar.metrix.outputs }}
