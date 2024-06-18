#!/bin/bash

source ~/.bashrc

eval `ssh-agent`

echo  "Started ssh agent"

rad --version

mkdir -p ~/radicle/profiles/creatures-breeder/.radicle

export RAD_HOME=~/radicle/profiles/creatures-breeder/.radicle
export RAD_PASSPHRASE=applycreatures

rad auth --alias creatures-breeder

rad self

cd ~/radicle/profiles/creatures-breeder/.radicle

cat config.json

config_file="config.json"
external_address="creature-radicle.fly.dev:8776"
listen="0.0.0.0:8776"

jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

cat config.json

rad node start --foreground

echo "start node successfully"

echo "the radicle address is $(rad node config --addresses)."

echo "setup.sh script is completed"



