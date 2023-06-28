#!/bin/bash

# Output file for the DOT graph
output_file="bash_dependencies_test.dot"

# Array to keep track of processed scripts
declare -a processed_scripts

# Function to recursively extract dependencies
extract_dependencies() {
  local script_file="$1"
  local script_name="${script_file%.*}"

  # Check if the script has already been processed
  if [[ " ${processed_scripts[*]} " =~ ${script_name} ]]; then
    echo "$script_name already processed"
    return
  fi

  # Add the script to the processed array
  processed_scripts+=("$script_name")
  declare -a dependencies
  # Extract dependencies
  grep -o 'source[[:space:]]\+[[:alnum:]_./-]*' "$script_file" | cut -d' ' -f2 | while read -r dependency; do
    # Trim leading "./" from the dependency path
    dependency="${dependency#.}"
    echo "adding $script_name"
    
    # Trim the ".sh" extension if present
    dependency="${dependency%.sh}"
    echo "with dependency $dependency"

    dependencies+=("$dependency")
    # Add an edge to the DOT file
  done
}

if (( ${#dependencies[*]} > 1 ));
then
  echo "$script_name -> {" >> "$output_file"

  for dependency in "${dependencies[@]}"; do

    echo "$dependency, " >> "$output_file"
  done
fi
echo "}" >> "$output_file"

# TODO remove when while loop get reenabled 
script_file=$1

# Recursively process the dependency
# extract_dependencies "${dependency}.sh"
if [ -f $output_file ];
then
  rm "$output_file"
fi

# Initialize the DOT file
echo "digraph Dependencies {" > "$output_file"

# Process each script file recursively
# find . -type f -name '*.sh' | while read -r script_file; do
  # Extract dependencies and add edges to the DOT file
extract_dependencies "$script_file"
# done

# Close the DOT file
echo "}" >> "$output_file"

