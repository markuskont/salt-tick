{% from "tick/telegraf/map.jinja" import map with context %}

{% if grains.kernel == 'Linux' %}
{{ map.service }}:
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: tick_repo
  service.running:
    - enable: True
    - watch:
      - file: {{map.conf_dir}}/{{ map.service }}.conf
      - file: /etc/telegraf/ssl/key.pem
      - file: /etc/telegraf/ssl/cert.pem
      - file: /etc/telegraf/ssl/ca.pem
    - require:
      - {{ map.conf_dir }}/{{ map.service }}.conf
      - file: /etc/telegraf/ssl/key.pem
      - file: /etc/telegraf/ssl/cert.pem
      - file: /etc/telegraf/ssl/ca.pem
{% elif grains.kernel == 'Windows' and grains.cpuarch == 'AMD64' %}
create_telegraf_dir:
  file.directory:
    - name: {{ map.conf_dir }}
push_telegraf_binary:
  file.managed:
    - name: '{{map.conf_dir}}\{{ map.service }}.exe'
    - source: salt://tick/telegraf/binary/{{ map.service }}-x64.exe
    - require:
      - {{ map.conf_dir }}
install_win_service:
  cmd.run:
    - name: '"{{ map.conf_dir }}\{{ map.service }}.exe" --service install'
    - unless: 'C:\windows\system32\cmd.exe /c sc.exe query telegraf'
    - shell: 'windows'
    - require:
      - '{{ map.conf_dir }}\{{ map.service }}.exe'
ensure_telegraf_service:
  service.running:
    - name: {{ map.service }}
    - enable: True
    - watch:
      - '{{ map.conf_dir }}\{{ map.service }}.conf'
{% endif %}
