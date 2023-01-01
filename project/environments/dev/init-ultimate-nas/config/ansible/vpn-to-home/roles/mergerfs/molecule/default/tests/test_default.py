import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']
).get_hosts('all')


def test_mount_point(host):
    mount_point = host.mount_point('/mnt/storage')
    assert mount_point.exists
    assert mount_point.filesystem == 'fuse.mergerfs'
    assert 'allow_other' in mount_point.options
    # assert 'use_ino' in mount_point.options


def test_data_files(host):
    assert host.file('/mnt/storage/file1.txt').exists
    assert host.file('/mnt/storage/file2.txt').exists
    assert host.file('/mnt/storage/file3.txt').exists
