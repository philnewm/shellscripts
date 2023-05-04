#! /usr/bin/bash

# Define variables
name="John"
age=30
address="123 Main St."

# Format the first string and store it in a variable
output=$(printf "Name: %s\nAge: %d\nAddress: %s\n" "$name" "$age" "$address")

# Append more formatted strings to the variable
phone="555-1234"
email="john@example.com"
output=$(printf "%s\nPhone: %s\nEmail: %s\n" "$output" "$phone" "$email")

# Write the content of the variable to a file using redirection
echo "$output" > file.txt
