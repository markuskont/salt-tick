{% set config = '/etc/kapacitor/kapacitor.conf' %}
{% set conf_dir = '/etc/kapacitor' %}

kapacitor:
  pkg.installed:
    - require:
      - pkgrepo: tick_repo
  service.running:
    - enable: True
    - require:
      - {{config}}
      - file: {{ conf_dir }}/ssl/ca.pem
      - file: {{ conf_dir }}/ssl/key.pem
      - file: {{ conf_dir }}/ssl/cert.pem
    - watch:
      - {{config}}
      - file: {{ conf_dir }}/ssl/ca.pem
      - file: {{ conf_dir }}/ssl/key.pem
      - file: {{ conf_dir }}/ssl/cert.pem

{{config}}:
  file.managed:
    - mode: 640
    - source: salt://tick/kapacitor/etc/kapacitor/kapacitor.jinja
    - user: kapacitor
    - template: jinja
    - default:
      conf_dir: '/etc/kapacitor'
