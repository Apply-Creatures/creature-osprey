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

# Initialize Radicle profile

if [ -d $KEYS_DIR ]; then
    echo "The keys folder exists. Re-use the existing keys..."
    rad auth
    rad self
    echo "Signed in Radicle identity successfully ✅."
else
    echo "The keys folder does not exist. Initializing new Radicle identity..."
    rad auth --alias "$RAD_ALIAS.fly.dev" && echo "Initialized Radicle identity successfully ✅."
    rad self

    # Navigate to the seed folder
    cd ~/.radicle/${USER}/

    # Set variables to be inserted into the Radicle's config.json file
    config_file="config.json"
    external_address="${NODE_NAME}.fly.dev:8776"
    listen="0.0.0.0:8776"

    # Rename external_address and listen fields of the config.json file
    jq --arg external_address "$external_address" --arg listen "$listen" '.node.externalAddresses = [$external_address] | .node.listen = [$listen]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file


    # Set the preferredSeeds to empty array
    jq '.preferredSeeds = []' $config_file > tmp.$$.json && mv tmp.$$.json config.json

fi

# Start the Radicle node
echo "Starting the Radicle node..."

rad node start

echo "Started the Radicle node successfully! 🥳"

rad node status

rad config

# Display the Radicle node address
echo "Your Radicle node address is $(rad node config --addresses)."

# Navigate to the Radicle private repository
cd /home/${USER}/${NODE_NAME}

    if [ "$(ls -A $RADICLE_REPO_STORAGE)" ]; then
        echo "There are existing radicle repositories."
        echo "Your RID is $(rad .)"
    else
        echo "No existing Radicle repositories. Initializing new repository..."

        # Initialize the Git repository
        echo "Initializing git repo..."
        git init --initial-branch=main

        # Set git user information
        git config --global user.email "bachiro.dev@gmail.com"
        git config --global user.name "Bachiro"

        echo " " >> README.md
        # Add the current changes to the staging area
        git add .

        # Commit the changes
        git commit -m "👾 Initial commit"

        # Initialize the Radicle repository
        echo "Initializing Radicle repository..."
        rad init $REPO_DIR --name ${NODE_NAME} \
                                        --description "A private repository for Apply Creatures" \
                                        --default-branch main \
                                        --set-upstream \
                                        --scope followed \
                                        --private \
                                        --no-confirm

        # Push the current commit to the main branch
        echo "Pushing to main branch..."
        git push rad main
        echo "Publishing repo to make it public..."

        rad publish

        # Seed the Radicle repository
        rad seed $(rad .) --scope followed

        # Follow peers, reads each line of the file that starts with DID
        export RADICLE_PEERS=$(sed -n '/^did/ {/^$/d; s/^/ /; p}' peers.list | tr -d '\n')

        for peer in "${RADICLE_PEERS[@]}"; do
          rad follow $peer
        done

        # Register peers to the repository
        echo "Registering peers..."
        # Build the command with all DIDs
        rad_update_cmd="rad id update --title 'Update node delegate and access' \
                            --description 'Add peers as new delegates and permit access to the repository.' \
                            --no-confirm"

        # Loop through the peers array to add --delegate and --allow options
        for peer in "${RADICLE_PEERS[@]}"; do
            rad_update_cmd="$rad_update_cmd --delegate $peer --allow $peer"
        done

        # Execute the command
        eval $rad_update_cmd

        echo "Your RID is $(rad .)"
    fi

echo "setup.sh script is completed!"

echo "starting up httpd and explorer for web UI"
cd /home/${USER}/radicle-explorer
export LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH
/home/${USER}/.radicle-httpd/bin/radicle-httpd & /root/.bun/bin/bun start
