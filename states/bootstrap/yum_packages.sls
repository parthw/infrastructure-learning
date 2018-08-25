

# Installing epel-release

installing_epel-release:
  pkg.installed:
    - name: epel-release


# Refreshing yum database
refreshing_yum_database:
  cmd.run:
    - name: yum clean all && yum makecache
    - require:
      - installing_epel-release


# Installing required packages

installing_required_packages:
  pkg.installed:
    - pkgs: {{ pillar['bootstrap']['packages'] }} 
    - require:
      - refreshing_yum_database
