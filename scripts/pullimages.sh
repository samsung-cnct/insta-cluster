#!/bin/bash
#
# pull images an put in local registry
#
# 07/15/2015 mikeln
#
dest_repo="172.16.16.15:5000"
#dest_repo="dockerrepo.mineco.lab:5000"

# spiffxp@kthxbye:kraken-services (master)$ \
#   grep -r image: * | grep yaml | sed -e 's,.*image: ,,' | sort | uniq | grep -v 172.16
images=$(cat <<EOF
  gcr.io/google_containers/etcd:2.0.9
  gcr.io/google_containers/exechealthz:1.0
  gcr.io/google_containers/heapster:v0.16.0
  gcr.io/google_containers/kube-ui:v1.1
  gcr.io/google_containers/kube2sky:1.11
  gcr.io/google_containers/skydns:2015-03-11-001
  gcr.io/google_containers/kubectl:v0.18.0-350-gfb3305edcf6c1a
  prom/promdash
  quay.io/coreos/tectonic-console:latest
  quay.io/samsung_ag/cassandra_kub:v24slim
  quay.io/samsung_ag/grafana:latest
  quay.io/samsung_ag/influxdb:latest
  quay.io/samsung_ag/opscenter_kub:v06slim
  quay.io/samsung_ag/podpincher:latest
  quay.io/samsung_ag/trogdor-framework:latest
  quay.io/samsung_ag/trogdor-load-generator:latest
  quay.io/spiffxp/prometheus:latest
EOF)

for source_image in ${images[@]}; do
   repo=$(echo $source_image | cut -d/ -f1)
   org=$(echo $source_image | cut -d/ -f2)
   image=$(echo $source_image | sed -e 's,.*/\([^:]*\).*,\1,')
   tag=$( (echo $source_image | grep -q : && echo $source_image | cut -d: -f2) || echo "latest")

   echo "Pulling: ${source_image} to ${dest_repo}/${image}:${tag}"
   docker pull ${source_image}
   docker tag  -f ${source_image} ${dest_repo}/${image}:${tag}
   docker images ${dest_repo}/*
   docker push ${dest_repo}/${image}:${tag}
done
