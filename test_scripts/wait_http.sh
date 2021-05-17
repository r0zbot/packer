#!/bin/bash

attempt_counter=0
max_attempts=150

until $(curl --connect-timeout 5 --output /dev/null --silent --head --fail $1); do
  if [ ${attempt_counter} -eq ${max_attempts} ];then
    echo "Timed out waiting for rocket.chat server"
    exit 1
  fi

  echo -n '.'
  attempt_counter=$(($attempt_counter+1))
  sleep 1
done