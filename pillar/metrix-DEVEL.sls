metrix:
  outputs:
    - db: telegraf
      url: https://192.168.56.160:8086
  influx:
    database: telegraf
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
