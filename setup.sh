#!/bin/bash

# Path to be added
RAD_PATH='export PATH="$PATH:/home/seed/.radicle/bin"'
export PATH="/home/seed/.radicle/bin:${PATH}"

# Set permissions to seed user
chmod u+x /home/seed/.radicle/bin/rad
chmod u+x /home/seed/.radicle/bin/radicle-node
chmod u+x /home/seed/.radicle/bin/git-remote-rad

# Check if the RAD_PATH is already added into .bashrc file or not.
# If not, proceed to add.
if ! grep -q "$RAD_PATH" ~/.bashrc; then
    echo -e "\n# Added by Radicle.\n$RAD_PATH" >> ~/.bashrc
    echo "Radicle path added to ~/.bashrc"
else
    echo "Radicle path already exists in ~/.bashrc"
fi

# Apply changes to the .bashrc file
source ~/.bashrc

echo $PATH

# Check if the rad command exists or not
if command -v rad &> /dev/null; then
    rad --version
else
    echo "Rad command still not found"
fi


# mkdir -p /home/seed/.ssh
# touch /home/seed/.ssh/id_rsa
# SSH_KEY_PATH=/home/seed/.ssh/id_rsa

# Start the SSH agent
eval `ssh-agent`
echo  "Started SSH agent!"

# Add SSH key
# ssh-add $SSH_KEY_PATH

# Set read-only permission to the owner
# chmod 600 $SSH_KEY_PATH

# cd /home/seed/.ssh && ls -l
# cd ~


#-------------------------------------------------------------------------------------------------------


# Create a directory to store the Radicle profile
mkdir -p  ~/.radicle/profiles/creatures-breeder/

export RAD_HOME=~/.radicle/profiles/creatures-breeder/
export RAD_PASSPHRASE=applycreatures

# Initialize Radicle profile
rad auth --alias creature-radicle.fly.dev && rad self

cd ~/.radicle/profiles/creatures-breeder/

cat config.json

# Set variables to be inserted into the Radicle's config.json file
config_file="config.json"
external_address="creature-radicle.fly.dev:8776"
listen="0.0.0.0:8776"

# Rename external_address and listen fields of the config.json file
jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

cat config.json

# Start the Radicle node
rad node start --foreground

echo "Started the Radicle node successfully! 🥳"

echo "The Radicle address is $(rad node config --addresses)."

echo "setup.sh script is completed."
