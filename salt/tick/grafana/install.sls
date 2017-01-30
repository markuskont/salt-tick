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
      - pkg: apt-transport-https
  pkg.latest:
    - refresh: True
  service.running:
    - name: grafana-server
    - enable: True
#    - watch:
#      - file: /etc/grafana/grafana.ini
#
#/etc/grafana/grafana.ini:
#  file.managed:
#    - mode: 644
#    - source: salt://influxdb/grafana.jinja
#    - template: jinja