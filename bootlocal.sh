dco#!/usr/bin/env sh
# Disable Docker TLS for development and testing purposes
sudo tee /var/lib/boot2docker/profile <<EOF
DOCKER_TLS="no"
DOCKER_STORAGE="aufs"
EXTRA_ARGS="--insecure-registry 172.16.16.15:5000 "
EOF

sudo /etc/init.d/docker restart
sleep 5s
export DOCKER_HOST="tcp://localhost:2375"
#sudo docker load < /usr/share/docker-registry.tar
/usr/local/bin/docker run -d -p 5000:5000 --name registry \
-v /vagrant_data/:/vagrant_data --net host \
-e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY="/vagrant_data/registry" \
registry:2.0