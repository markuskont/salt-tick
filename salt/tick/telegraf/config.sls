{% from "tick/telegraf/map.jinja" import map with context %}

{{ map.conf_dir }}/{{ map.service }}.conf:
  file.managed:
    - source: salt://tick/telegraf/config/main.jinja
    - template: jinja
    - default:
      outputs: {{ pillar.metrix.outputs }}
      dir: {{ map.conf_dir }}
    - require:
      {% if grains.kernel == 'Linux' %}
      - pkg: {{ map.service }}
      {% endif %}
      - file: {{ map.conf_dir }}/ssl/key.pem
      - file: {{ map.conf_dir }}/ssl/cert.pem
      - file: {{ map.conf_dir }}/ssl/ca.pem

ensure_telegraf_service:
  service.running:
    - name: {{ map.service }}
    - enable: True
    - watch:
      - file: '{{map.conf_dir}}/{{ map.service }}.conf'
      - file: {{map.conf_dir}}/ssl/key.pem
      - file: {{map.conf_dir}}/ssl/cert.pem
      - file: {{map.conf_dir}}/ssl/ca.pem
    - require:
      - '{{ map.conf_dir }}/{{ map.service }}.conf'
      - file: {{map.conf_dir}}/ssl/key.pem
      - file: {{map.conf_dir}}/ssl/cert.pem
      - file: {{map.conf_dir}}/ssl/ca.pem
