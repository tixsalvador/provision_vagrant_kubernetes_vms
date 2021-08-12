#!/bin/sh

# To suppress the stdin warning message
export DEBIAN_FRONTEND=noninteractive

# Prepare vm's for k0s
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa
