
{% set fqdn = grains.get('fqdn') %}
{% set docker_version = "18.06.1.ce-3.el7" %}

# Adding docker repo

setting_up_docker_repo_in_{{ fqdn }}:
  cmd.run:
    - name: yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 


# Required to lock docker version - (Not executed bootstrap?)

installing_yum_pkg_versionlock:
  pkg.installed:
    - name: yum-plugin-versionlock


# Installing docker

installing_docker_in_{{ fqdn }}:
  pkg.installed:
    - name: docker-ce
    - version: {{ docker_version }}
    - hold: True
    - require:
      - setting_up_docker_repo_in_{{ fqdn }}
      - installing_yum_pkg_versionlock


# Deleting docker repo

deleting_docker_repo_{{ fqdn }}:
  pkgrepo.absent:
    - name: docker-ce 
    - require:
      - installing_docker_in_{{ fqdn }}


# Adding data dir in docker systemd

editing_data_dir_in_systemd_at_{{ fqdn }}:
  cmd.run:
    - name: sed -i 's/ExecStart=\/usr\/bin\/dockerd/ExecStart=\/usr\/bin\/dockerd --data-root=\/data\/docker/' /usr/lib/systemd/system/docker.service
    - require:
      - installing_docker_in_{{ fqdn }}


# Reloading systemd-daemon

reloading_systemd_daemon:
  cmd.run:
    - name: systemctl --system daemon-reload
    - require:
      - editing_data_dir_in_systemd_at_{{ fqdn }}


# Autostart at boot

enabling_auto_start_at_boot:
  service.enabled:
    - name: docker
    - require:
      - reloading_systemd_daemon


# is
