#!/bin/bash

echo -e '\n Please enter the name of the current user... \n'
read CURRENT_USERNAME

SSH_PATH="/home/$CURRENT_USERNAME/.ssh/ultimate-nas/nas-vm"
SSH_KEYNAME="packer_connect"
SSH_KEY="${SSH_PATH}/${SSH_KEYNAME}"


echo -e '\n Making SSH Key directory... \n'
sleep 1s

echo -e "\n SSH Key directory made at '$SSH_PATH'... \n"
sleep 1s
mkdir -pv $SSH_PATH && chmod 0700 $SSH_PATH

echo -e '\n Making SSH Key... \n'
sleep 1s
ssh-keygen -f $SSH_KEY -t rsa -P ""

echo -e "\n Key saved to $SSH_KEY... \n"
sleep 1s

echo -e 'Hashing algorithm is "RSA"... \n'
sleep 1s

echo -e 'Created keypair is passwordless... \n'
sleep 1s

echo -e 'Showing the created public key below... \n'
cat $SSH_KEY.pub
sleep 1s
