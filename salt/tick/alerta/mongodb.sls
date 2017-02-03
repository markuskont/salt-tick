{% set os = grains.get('os')|lower %}
{% set version = '3.0' %}

mongodb-org-server:
  pkgrepo.managed:
    - humanname: MongoDB repository
    - name: deb http://repo.mongodb.org/apt/{{os}} {{grains['oscodename']}}/mongodb-org/{{ version }} multiverse
    - file: /etc/apt/sources.list.d/mongodb-org.list
    - keyserver: keyserver.ubuntu.com
    - keyid: 7F0CEB10
    - clean_file: True
  pkg.latest:
    - refresh: True
    - require:
      - pkgrepo: mongodb-org-server
  service.running:
    - name: mongod
    - enable: True
    - require:
      - pkgrepo: mongodb-org-server
