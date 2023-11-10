#!/bin/bash

# First arg can be server (for server config) of client (for client config)
wget --no-verbose -O /tmp/hashicorp.gpg https://apt.releases.hashicorp.com/gpg
gpg --batch --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg /tmp/hashicorp.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt-get update && apt-get install nomad
cp /vagrant/$1.hcl /etc/nomad.d/nomad.hcl
systemctl enable nomad
systemctl start nomad
