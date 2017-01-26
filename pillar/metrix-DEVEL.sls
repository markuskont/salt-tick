metrix:
  outputs:
    - db: telegraf
      host: influx
      port: 8086
      tls: true
      key: /etc/telegraf/ssl/key.pem
      cert: /etc/telegraf/ssl/cert.pem
      cacert: /etc/telegraf/ssl/ca.pem
      user: telegraf
      password: STRONK123
  pki:
    server: influx
    policy: metrix
    dir: /srv/pki-metrix
    country: Estonia
    state: Harjumaa
    location: Tallinn
    org: Cats&dogs ltd
