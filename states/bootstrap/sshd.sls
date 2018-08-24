
# Hardening sshd

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://bootstrap/conf/sshd_config
    - mode: 600
    - backup: minion


# Starting sshd

sshd:
  service.running:
    - watch:
      - file: /etc/ssh/sshd_config
    - onlyif: sshd -t
