FROM hashicorp/packer:1.7.2

COPY . /deploy

WORKDIR /deploy

ENTRYPOINT ["bash", "/deploy/entrypoint.sh"]