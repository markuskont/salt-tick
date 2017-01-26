tick.influx_ca_setup:
  salt.state:
    - tgt: 'G@roles:influx and G@roles:ca'
    - tgt_type: compound
    - sls: tick.pki.ca

tick.influx_db_and_kapacitor_setup:
  salt.state:
    - tgt: 'G@roles:influx'
    - tgt_type: compound
    - sls: tick.server
    - require:
      - salt: tick.influx_ca_setup

tick.metrix_agent_setup:
  salt.state:
    - tgt: 'G@roles:metrix'
    - tgt_type: compound
    - sls: tick.metrix
    - require:
      - salt: tick.influx_ca_setup
      - salt: tick.influx_db_and_kapacitor_setup
