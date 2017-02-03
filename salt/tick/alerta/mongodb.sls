{% set os = grains.get('os')|lower %}

mongodb-org-server:
  pkgrepo.managed:
    - humanname: MongoDB repository
    - name: deb http://repo.mongodb.org/apt/{{os}} {{grains['oscodename']}}/mongodb-org/3.2 multiverse
    - file: /etc/apt/sources.list.d/mongodb-org.list
    - keyserver: keyserver.ubuntu.com
    - keyid: 0C49F3730359A14518585931BC711F9BA15703C6
    - clean_file: True
  pkg.latest:
    - refresh: True
  service.running:
    - name: mongod
    - enable: True
