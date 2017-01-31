create_admin_user:
  cmd.run:
    - name: curl -ss -k -XPOST https://{{ grains.fqdn }}:8086/query --data-urlencode "q=CREATE USER "{{ pillar.influx.admin.user }}" WITH PASSWORD '{{ pillar.influx.admin.pw }}' WITH ALL PRIVILEGES"
    - onlyif: curl -ss -k -G https://{{ grains.fqdn }}:8086/query --data-urlencode "q=show databases" | grep "create admin user first or disable authentication"
    - require:
      - file: /etc/influxdb/influxdb.conf
      - service: influxdb
