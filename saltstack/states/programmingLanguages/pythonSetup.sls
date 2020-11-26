
# Adding IUS repo

setting_up_ius_repo:
  pkgrepo.managed:
    - name: ius
    - humanname: IUS Community Packages for Enterprise Linux {{ grains['osmajorrelease'] }} - $basearch
    - baseurl: https://mirror.rackspace.com/ius/stable/CentOS/{{ grains['osmajorrelease'] }}/$basearch
    - gpgkey: https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY
    - gpgcheck: 1


# Installing python36

install_python_pkgs:
  pkg.installed:
    - pkgs:
      - python-devel.x86_64 
      - python2-pip.noarch 
      - python-setuptools.noarch 
      - python.x86_64 
      - python36-devel.x86_64
      - python36.x86_64
      - python36u-pip.noarch
      - python36u-setuptools.noarch
      - python36-tools.x86_64
    - require:
      - setting_up_ius_repo


# Deleting repo

deleting_ius_repo:
  pkgrepo.absent:
    - name: ius
    - require:
      - install_python_pkgs
