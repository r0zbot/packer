FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' sudo curl wget awscli packer ssh jq
RUN curl -sL https://github.com/digitalocean/doctl/releases/download/v1.59.0/doctl-1.59.0-linux-amd64.tar.gz | tar -xzv && mv doctl /usr/local/bin/

COPY . /deploy

WORKDIR /deploy

CMD ["bash", "/deploy/entrypoint.sh"]