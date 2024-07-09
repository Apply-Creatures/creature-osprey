#!/bin/bash

echo "RAD_PASSPHRASE is $RAD_PASSPHRASE"

echo "Move the directory to the destination folder..."
cp -r /home/seed/creature-pigeon /home/seed/.radicle/seed/

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
    rad auth --alias creature-radicle.fly.dev && echo "Initialized Radicle identity successfully ✅." 
    rad self

    # Navigate to the seed folder
    cd ~/.radicle/${USER}/


    # Set variables to be inserted into the Radicle's config.json file
    config_file="config.json"
    external_address="creature-pigeon.fly.dev:8776"
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

# Display the Radicle node address
echo "Your Radicle node address is $(rad node config --addresses)."


# Navigate to the Radicle private repository
cd ~/.radicle/seed/creature-pigeon

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


        # Add the current changes to the staging area
        git add . 

        # Commit the changes
        git commit -m "👾 Initial commit"

        # Initialize the Radicle repository
        echo "Initializing Radicle repository..."
        rad init $REPO_DIR --name $REPO_NAME \
                                        --description "A private repository for Apply Creatures" \
                                        --default-branch main \
                                        --set-upstream \
                                        --scope followed \
                                        --private \
                                        --no-confirm


        # Push the current commit to the main branch
        echo "Pushing to main branch..."
        git push rad main


        # Peers ID
        bachiro_one_did=did:key:z6MkmesFj9djBn5dyH4vMEAjZeBjCb1BYhKgBMtC2EeeknHn
        bachiro_two_did=did:key:z6MkttLTb5NFW3hdMcgTT6f7FW6m7gkE6kosR2uEhg8dJmb1
        hirako_did=did:key:z6MknzVNznWdLv1Tj19pLzDsXF5D6SHhjWK6WiMCtop6FK4K 

        # Seed the Radicle repository
        rad seed $(rad .) --scope followed

        # Follow to peers
        rad follow $bachiro_one_did
        rad follow $bachiro_two_did
        rad follow $hirako_did
                    
        # Register peers to the repository  
        echo "Registering peers..."
        rad id update --title "Update node delegate and access" \
                    --description "Add peers as new delegates and permit access to the repository." \
                    --delegate $bachiro_two_did \
                    --delegate $bachiro_one_did \
                    --delegate $hirako_did \
                    --allow $bachiro_two_did \
                    --allow $bachiro_one_did \
                    --allow $hirako_did \
                    --no-confirm 


        echo "Update Radicle repository..."
        echo "Your RID is $(rad .)"
    fi

echo "setup.sh script is completed!"

# Keep the container to run all the time
sleep infinity
