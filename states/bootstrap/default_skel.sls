
# Adding .vimrc and .bashrc files

/etc/skel/.bashrc:
  file.managed:
    - source: salt://bootstrap/conf/.bashrc
    - user: root
    - group: root
    - mode: 644
    - backup: minion

/etc/skel/.vimrc:
  file.managed:
    - source: salt://bootstrap/conf/.vimrc
    - user: root
    - group: root
    - mode: 644
    - backup: minion

/root/.vimrc:
  file.managed:
    - source: salt://bootstrap/conf/.vimrc
    - user: root
    - group: root
    - mode: 644
    - backup: minion
