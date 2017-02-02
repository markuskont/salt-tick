influx:
  auth: true
  ssl: true
  admin:
    user: admin
    pw: test1234
  grants:
    telegraf:
      pass: STRONK123
      perms:
        telegraf: WRITE
    grafana:
      pass: WEEK456
      perms:
        telegraf: READ
        writeback: READ
    kapa:
      pass: SLEEP873
      perms:
        telegraf: ALL
        writeback: ALL
