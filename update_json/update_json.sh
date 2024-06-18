#!/bin/bash

new_host="127.0.0.1"
new_port=9090
new_db_user="Bum"
new_db_password="halo"
new_db_name="newdatabase"
new_address="address:1234"

config_file="dummy.json"

jq ".server.host = \"$new_host\" |
    .server.port = \"$new_port\" |
    .database.user = \"$new_db_user\" |
    .database.password = \"$new_db_password\" |
    .database.name = \"$new_db_name\"" $config_file > tmp.$$.json && mv tmp.$$.json $config_file

jq --arg new_address "$new_address" '.address = [$new_address]' "$config_file" > tmp.$$.json && mv tmp.$$.json $config_file

echo "Successfully update json file."