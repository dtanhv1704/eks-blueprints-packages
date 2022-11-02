#!/bin/sh
# set -e
eval "$(jq -r '@sh "CLUSTER_ROLE=\(.role_name)"')"
role=$(aws iam get-role --role-name $CLUSTER_ROLE 2>&1)
ret=$?
if [ $ret -eq 0 ]; then
    rolename=$(echo $role | jq -r '.Role.RoleName' 2>&1)
    if [ "$rolename" == "$CLUSTER_ROLE" ]; then
        arn=$(echo $role | jq -r '.Role.Arn')
        jq -n --arg value "$arn" '{"exist":"true","arn":$value}'
    else
        jq -n '{"exist":"false"}'
    fi
else
    jq -n '{"exist":"false"}'
fi
