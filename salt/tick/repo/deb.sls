{% set os = grains.get('os')|lower %}
apt-transport-https:
  pkg.installed
tick_repo:
  pkgrepo.managed:
    - humanname: TICK stack repository from Influxdata
    - name: deb https://repos.influxdata.com/{{ os }} {{ grains['oscodename']}} stable
    - key_url: https://repos.influxdata.com/influxdb.key
    - file: /etc/apt/sources.list.d/influxdata.list
    - clean_file: True
    - require:
      - pkg: apt-transport-https
