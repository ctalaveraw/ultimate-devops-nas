#!/bin/bash


echo -e '\n Please enter the IP of the server for adding public key... \n'
echo -e '(format is 4 octets separated by dots; e.g "192.168.1.1") \n'
read SERVER_IP

echo -e '\n Making SSH Key... \n'
sleep 1s
ssh-keygen -f ~/.ssh/packer_connect -t ed25519 -P ""

echo -e '\n Key saved to "~/.ssh/packer_connect"... \n'
sleep 1s

echo -e 'Hashing algorithm is "Ed25519"... \n'
sleep 1s

echo -e 'Created keypair is passwordless... \n'
sleep 1s

echo -e 'Showing the created public key below... \n'
cat ~/.ssh/packer_connect.pub
sleep 1s

echo -e '\n Adding the created public key to the server... \n'
sleep 1s

echo -e 'Please login to the server to add the public key... \n'
sleep 1s
ssh-copy-id -i ~/.ssh/packer_connect root@$SERVER_IP
