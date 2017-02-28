alerting:
  influx:
    {{ grains.fqdn }}:
      default: 'true'
      enabled: 'true'
      urls:
        - '"https://{{ grains.fqdn }}:8086"'
      username: admin
      password: test1234
      timeout: 0
      tls: true
      ssl:
        ca: ssl/ca.pem
        key: ssl/key.pem
        cert: ssl/cert.pem
      subscriptions:
        telegraf:
          - '"default"'
          - '"autogen"'
  alerta:
    - 192.168.56.162:8080
  smtp:
    enabled: 'true'
    host: localhost
    port: 25
    username: ''
    password: ''
    from: 'kapacitor@localhost'
    to:
      - '"root@localhost"'
