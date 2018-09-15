
# Bootstrap last state

locking_all_packages:
  cmd.run:
    - name: "yum versionlock add"
    - require:
      - installing_required_packages 
