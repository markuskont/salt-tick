{% set os = grains.get('os')|lower %}

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
      - file: /etc/grafana/grafana.ini

/etc/grafana/grafana.ini:
  file.managed:
    - mode: 644
    - source: salt://tick/grafana/etc/grafana/grafana.ini
    - template: jinja
    - default:
      key: '/etc/grafana/ssl/key.pem'
      cert: '/etc/grafana/ssl/cert.pem'
    - require:
      - file: '/etc/grafana/ssl/key.pem'
      - file: '/etc/grafana/ssl/cert.pem'
