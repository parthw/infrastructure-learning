
import salt.client
import os
import yaml

def _read_master_grains():
    """
    """
    grains_file = "/etc/salt/grains"
    master_grains = yaml.load(open(grains_file)) if os.path.isfile(grains_file) else None
    return master_grains['custom_grains']


def update_all_minion_grains():
    """
    """
    master_grains = _read_master_grains()
    salt_minions = master_grains['salt_minions']
    client = salt.client.LocalClient(__opts__['conf_file'])
    command_on_minions = """ python -c "import yaml; minion_grains=yaml.load(open('/etc/salt/grains')); minion_grains['custom_grains']['salt_minions'].update({0}); yaml.dump(minion_grains, open('/etc/salt/grains', 'w'), default_flow_style=False)" """.format(salt_minions)
    minion_output = client.cmd('*', 'cmd.run' , [command_on_minions])
    return minion_output



def bootstrap_grains(minion, ipv4, trusted_ip_ranges=None):
    """
    """
    minion_grains = {"salt_master": False}
    master_grains = _read_master_grains()
    if not master_grains:
        return "/etc/salt/grains does not exists"
    minion_grains['ipv4'] = ipv4
    if  trusted_ip_ranges:
        minion_grains['trusted_ip_ranges'] = trusted_ip_ranges
    else:
        minion_grains['trusted_ip_ranges'] = master_grains['trusted_ip_ranges']
    salt_minions = master_grains['salt_minions']
    salt_minions[minion] = ipv4
    master_grains['salt_minions'].update(salt_minions)
    minion_grains['salt_minions'] = salt_minions
    final_master_grains, final_minion_grains = {'custom_grains': master_grains}, {'custom_grains': minion_grains}
    yaml.dump(final_master_grains, open('/etc/salt/grains', 'w'), default_flow_style=False)
    client = salt.client.LocalClient(__opts__['conf_file'])
    minion_output = client.cmd(minion, 'file.write', ['/etc/salt/grains', yaml.dump(final_minion_grains, default_flow_style=False)])
    return minion_output

