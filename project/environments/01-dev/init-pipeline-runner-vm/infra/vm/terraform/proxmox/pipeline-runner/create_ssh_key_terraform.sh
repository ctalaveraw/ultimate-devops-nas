#!/bin/bash

echo -e '\n Making SSH Key... \n'
sleep 1s
ssh-keygen -f ~/.ssh/terraform_connect -t ed25519 -P ""

echo -e '\n Key saved to "~/.ssh/terraform_connect"... \n'
sleep 1s

echo -e 'Hashing algorithm is "Ed25519"... \n'
sleep 1s

echo -e 'Created keypair is passwordless... \n'
sleep 1s

echo -e 'Showing the created public key below... \n'
cat ~/.ssh/terraform_connect.pub
sleep 1s
