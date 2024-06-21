#!/bin/bash

RAD_VERSION="1.0.0-rc.10"
LINUX_SYSTEM="x86_64-unknown-linux-musl"
OS_TARGET="${RAD_VERSION}-${LINUX_SYSTEM}"

echo $OS_TARGET

pwd

curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz

echo "Installed ${OS_TARGET} successfully."

curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sig

echo "Installed ${OS_TARGET} signature file successfully."

curl -O -L https://files.radicle.xyz/releases/$RAD_VERSION/radicle-$OS_TARGET.tar.xz.sha256

echo "Installed ${OS_TARGET} checksum successfully."

ls -l

# Verify the signature
ssh-keygen -Y check-novalidate -n file -s radicle-$OS_TARGET.tar.xz.sig < radicle-$OS_TARGET.tar.xz

# Verify the checksum
sha256sum -c radicle-$OS_TARGET.tar.xz.sha256

#-------------------------------------------------------------------------------------------------------

# source ~/.bashrc

# eval `ssh-agent`

# echo  "Started ssh agent"

# rad --version
 
# mkdir -p ~/radicle/profiles/creatures-breeder/.radicle

# export RAD_HOME=~/radicle/profiles/creatures-breeder/.radicle
# export RAD_PASSPHRASE=applycreatures

# rad auth --alias creatures-breeder

# rad self

# cd ~/radicle/profiles/creatures-breeder/.radicle

# cat config.json

# config_file="config.json"
# external_address="creature-radicle.fly.dev:8776"
# listen="0.0.0.0:8776"

# jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

# cat config.json

# rad node start --foreground

# echo "start node successfully"

# echo "the radicle address is $(rad node config --addresses)."

# echo "setup.sh script is completed"



