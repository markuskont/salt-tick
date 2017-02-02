kapacitor:
  outputs:
    - db: telegraf
      host: influx
      port: 8086
      tls: true
      key: ssl/key.pem
      cert: ssl/cert.pem
      cacert: ssl/ca.pem
      username: telegraf
      password: STRONK123
  pki:
    server: influx
    policy: metrix
    dir: /srv/pki-kapacitor
    country: Estonia
    state: Harjumaa
    location: Tallinn
    org: Cats&dogs&cows ltd
