#!/bin/bash

# Output file for the DOT graph
output_file="dependencies.dot"

# Array to keep track of processed scripts
declare -a processed_scripts

# Function to recursively extract dependencies
extract_dependencies() {
  local script_file="$1"
  local script_name="${script_file%.*}"

  # Check if the script has already been processed
  if [[ " ${processed_scripts[@]} " =~ " ${script_name} " ]]; then
    return
  fi

  # Add the script to the processed array
  processed_scripts+=("$script_name")
  
  # Extract dependencies
  grep -o 'source[[:space:]]\+[[:alnum:]_./-]*' "$script_file" | cut -d' ' -f2 | while read -r dependency; do
    # Trim leading "./" from the dependency path
    dependency="${dependency#./}"
    
    # Trim the ".sh" extension if present
    dependency="${dependency%.sh}"
    
    # Add an edge to the DOT file
    echo "\"$script_name\" -> \"$dependency\";" >> "$output_file"
    
    # Recursively process the dependency
    extract_dependencies "${dependency}.sh"
  done
}

# Initialize the DOT file
echo "digraph Dependencies {" > "$output_file"

# Process each script file recursively
find . -type f -name '*.sh' | while read -r script_file; do
  # Extract dependencies and add edges to the DOT file
  extract_dependencies "$script_file"
done

# Close the DOT file
echo "}" >> "$output_file"

