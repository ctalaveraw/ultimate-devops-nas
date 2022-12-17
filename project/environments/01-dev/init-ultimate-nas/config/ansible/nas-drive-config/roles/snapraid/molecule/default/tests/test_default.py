import os

import testinfra.utils.ansible_runner

here = os.path.dirname(__file__)
testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def read_reference_file():
    with open(os.path.join(here, 'snapraid.reference.conf')) as reference_file:
        return reference_file.read()


def test_configuration_file(host):
    reference = read_reference_file()
    configuration = host.file('/etc/snapraid.conf').content_string
    assert configuration == reference


def test_sync(host):
    cmd = host.run('snapraid sync')
    assert cmd.rc == 0
    assert host.file('/mnt/data1/snapraid.content').exists
    assert host.file('/mnt/data2/snapraid.content').exists
    assert host.file('/mnt/data3/snapraid.content').exists
    assert host.file('/mnt/parity1/snapraid.parity').exists
    assert host.file('/mnt/parity2/snapraid.2-parity').exists


def test_pool(host):
    cmd = host.run('snapraid pool')
    assert cmd.rc == 0
    assert host.file('/mypool/file1.txt').exists
    assert host.file('/mypool/file2.txt').exists
    assert host.file('/mypool/file3.txt').exists
