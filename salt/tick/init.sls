tick.influx_ca_setup:
  salt.state:
    - tgt: 'G@roles:influx and G@roles:ca and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.pki.ca
    - saltenv: {{ saltenv }}

tick.influxdb_setup:
  salt.state:
    - tgt: 'G@roles:influx and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.influx
    - require:
      - salt: tick.influx_ca_setup
    - saltenv: {{ saltenv }}

tick.kapacitor_setup:
  salt.state:
    - tgt: 'G@roles:kapacitor and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.kapacitor
    - require:
      - salt: tick.influx_ca_setup
      - salt: tick.influxdb_setup
    - saltenv: {{ saltenv }}

tick.metrix_agent_setup:
  salt.state:
    - tgt: 'G@roles:metrix and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.metrix
    - require:
      - salt: tick.influx_ca_setup
      - salt: tick.influxdb_setup
      - salt: tick.kapacitor_setup
    - saltenv: {{ saltenv }}
