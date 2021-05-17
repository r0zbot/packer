#!/bin/bash

set -e
# set -o xtrace

cd "$(dirname "$0")"

echo "Waiting for local rocket.chat server to start"
./wait_http.sh http://127.0.0.1:3000
sleep 5

echo "Running tests on rocketchat"
./basic_test.sh http://127.0.0.1:3000

if [[ "$1" == "update" ]]; then
  echo "Running another test"
  ./basic_test.sh http://127.0.0.1:3000 
  
  echo "Seeing if information persisted across updates"
  ./basic_test.sh http://127.0.0.1:3000 
fi

echo "Tests passed!"