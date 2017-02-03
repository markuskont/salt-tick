base:
  'roles:influx':
    - match: grain
    - influx-DEVEL
  'roles:metrix':
    - match: grain
    - metrix-DEVEL
  'G@roles:kapacitor':
    - match: compound
    - metrix-DEVEL
    - alerting-DEVEL
