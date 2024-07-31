#!/bin/bash

echo "Move the directory to the destination folder..."
cp -r /home/${USER}/${NODE_NAME} /home/${USER}/.radicle/${USER}/

# Check if the the file .bashrc exists or not
if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
    echo ".bashrc is created."
fi

# Check if the RAD_PATH is already added into .bashrc file or not.
# If not, proceed to add.
if ! grep -q "$RAD_PATH_EXPORT" ~/.bashrc; then
    echo -e "# Added by Radicle.\n$RAD_PATH_EXPORT" >> ~/.bashrc
    echo "Radicle path added to ~/.bashrc."
else
    echo "Radicle path already exists in ~/.bashrc."
fi

# Apply changes to the .bashrc file
source ~/.bashrc
echo "Applied changes to the .bashrc file."

# Start the SSH agent
echo "Starting SSH agent..."
eval `ssh-agent`
echo "Started SSH agent!"

export BASE_NAME=$(echo "$NODE_NAME" | sed 's/^creature-//')

# Initialize Radicle profile
if [ -d $KEYS_DIR ]; then
    echo "The keys folder exists. Re-use the existing keys..."
    rad auth
    rad self
    echo "Signed in Radicle identity successfully ✅."
    echo "Your RID is $(rad .)"
else
    echo "The keys folder does not exist. Initializing new Radicle identity..."
    rad auth --alias "$BASE_NAME.${DOMAIN}" && echo "Initialized Radicle identity successfully ✅."
    rad self

    # Set the preferredSeeds to empty array
    jq '.preferredSeeds = []' $config_file > tmp.$$.json && mv tmp.$$.json config.json
fi

# Follow peers, reads each line of the file that starts with DID
export RADICLE_PEERS=$(sed -n '/^did/ {/^$/d; s/^/ /; p}' peers.list | tr -d '\n')

for peer in "${RADICLE_PEERS[@]}"; do
    rad follow $peer
done

# Navigate to the seed folder
cd ~/.radicle/${USER}/

# Set variables to be inserted into the Radicle's config.json file
config_file="config.json"
external_address="${BASE_NAME}.${DOMAIN}:8776"
listen="0.0.0.0:8776"

# Rename external_address and listen fields of the config.json file
jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

# Start the Radicle node
echo "Starting the Radicle node..."

rad node start

echo "Started the Radicle node successfully! 🥳"

rad node status

rad config

# Display the Radicle node address
echo "Your Radicle node address is $(rad node config --addresses)."

echo "setup.sh script is completed!"

echo "starting up httpd and explorer for web UI"
cd /home/${USER}/radicle-explorer
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
/home/${USER}/.radicle-httpd/bin/radicle-httpd & /root/.bun/bin/bun start
