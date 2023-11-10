#!/bin/bash

# Use nginx as an artefact store
apt-get -y install nginx
systemctl enable nginx
systemctl start nginx

# Download traefik and copy to the artefact store.

# Get the URL for the traefik binary
if arch|grep -q aarch64
then
  TRAEFIK_URL="https://github.com/traefik/traefik/releases/download/v2.10.5/traefik_v2.10.5_linux_arm64.tar.gz"
else
  TRAEFIK_URL="https://github.com/traefik/traefik/releases/download/v2.10.5/traefik_v2.10.5_linux_amd64.tar.gz"
fi

(
cd /tmp
wget -nv -O traefik.tgz "${TRAEFIK_URL}"
tar xzf traefik.tgz
cp traefik /var/www/html
chmod 755 /var/www/html/traefik
)

# Copy Bob and Jane Apps to the artefact store
cp /vagrant/artefacts/*.py /var/www/html

# Copy some files to /home/vagrant in order to:
# - run jobs
# - garbage collect old jobs

cp /vagrant/run_nomad_garbage_collection.sh /home/vagrant/
cp /vagrant/jobs/* /home/vagrant/

chown vagrant:vagrant /home/vagrant/*
