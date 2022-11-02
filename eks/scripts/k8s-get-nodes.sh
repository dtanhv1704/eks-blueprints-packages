#/bin/bash

set -e
eval "$(jq -r '@sh "CLUSTER=\(.cluster_name)"')"
HOST=$(aws eks describe-cluster --name $CLUSTER | jq -r ".cluster.endpoint" 2>&1 )
ret1=$?
TOKEN=$(aws eks get-token --cluster-name $CLUSTER | jq -r ".status.token" 2>&1)
ret2=$?
if [ $ret1 -eq 0 && $ret2 -eq 0 ]; then
    kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true -s $HOST --token $TOKEN --insecure-skip-tls-verify
    kubectl set env ds aws-node -n kube-system WARM_PREFIX_TARGET=1 -s $HOST --token $TOKEN --insecure-skip-tls-verify
    kubectl set env ds aws-node -n kube-system WARM_IP_TARGET=5 -s $HOST --token $TOKEN --insecure-skip-tls-verify
    kubectl set env ds aws-node -n kube-system MINIMUM_IP_TARGET=2 -s $HOST --token $TOKEN --insecure-skip-tls-verify
    jq -n '{"exist": "true"}'
else
    jq -n '{"exist": "false"}'
fi