#!/bin/bash
MANIFEST_FILE="manifest.json"
do_build="$(jq '.builds[] | select(.builder_type== "digitalocean")' "$MANIFEST_FILE")"
do_image_id="$(echo "$do_build" | jq -r '.artifact_id' | cut -d':' -f 2 )"
do_image_name="$(echo "$do_build" | jq -r '.custom_data.image_name')"

packer build -var "image_name=$do_image_name" -var "image_id=$do_image_id" -var-file=credentials.auto.pkrvars.hcl digitalocean_test.pkr.hcl