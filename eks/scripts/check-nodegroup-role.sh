#!/bin/sh
# set -e
eval "$(jq -r '@sh "NODE_GROUP_ROLE=\(.role_name)"')"
role=$(aws iam get-role --role-name $NODE_GROUP_ROLE 2>&1)
ret=$?
if [ $ret -eq 0 ]; then
    rolename=$(echo $role | jq -r '.Role.RoleName' 2>&1)
    if [ "$rolename" == "$NODE_GROUP_ROLE" ]; then
        arn=$(echo $role | jq -r '.Role.Arn')
        jq -n --arg value "$arn" '{"exist":"true","arn":$value}'
    else
        jq -n '{"exist":"false"}'
    fi
else
    jq -n '{"exist":"false"}'
fi
