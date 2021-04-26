#!/bin/bash

ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N ''

export PKR_VAR_do_token="$INPUT_DO_TOKEN"