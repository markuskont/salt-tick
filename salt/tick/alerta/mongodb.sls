{% set os = grains.get('os')|lower %}

mongodb-org-server:
  pkgrepo.managed:
    - humanname: MongoDB repository
    - name: deb http://repo.mongodb.org/apt/{{os}} {{grains['oscodename']}}/mongodb-org/3.0 multiverse
    - file: /etc/apt/sources.list.d/mongodb-org-3.0.list
    - keyserver: keyserver.ubuntu.com
    - keyid: 7F0CEB10
    - clean_file: True
  pkg.latest:
    - refresh: True
  service.running:
    - name: mongod
    - enable: True
