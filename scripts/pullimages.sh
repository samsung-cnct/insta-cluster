#!/bin/bash
#
# pull images an put in local registry
#
# 07/15/2015 mikeln
#
SOURCE_REPO="quay.io/samsung_ag"
DEST_REPO="172.16.16.15:5000"
#DEST_REPO="dockerrepo.mineco.lab:5000"

IMAGES=$(cat <<EOF
  cassandra_kub:v23slim
  grafana:latest
  influxdb:latest
  opscenter_kub:v06slim
  podpincher:latest
  trogdor-framework:latest
  trogdor-load-generator:latest
EOF)

for IMAGE in ${IMAGES[@]}; do
   echo "Pulling: ${SOURCE_REPO}/${IMAGE} to ${DEST_REPO}"
   docker pull ${SOURCE_REPO}/${IMAGE}
   docker tag  -f ${SOURCE_REPO}/${IMAGE} ${DEST_REPO}/${IMAGE}
   docker images ${DEST_REPO}/*
   docker push ${DEST_REPO}/${IMAGE}
done
