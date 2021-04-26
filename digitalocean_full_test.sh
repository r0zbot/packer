#!/bin/bash

set -e
# set -o xtrace

MANIFEST_FILE="manifest.json"


function wait_http () {
  attempt_counter=0
  max_attempts=180

  until $(curl --connect-timeout 5 --insecure --output /dev/null --silent --head --fail $1); do
      if [ ${attempt_counter} -eq ${max_attempts} ];then
        echo "Timed out waiting for rocket.chat server"
        exit 1
      fi

      echo -n '.'
      attempt_counter=$(($attempt_counter+1))
      sleep 1
  done
}

echo "Authenticating with DigitalOcean"
doctl auth init -t "$PKR_VAR_do_token"

echo "Parsing manifest"
do_build="$(jq '.builds[] | select(.builder_type== "digitalocean")' "$MANIFEST_FILE")"
do_size="$(echo "$do_build" | jq -r '.custom_data.do_size' )"
do_region="$(echo "$do_build" | jq -r '.custom_data.do_region' )"
do_image_id="$(echo "$do_build" | jq -r '.artifact_id' | cut -d':' -f 2 )"
do_image_name="$(echo "$do_build" | jq -r '.custom_data.image_name')"

echo "Adding temporary ssh key"
ssh_key_file="tmp_id_rsa"
yes | ssh-keygen -f "$ssh_key_file" -t rsa -N ''
ssh_fingerprint="$(ssh-keygen -l -E md5 -f  "$ssh_key_file" | cut -d':' -f 2- | cut -d' ' -f 1)"
doctl compute ssh-key import "packer-test-$do_image_name" --public-key-file "$ssh_key_file.pub"

echo "Creating droplet"
droplet="$(doctl compute droplet create test-$do_image_name --image "$do_image_id" --region "$do_region" --size  "$do_size" --tag-name packer-test-instance -o json --ssh-keys "$ssh_fingerprint" )"
droplet_id="$(echo "$droplet" | jq -r '.[].id' )"
sleep 15

echo "Getting droplet IP"
droplet_ip="$(doctl compute droplet get "$droplet_id" -o json | jq -r '.[].networks.v4[] | select(.type == "public") | .ip_address' )"

echo "Waiting for rocket.chat server to start on droplet"

wait_http http://$droplet_ip:3000

# sleep 5
echo "Running tests on rocketchat"
./basic_test.sh http://$droplet_ip:3000

echo "Setting root-url to droplet ip address"
ssh -o StrictHostKeyChecking=no -i $ssh_key_file root@$droplet_ip "rocketchatctl configure --rocketchat --root-url=http://$droplet_ip --bind-loopback=false && rocketchatctl configure --lets-encrypt --root-url=http://$droplet_ip --letsencrypt-email=EMAIL"

echo "Waiting for rocket.chat server to restart"
wait_http https://$droplet_ip

echo "Running tests on rocketchat through traefik"
./basic_test.sh https://$droplet_ip insecure

echo "Tests passed!"
echo "Destroying droplet"
yes | doctl compute droplet delete $droplet_id

echo "Removing ssh key"
doctl compute ssh-key delete -f "$ssh_fingerprint"

echo "Done."