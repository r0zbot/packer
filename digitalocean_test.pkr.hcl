variable "do_token" {
    type    = string
}
variable "do_size" {
    type    = string
    default = "s-1vcpu-1gb"
}
variable "do_region" {
    type    = string
    default = "nyc3"
}
variable "image_name" {
    type    = string
}
variable "image_id" {
    type    = string
}


source "digitalocean" "rocket-chat" {
  api_token     = "${var.do_token}"
  snapshot_name = "test-${var.image_name}"
  size          = "s-1vcpu-1gb"
  region        = "nyc3"
  image         = "${var.image_id}"
  ssh_username  = "root"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  sources = ["source.digitalocean.rocket-chat"]

  provisioner "shell" {
    inline = [
      "rocketchatctl configure --rocketchat --root-url=http://${build.Host}",
      "rocketchatctl configure --lets-encrypt --root-url=http://${build.Host} --letsencrypt-email=EMAIL",
    ]
  }

  provisioner "shell-local" {
    script = "digitalocean_local_test.sh"
    environment_vars = [
      "droplet_ip=${build.Host}"
    ]
  }

  # ignore the test artifact
  post-processor "artifice" {
    files = ["manifest.json"]
    keep_input_artifact = false
  }
}
