#!/bin/bash
set -e

## TODO: Remove after updating Charming Dockerfile
## commented out for now until further work on lxc
#/patchcontainer.sh
#brctl addbr lxcbr0
#ifconfig lxcbr0 10.0.4.1 up

export HOME=/home/ubuntu
cd $HOME
chown ubuntu:ubuntu $HOME/.juju
sudo -u ubuntu ssh-agent /bin/bash
