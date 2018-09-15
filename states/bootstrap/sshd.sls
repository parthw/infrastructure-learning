
# Hardening sshd

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://bootstrap/conf/sshd_config
    - mode: 600
    - backup: minion


# Adding banner-note before ssh

/etc/banner-note:
  file.managed:
    - mode: 644
    - source: salt://bootstrap/conf/banner-note
    - backup: minion 


# Adding banner-note after ssh

/etc/motd.sh:
  file.managed:
    - mode: 755
    - source: salt://bootstrap/conf/motd.sh
    - template: jinja
    - backup: minion 


# Starting sshd

sshd:
  service.running:
    - watch:
      - file: /etc/ssh/sshd_config
    - onlyif: sshd -t
