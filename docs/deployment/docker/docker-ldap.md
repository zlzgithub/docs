# Docker安装LDAP服务



```yaml
ldap:
  image: osixia/openldap
  volumes:
    - /data/ldap/ldap:/var/lib/ldap
    - /data/ldap/slapd.d:/etc/ldap/slapd.d
  ports:
    - 389:389
  environment:
    LDAP_TLS: false \
    LDAP_ORGANISATION: "lzzeng" \
    LDAP_DOMAIN: "lzzeng.cn" \
    LDAP_ADMIN_PASSWORD: "ldap@dmin" \
    LDAP_CONFIG_PASSWORD: "ldap@dmin" \
  restart: always

ldapadmin:
  image: osixia/phpldapadmin
  link:
    - ldap
  ports:
    - 8090:80
  environment:
    PHPLDAPADMIN_HTTPS: false
    PHPLDAPADMIN_LDAP_HOSTS: ldap
  restart: always
```

