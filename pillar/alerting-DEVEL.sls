alerting:
  influx:
    {{ grains.fqdn }}:
      default: true
      enabled: true
      urls:
        - '"https://{{ grains.fqdn }}:8086"'
      username: kapa
      password: SLEEP873
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
