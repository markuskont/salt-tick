/etc/kapacitor/ticks:
  file.recurse:
    - source: salt://tick/kapacitor/etc/kapacitor/ticks
    - dir_mode: 750
    - file_mode: 640
    - user: kapacitor
    - group: kapacitor
    - require:
      - pkg: kapacitor
