{% set config = '/etc/kapacitor/kapacitor.conf' %}

kapacitor:
  pkg.installed:
    - require:
      - pkgrepo: tick_repo
  service.running:
    - enable: True
    - watch:
      - {{config}}

{{config}}:
  file.managed:
    - mode: 644
    - source: salt://kapacitor/kapacitor.jinja
    - template: jinja
