#!/bin/bash

# Path to be added
export RAD_PATH='export PATH="$PATH:/home/seed/.radicle/bin"'
export PATH="/home/seed/.radicle/bin:${PATH}"

# Set permissions to seed user
chmod u+x /home/seed/.radicle/bin/rad
chmod u+x /home/seed/.radicle/bin/radicle-node
chmod u+x /home/seed/.radicle/bin/git-remote-rad


# Check if the the file .bashrc exists or not
if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
    echo ".bashrc is created."
fi

# ls -la

# Check if the RAD_PATH is already added into .bashrc file or not.
# If not, proceed to add.
if ! grep -q "$RAD_PATH" ~/.bashrc; then
    echo -e "# Added by Radicle.\n$RAD_PATH" >> ~/.bashrc
    echo "Radicle path added to ~/.bashrc."
else
    echo "Radicle path already exists in ~/.bashrc."
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

# Create a directory to store the Radicle profile
mkdir -p  ~/.radicle/profiles/seeder/

export RAD_HOME=~/.radicle/profiles/seed/
export RAD_PASSPHRASE=applycreatures

# Start the SSH agent
eval `ssh-agent`
echo  "Started SSH agent!"


# Initialize Radicle profile
rad auth --alias creature-radicle.fly.dev && echo "Initialized Radicle identity successfully ✅." && echo "\n Radicle identity: " && rad self

cd ~/.radicle/profiles/seed/


# Set variables to be inserted into the Radicle's config.json file
config_file="config.json"
external_address="creature-radicle.fly.dev:8776"
# external_address="109.105.219.32:8776"
listen="0.0.0.0:8776"

# Rename external_address and listen fields of the config.json file
jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

jq '.preferredSeeds = []' $config_file > tmp.$$.json && mv tmp.$$.json config.json

cat config.json

# Start the Radicle node
rad node start

echo "Started the Radicle node successfully! 🥳"

echo "The Radicle address is $(rad node config --addresses)."

#-------------------------------------------------------------------------------------------------------

cd ~/apply-creatures-private && pwd && ls -l

# echo "Initializing the Git repository."
git init --initial-branch=main
git config --global user.email "bachvo01@gmail.com"
git config --global user.name "Bachiro"
git add . 
git commit -m "👾 Initial commit"

echo "Initializing Radicle repository..."
output=$(rad init ~/apply-creatures-private --name "apply-creatures-private" \
                                   --description "A private repository for Apply Creatures" \
                                   --default-branch main \
                                   --set-upstream \
                                   --scope followed \
                                   --private \
                                   --no-confirm)

echo "Pushing to main branch..."
git push rad main

razer_did=did:key:z6MkmesFj9djBn5dyH4vMEAjZeBjCb1BYhKgBMtC2EeeknHn

rad seed $(rad .) --scope followed
rad follow $razer_did

rad id update --title "Update node delegate and access" \
              --description "Add the new delegate and node's access for other peers." \
              --delegate $razer_did \
              --allow $razer_did \
              --no-confirm

echo "Update Radicle repository..."
rad .
rad id 

echo "setup.sh script is completed!"

# Keep the container to run all the time
sleep infinity
