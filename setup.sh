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
    exit 1
fi

# Apply changes to the .bashrc file
source ~/.bashrc
echo "Applied changes to the .bashrc file."

# echo $PATH

# Check if the rad command exists or not
echo "Radicle version: "
if command -v rad &> /dev/null; then
    rad --version
else
    echo "Rad command still not found"
    exit 1
fi


# Start the SSH agent
eval `ssh-agent`
echo  "Started SSH agent!"


#-------------------------------------------------------------------------------------------------------


# Create a directory to store the Radicle profile
mkdir -p  ~/.radicle/profiles/seeder/

export RAD_HOME=~/.radicle/profiles/seeder/
export RAD_PASSPHRASE=applycreatures

# Initialize Radicle profile

rad auth --alias creature-radicle.fly.dev && echo "Initialized Radicle identity successfully ✅." && echo "\n Radicle identity: " && rad self

cd ~/.radicle/profiles/seeder/

# cat config.json

# Set variables to be inserted into the Radicle's config.json file
config_file="config.json"
external_address="creature-radicle.fly.dev:8776"
listen="0.0.0.0:8776"

# Rename external_address and listen fields of the config.json file
jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

# cat config.json

# Start the Radicle node
rad node start --foreground

echo "Started the Radicle node successfully! 🥳"

echo "The Radicle address is $(rad node config --addresses)."

echo "setup.sh script is completed."
