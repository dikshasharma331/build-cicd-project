#!/bin/bash
set -e -o pipefail

echo "Fetching IAM github-action-user ARN"
if command -v jq &> /dev/null; then
    userarn=$(aws iam get-user --user-name github-action-user | jq -r .User.Arn)
else
    userarn=$(aws iam get-user --user-name github-action-user --query User.Arn --output text)
fi

OS="$(uname -s)"
BIN_NAME="aws-iam-authenticator"

case "${OS}" in
    Linux*)     URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_linux_amd64";;
    Darwin*)    URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_darwin_amd64";;
    CYGWIN*|MINGW*|MSYS*) URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_windows_amd64.exe"; BIN_NAME="aws-iam-authenticator.exe";;
    *)          URL="https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_linux_amd64";;
esac

echo "Downloading tool..."
curl -X GET -L "${URL}" -o "${BIN_NAME}"
chmod +x "${BIN_NAME}"

echo "Updating permissions"
if ! ./"${BIN_NAME}" add user --userarn="${userarn}" --username=github-action-role --groups=system:masters --kubeconfig="$HOME"/.kube/config --prompt=false 2>/dev/null; then
    echo "Updating aws-auth configmap..."
    account_id=$(echo "${userarn}" | cut -d: -f5)
    kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapUsers: |
    - userarn: ${userarn}
      username: github-action-role
      groups:
        - system:masters
  mapRoles: |
    - rolearn: arn:aws:iam::${account_id}:role/udacity-node-group
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
EOF
fi

echo "Cleaning up"
rm -f "${BIN_NAME}"
echo "Done!"