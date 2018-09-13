
# Enabling 443 port in OUTBOUND chain

iptables_allow_443:
  iptables.insert:
    - table: filter
    - chain: OUTBOUND
    - jump: ACCEPT
    - protocol: tcp
    - dport: 443
    - position: 1


# Disabling 443 port from OUTBOUND chain

iptables_remove_443:
  iptables.delete:
    - table: filter
    - chain: OUTBOUND
    - jump: ACCEPT
    - protocol: tcp
    - dport: 443
    - save: True
    - require:
      - {{ }}

