#!/usr/bin/env bash
set -euo pipefail

CONSUL_TEMPLATE_VERSION="0.39.1"
CONSUL_VERSION="1.19.2"
NOMAD_VERSION="1.8.4"
VAULT_VERSION="1.17.6"


TMP=$(mktemp -d)
mkdir -p $TMP/usr/bin

wget https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip -O $TMP/consul-template.zip
unzip -o $TMP/consul-template.zip -d $TMP/usr/bin

wget https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -O $TMP/consul.zip
unzip -o $TMP/consul.zip -d $TMP/usr/bin

wget https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -O $TMP/nomad.zip
unzip -o $TMP/nomad.zip -d $TMP/usr/bin

wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip -O $TMP/vault.zip
unzip -o $TMP/vault.zip -d $TMP/usr/bin

rm $TMP/*.zip
mv $TMP flatcar-hashistack
RELOAD=1 ./bake.sh flatcar-hashistack
rm -rf "flatcar-hashistack"
