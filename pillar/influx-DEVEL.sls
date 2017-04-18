influx:
  auth: true
  ssl: true
  admin:
    user: admin
    pw: test1234
  grants:
    telegraf:
      pass: STRONK123
      perms:
        telegraf: WRITE
    grafana:
      pass: WEEK456
      perms:
        telegraf: READ
        writeback: READ

grafana:
  ssl: true
  ldap:
    enabled: 'false'
    config_file: '/etc/grafana/ldap.toml'
    allow_sign_up: 'false'

grafana_ldap:
  verbose_logging: 'true'
  servers:
    host: 'ldap.ex'
    port: 389
    use_ssl: 'false'
    ssl_skip_verify: 'false'
    root_ca_cert: /path/to/certificate.crt
    bind_dn: 'grafana'
    bind_password: 'TOOSTRONK'
    search_filter: '(sAMAccountName=%s)'
    search_base_dns: '["ou=COMPANY,dc=SLD,dc=TLD"]'
    group_search_base_dns: '["ou=GROUPS,ou=COMPANY,dc=SLD,dc=TLD"]'
  attributes:
    name: "givenName"
    surname: "sn"
    username: "cn"
    member_of: "memberOf"
    email:  "email"
  group_mappings:
    - group_dn: "CN=ADMIN,OU=GROUPS,OU=COMPANY,DC=SLD,DC=TLD"
      org_role: "Admin"
    - group_dn: "*"
      org_role: "Viewer"
