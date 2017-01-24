influx:
  auth: true
  ssl: true
  users:
    telegraf: STRONK123
    grafana: WEEK456
  databases:
    telegraf:
      write:
        - telegraf
      read:
        - grafana
