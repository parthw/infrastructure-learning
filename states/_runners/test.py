
import salt.client

def up():
    """
    Print a list of all of the minions that are up
    """
    client = salt.client.LocalClient(__opts__['conf_file'])
    minions = client.cmd('*', 'test.ping')
    for minion in sorted(minions):
        print minion
