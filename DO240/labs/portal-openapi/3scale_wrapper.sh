#!/bin/bash

ARGS=($@)
FILE=${ARGS[-1]}
unset ARGS[-1]

LOG_FILE=/tmp/portal-openapi.log

OCP_USER="admin"
OCP_PASS="redhat"
OCP_URL="https://api.ocp4.example.com:6443"

T_SCALE_PROJECT="3scale"
T_SCALE_IMAGE="registry.redhat.io/3scale-amp2/toolbox-rhel8:3scale2.11"
T_SCALE_COMMAND="3scale -k ${ARGS[@]} file"

V_T_SCALE_REMOTE="-v $HOME/.3scalerc.yaml:/opt/app-root/src/.3scalerc.yaml:Z"
V_FILE_ARGUMENT="-v ./$FILE:/opt/app-root/src/file:Z"


ocp_login() {
    oc login -u "${OCP_USER}" -p "${OCP_PASS}" "${OCP_URL}"
}

config_remote() {
  ACCESS_TOKEN="$(oc -n $T_SCALE_PROJECT get secret system-seed -o json | jq -r .data.ADMIN_ACCESS_TOKEN | base64 -d)"
  cat <<EOF > ~/.3scalerc.yaml
---
:remotes:
  3scale-tenant:
    :authentication: $ACCESS_TOKEN
    :endpoint: https://3scale-admin.apps.ocp4.example.com

EOF

}

ocp_login >> $LOG_FILE
config_remote >> $LOG_FILE

podman run $V_T_SCALE_REMOTE $V_FILE_ARGUMENT $T_SCALE_IMAGE $T_SCALE_COMMAND
