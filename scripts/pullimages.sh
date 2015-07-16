#!/bin/bash
#
# pull images an put in local registry
#
# 07/15/2015 mikeln
#
SOURCE_REPO="quay.io/mikeln"
DEST_REPO="172.16.16.15:5000"
#DEST_REPO="dockerrepo.mineco.lab:5000"

APPS=( "opscenter_kub:v06slim" "cassandra_kub:v22slim" )

for APP in ${APPS[@]}; do
   echo "Pulling: ${SOURCE_REPO}/${APP} to ${DEST_REPO}"
   docker pull ${SOURCE_REPO}/${APP}
   docker tag  -f ${SOURCE_REPO}/${APP} ${DEST_REPO}/${APP} 
   docker images ${DEST_REPO}/*
   docker push ${DEST_REPO}/${APP}
done
