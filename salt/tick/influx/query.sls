ensure_pkgs:
  pkg.installed:
    - pkgs:
      - curl

create_admin_user:
  cmd.run:
    - name: curl -ss -k -XPOST https://{{ grains.fqdn }}:8086/query --data-urlencode "q=CREATE USER "{{ pillar.influx.admin.user }}" WITH PASSWORD '{{ pillar.influx.admin.pw }}' WITH ALL PRIVILEGES"
    - onlyif: curl -ss -k -G https://{{ grains.fqdn }}:8086/query --data-urlencode "q=show databases" | grep "create admin user first or disable authentication"
    - require:
      - file: /etc/influxdb/influxdb.conf
      - service: influxdb
      - pkg: ensure_pkgs

/etc/influxdb/helpers:
  file.directory:
    - mode: 750
    - require:
      - cmd: create_admin_user

/etc/influxdb/helpers/check_grants.py:
  file.managed:
    - source: salt://tick/influx/etc/influxdb/helpers/check_grants.py
    - mode: 750
    - user: influxdb
    - require:
      - file: /etc/influxdb/helpers
      - cmd: create_admin_user

create_databases:
  cmd.script:
    - name: /etc/influxdb/helpers/check_grants.py
    - unless: /etc/influxdb/helpers/check_grants.py --check -f {{ grains.fqdn }} -u {{ pillar.influx.admin.user }} -p {{ pillar.influx.admin.pw }} -d '{{ pillar.influx.grants|json|replace(' ', '') }}'
    - args: -f {{ grains.fqdn }} -u {{ pillar.influx.admin.user }} -p {{ pillar.influx.admin.pw }} -d '{{ pillar.influx.grants|json|replace(' ', '') }}'
    - require:
      - cmd: create_admin_user
      - file: /etc/influxdb/helpers/check_grants.py
      - service: influxdb
      - file: /etc/influxdb/influxdb.conf
