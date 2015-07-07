#!/bin/bash
# Provisioning for all nodes.

# Add all hosts.
echo "10.0.0.101 node1.mysqlcloud.local" >> /etc/hosts
echo "10.0.0.102 node2.mysqlcloud.local" >> /etc/hosts
echo "10.0.0.103 node3.mysqlcloud.local" >> /etc/hosts

# Install dev tools
DEBIAN_FRONTEND=noninteractive apt-get -y install vim zsh

# Common tools needed.
DEBIAN_FRONTEND=noninteractive apt-get -y install curl

# Update the package list.
DEBIAN_FRONTEND=noninteractive apt-get -y update

# Add inputrc for bash history completion.
cp /vagrant/provisioning/bash/.inputrc /home/vagrant/.inputrc
cp /vagrant/provisioning/bash/.inputrc /root/.inputrc
