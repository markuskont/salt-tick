influx:
  auth: true
  ssl: true
  admin:
    user: admin
    pw: test1234
  users:
    telegraf: STRONK123
    grafana: WEEK456
  databases:
    telegraf:
      write:
        - telegraf
      read:
        - grafana
