#!/bin/sh

set -e
eval "$(jq -r '@sh "ALIAS=\(.key_alias)"')"
alias_arn=$(aws kms describe-key --key-id $ALIAS | jq -r ".KeyMetadata.Arn" 2>&1 )
ret=$?
if [ $ret -eq 0 ]; then
    if [[ $alias_arn =~ ^arn:aws:kms.* ]]
    then
        jq -n --arg value "$alias_arn" '{"arn": $value}'
    else
        jq -n '{"arn": null}'
    fi
else
    jq -n '{"arn": null}'
fi