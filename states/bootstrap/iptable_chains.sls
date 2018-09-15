{% for trusted_range in grains['custom_grains']['trusted_ip_ranges']  %}


# Allowing port 22 in OUTPUT chain

allowing_{{ trusted_range  }}_port_22_in_OUTPUT:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: OUTPUT
    - destination: {{ trusted_range }}
    - jump: ACCEPT
    - sport: 22
    - protocol: tcp
    - comment: "SaltBootstrap: for ssh"
    - save: True


# Allowing port 22 in INPUT chain

allowing_{{ trusted_range }}_port_22_in_INPUT:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - source: {{ trusted_range }}
    - jump: ACCEPT
    - dport: 22
    - protocol: tcp
    - comment: "SaltBootstrap: for ssh"

{% endfor %}

# Creating INBOUND chain

iptables_creating_INBOUND_chain:
  iptables.chain_present:
    - name: INBOUND
    - table: filter


# Creating OUTBOUND chain

iptables_creating_OUTBOUND_chain:
  iptables.chain_present:
    - name: OUTBOUND
    - table: filter


# Creating DIRECT chain

iptables_creating_DIRECT_chain:
  iptables.chain_present:
    - name: DIRECT
    - table: filter


# Adding DIRECT chain in FORWARD

iptables_adding_DIRECT_to_FORWARD:
  iptables.insert:
   - position: 1
   - table: filter
   - chain: FORWARD
   - jump: DIRECT
   - comment: "Rules: Managed by salt"
   - require:
     - iptables_creating_DIRECT_chain
   - save: True


# Adding DROP rule in FORWARD

creating_drop_rule_in_FORWARD_chain:
  iptables.append:
    - table: filter
    - chain: FORWARD
    - jump: DROP
    - save: True
    - require:
      - iptables_adding_DIRECT_to_FORWARD 


# Adding INBOUND chain in INPUT

iptables_adding_INBOUND_to_INPUT:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INPUT
    - jump: INBOUND
    - comment: "Rules: Managed by salt"
    - require:
      - iptables_creating_INBOUND_chain
    - save: True


# Adding OUTBOUND chain in OUTPUT

iptables_adding_OUTBOUND_to_OUTPUT:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: OUTPUT
    - jump: OUTBOUND
    - comment: "Rules: Managed by salt"
    - require:
      - iptables_creating_OUTBOUND_chain
    - save: True

# Creating IN-SALT chain

iptables_creating_IN-SALT_chain:
  iptables.chain_present:
    - name: IN-SALT
    - table: filter


# Creating OUT-SALT chain

iptables_creating_OUT-SALT_chain:
  iptables.chain_present:
    - name: OUT-SALT
    - table: filter


{% if grains['custom_grains']['salt_master'] == True  %}


# Adding dports IN-SALT in INBOUND chain
iptables_dports_adding_IN-SALT_to_INBOUND:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INBOUND
    - jump: IN-SALT
    - protocol: tcp
    - dports:
      - 4505
      - 4506
    - comment: "Allowing port 4505 and 4506 for salt connections"
    - require:
      - iptables_creating_INBOUND_chain
      - iptables_creating_IN-SALT_chain
    - save: True


# Adding sports OUT-SALT in OUTBOUND chain
iptables_sports_adding_OUT-SALT_to_OUTBOUND:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: OUTBOUND
    - jump: OUT-SALT
    - protocol: tcp
    - sports:
      - 4505
      - 4506
    - comment: "Allowing port 4505 and 4506 for salt connections"
    - require:
      - iptables_creating_OUTBOUND_chain
      - iptables_creating_OUT-SALT_chain
    - save: True


{% endif %}


# Adding sports IN-SALT in INBOUND chain
iptables_sports_adding_IN-SALT_to_INBOUND:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: INBOUND
    - jump: IN-SALT
    - protocol: tcp
    - sports:
      - 4505
      - 4506
    - comment: "Allowing port 4505 and 4506 for salt connections"
    - require:
      - iptables_creating_INBOUND_chain
      - iptables_creating_IN-SALT_chain
    - save: True


# Adding dports OUT-SALT in OUTBOUND chain
iptables_dports_adding_OUT-SALT_to_OUTBOUND:
  iptables.insert:
    - position: 1
    - table: filter
    - chain: OUTBOUND
    - jump: OUT-SALT
    - protocol: tcp
    - dports:
      - 4505
      - 4506
    - comment: "Allowing port 4505 and 4506 for salt connections"
    - require:
      - iptables_creating_OUTBOUND_chain
      - iptables_creating_OUT-SALT_chain
    - save: True


{% for minion_ip in grains['custom_grains']['salt_minions'].values()  %}


# Allowing all trusted hosts in IN-SALT

{% if grains['custom_grains']['salt_master'] == True or minion_ip == grains['master'] %}

allowing_{{ minion_ip }}_IN-SALT:
  iptables.insert:
    - position: 1
    - chain: IN-SALT
    - source: {{ minion_ip }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables_creating_IN-SALT_chain
      - iptables_sports_adding_IN-SALT_to_INBOUND
{% if grains['custom_grains']['salt_master'] == True  %}
      - iptables_dports_adding_IN-SALT_to_INBOUND
{% endif %}


# Allowing all trusted hosts in OUT-SALT

allowing_{{ minion_ip }}_OUT-SALT:
  iptables.insert:
    - position: 1
    - chain: OUT-SALT
    - destination: {{ minion_ip }}
    - jump: ACCEPT
    - save: True
    - require:
      - iptables_creating_OUT-SALT_chain
      - iptables_dports_adding_OUT-SALT_to_OUTBOUND
{% if grains['custom_grains']['salt_master'] == True  %}
      - iptables_sports_adding_OUT-SALT_to_OUTBOUND
{% endif %}

{% endif %}

{% endfor  %}


# Adding LOG rule in OUTPUT chain

creating_log_rule_in_OUTPUT_chain:
  iptables.append:
    - table: filter
    - chain: OUTPUT
    - jump: LOG
    - log-prefix: "OUTPUT: DROPPING:"
    - save: True
    - require:
      - iptables_adding_OUTBOUND_to_OUTPUT
{% for minion_ip in grains['custom_grains']['salt_minions'].values()  %}
{% if grains['custom_grains']['salt_master'] == True or minion_ip == grains['master'] %}
      - allowing_{{ minion_ip }}_OUT-SALT
{% endif %}
{% endfor %}
{% for trusted_range in grains['custom_grains']['trusted_ip_ranges']  %}
      - allowing_{{ trusted_range }}_port_22_in_OUTPUT
{% endfor %}


# Adding LOG rule in INPUT chain

creating_log_rule_in_INPUT_chain:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: LOG
    - log-prefix: "INPUT: DROPPING:"
    - save: True
    - require:
      - iptables_adding_INBOUND_to_INPUT
{% for minion_ip in grains['custom_grains']['salt_minions'].values()  %}
{% if grains['custom_grains']['salt_master'] == True or minion_ip == grains['master'] %}
      - allowing_{{ minion_ip }}_IN-SALT
{% endif %}
{% endfor %}
{% for trusted_range in grains['custom_grains']['trusted_ip_ranges']  %}
      - allowing_{{ trusted_range }}_port_22_in_INPUT
{% endfor  %}


# Adding DROP rule in INPUT chain

creating_drop_rule_in_INPUT_chain:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - save: True
    - require:
      - creating_log_rule_in_INPUT_chain
      - creating_log_rule_in_OUTPUT_chain
      - installing_required_packages


# Adding DROP rule in OUTPUT chain

creating_drop_rule_in_OUTPUT_chain:
  iptables.append:
    - table: filter
    - chain: OUTPUT
    - jump: DROP
    - save: True
    - require:
      - creating_log_rule_in_OUTPUT_chain
      - creating_log_rule_in_INPUT_chain
      - installing_required_packages


# Adding default policies in iptables for INPUT

INPUT_default_policy:
  iptables.set_policy:
    - policy: DROP
    - chain: INPUT
    - require:
      - creating_drop_rule_in_INPUT_chain


# Adding default policies in iptables for OUTPUT

OUTPUT_default_policy:
  iptables.set_policy:
    - policy: DROP
    - chain: OUTPUT
    - require:
      - creating_drop_rule_in_OUTPUT_chain


# Adding default policies in iptables for FORWARD

FORWARD_default_policy:
  iptables.set_policy:
    - policy: DROP
    - chain: FORWARD
    - require:
      - creating_drop_rule_in_FORWARD_chain

