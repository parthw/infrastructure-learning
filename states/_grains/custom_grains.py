# -*- coding: utf-8 -*-
#!/usr/bin/python

import os
import yaml

def _salt_root_dir(env_type='base'):
    root_dir =  os.path.dirname(yaml.safe_load(open('/etc/salt/master'))['file_roots'][env_type][0])
    return root_dir

def _reading_custom_grains(conf_type):
    conf = yaml.safe_load(open(os.path.join(_salt_root_dir(), 'setupConfigs', 'custom_grains_setup.yaml')))
    return conf[conf_type]

def _salt_master_grains():
    masters = _reading_custom_grains(conf_type='masters')
    for master in masters.keys():
        if master == os.uname()[1]:
            masters[master]['root_dir'] = _salt_root_dir()
    return masters

def _salt_minions_grains():
    minions = _reading_custom_grains(conf_type='minions')
    return minions

def main():
    grains = dict()
    grains['salt_details'] = {'masters': dict(), 'minions': dict()}
    grains['salt_details']['masters'] = _salt_master_grains()
    grains['salt_details']['minions'] = _salt_minions_grains()
    return grains
