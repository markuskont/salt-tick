metrix:
  outputs:
    - db: telegraf
      host: influx
      port: 8086
      tls: true
      key: ssl/key.pem
      cert: ssl/cert.pem
      cacert: ssl/ca.pem
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
