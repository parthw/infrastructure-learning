
# check whether cassandra service is present or not and stop it first to start optimization


# Appending limits.conf

appending_in_limits_conf:
  file.append:
    - name: /etc/security/limits.conf
    - text:
      - casandra - memlock unlimited
      - cassandra - nofile 100000
      - cassandra - nproc 32768
      - cassandra - as unlimited
