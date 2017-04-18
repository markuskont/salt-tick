{% set os = grains.get('os')|lower %}
{% set conf_dir = '/etc/grafana' %}

grafana:
  pkgrepo.managed:
    - humanname: Grafana repository
    {% if grains['oscodename'] == 'trusty' %}
    - name: deb https://packagecloud.io/grafana/stable/debian/ wheezy main
    {% elif grains['oscodename'] == 'xenial' %}
    - name: deb https://packagecloud.io/grafana/stable/debian/ jessie main
    {% else %}
    - name: deb https://packagecloud.io/grafana/stable/{{ os }}/ {{ grains['oscodename']}} main
    {% endif %}
    - file: /etc/apt/sources.list.d/grafana.list
    - key_url: https://packagecloud.io/gpg.key
    - clean_file: true
    - require:
      - pkg: tick.dep
  pkg.latest:
    - refresh: True
  service.running:
    - name: grafana-server
    - enable: True
    - watch:
      - file: {{ conf_dir }}/grafana.ini
      {% if 'grafana_ldap' in pillar %}
      - file: {{ pillar.grafana.ldap.config_file }}
      {% endif %}

{{ conf_dir }}/grafana.ini:
  file.managed:
    - mode: 644
    - source: salt://tick/grafana/etc/grafana/grafana.ini
    - template: jinja
    - default:
      key: '{{ conf_dir }}/ssl/key.pem'
      cert: '{{ conf_dir }}/ssl/cert.pem'
      conf_dir: {{ conf_dir }}
    - require:
      - file: '{{ conf_dir }}/ssl/key.pem'
      - file: '{{ conf_dir }}/ssl/cert.pem'

{% if 'grafana_ldap' in pillar %}
{{ pillar.grafana.ldap.config_file }}:
  file.managed:
    - mode: 640
    - user: grafana
    - source: salt://tick/grafana/etc/grafana/ldap.toml
    - template: jinja
    - require:
      - pkg: grafana
{% endif %}
