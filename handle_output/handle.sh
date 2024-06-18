#!/bin/bash

# This is for testing.

output='✗ Error: repository is already initialized with remote rad://z2LoqHYTis9j9D2WwAYzJHWDZWEU5'
initPattern='already initialized'

if echo "$output" | grep -q "$initPattern"; then
    echo "The output contains the initPattern."
else
    echo "The output does not contain the initPattern."
fi