
# Updating auth configurations

/etc/login.defs:
  file.managed:
    - source: salt://bootstrap/conf/login.defs
    - backup: minion

/etc/pam.d/system-auth:
  file.managed:
    - source: salt://bootstrap/conf/system-auth
    - backup: minion

/etc/pam.d/password-auth:
  file.managed:
    - source: salt://bootstrap/conf/password-auth
    - backup: minion
