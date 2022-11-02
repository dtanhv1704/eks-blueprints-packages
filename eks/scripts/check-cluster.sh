#!/bin/sh

set -e
eval "$(jq -r '@sh "CLUSTER=\(.cluster_name)"')"
name=$(aws eks describe-cluster --name $CLUSTER | jq -r ".cluster.name" 2>&1 )
ret=$?
echo $name, $CLUSTER > test.txt
if [ $ret -eq 0 ]; then
    if [[ $name == $CLUSTER ]]
    then
        echo "true" >> test.txt
        jq -n '{"exist": "true"}'
    else
        echo "f1" >> test.txt
        jq -n '{"exist": "false"}'
    fi
else
    echo "f2" >> test.txt
    jq -n '{"exist": "false"}'
fi