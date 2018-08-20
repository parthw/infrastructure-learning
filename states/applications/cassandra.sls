

{% set cassandra_pillar = pillar.get('cassandra') %}

# Setting up cassandra repo

setting_up_cassandra_repo:
  pkgrepo.managed:
    - name: cassandra
    - humanname: Apache Cassandra
    - baseurl: https://www.apache.org/dist/cassandra/redhat/{{ cassandra_pillar.get("repo_version") }}/
    - gpgcheck: 1
    - repo_gpgcheck: 1
    - gpgkey: https://www.apache.org/dist/cassandra/KEYS


# Installing cassandra

installing_cassandra_in_{{ grains.get('fqdn') }}:
  pkg.installed:
    - name: cassandra
    - version: {{ cassandra_pillar.get("cassandra_version") }}
    - require:
      - setting_up_cassandra_repo


# Disabling cassandra repo

disabling_cassandra_repo:
  pkgrepo.absent:
    - name: cassandra
    - require:
      - installing_cassandra_in_{{ grains.get('fqdn') }}


# Reloading systemd-daemon

reloading_systemd_daemon:
  cmd.run:
  - name: systemctl --system daemon-reload
  - require:
    - installing_cassandra_in_{{ grains.get('fqdn') }}


