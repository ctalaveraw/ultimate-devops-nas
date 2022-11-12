#!/bin/bash

echo -e '\n Making SSH Key... \n'
sleep 1s
ssh-keygen -f ~/.ssh/pipeline_runner -t rsa -P ""

echo -e '\n Key saved to "~/.ssh/pipeline_runner"... \n'
sleep 1s

echo -e 'Hashing algorithm is "Ed25519"... \n'
sleep 1s

echo -e 'Created keypair is passwordless... \n'
sleep 1s

echo -e 'Showing the created public key below... \n'
cat ~/.ssh/pipeline_runner.pub
sleep 1s
