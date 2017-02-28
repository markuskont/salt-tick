{% set os = grains.get('os')|lower %}

mongodb:
  pkg.latest:
    - refresh: True
  service.running:
    - name: mongodb
    - enable: True
