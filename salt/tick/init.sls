tick.influx_ca_setup:
  salt.state:
    - tgt: 'G@roles:influx and G@roles:ca and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.pki.ca
    - saltenv: {{ saltenv }}

tick.influx_db_and_kapacitor_setup:
  salt.state:
    - tgt: 'G@roles:influx and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.server
    - require:
      - salt: tick.influx_ca_setup
    - saltenv: {{ saltenv }}

tick.metrix_agent_setup:
  salt.state:
    - tgt: 'G@roles:metrix and G@env:{{ saltenv }}'
    - tgt_type: compound
    - sls: tick.metrix
    - require:
      - salt: tick.influx_ca_setup
      - salt: tick.influx_db_and_kapacitor_setup
    - saltenv: {{ saltenv }}
