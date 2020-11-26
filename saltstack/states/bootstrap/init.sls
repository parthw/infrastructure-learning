
include:
  - bootstrap.selinux
  - bootstrap.yum_packages
  - bootstrap.auth
  - bootstrap.required_dirs
  - bootstrap.sshd
  - bootstrap.default_skel
  - bootstrap.iptable_chains
  - bootstrap.finish_bootstrap


# Creating system user as root user can't login via ssh

creating_system_user:
  user.present:
    - name: ace
    - shell: /bin/bash
    - system: True
    - password: $1$nBAtCFVZ$CPxbVBaeD804HE17NadDm0
    - groups:
      - wheel
      - root
