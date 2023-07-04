#!/bin/bash

# Output file for the DOT graph
output_file="bash_dependencies_test.dot"

# Array to keep track of processed scripts
declare -a processed_scripts

# INFO check for parameter
if [ $# -lt 1 ];
then
  echo "missing parameter \"script\""
  exit 1
fi

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
  while read -r dependency; 
  do
    # Trim leading "./" from the dependency path
    dependency="${dependency#.}"
    echo "adding $script_name"
    # Trim the ".sh" extension if present
    dependency="${dependency%.sh}"
    echo "with dependency $dependency"

    dependencies+=("\"$dependency\"")
  done < <(grep -o 'source[[:space:]]\+[[:alnum:]_./-]*' "$script_file" | cut -d' ' -f2)

  # INFO distinguish between multiple or single dependency per script
  if (( ${#dependencies[*]} > 1 ));
    then
    dep_edge=$(printf "\"%s\" -> {" "$script_name") 

    for dependency in "${dependencies[@]}";
    do
      dep_edge=$(printf "%s\n\t%s," "$dep_edge" "$dependency")
    done
    
    dep_edge="${dep_edge%,}"
    dep_edge=$(printf "%s}" "$dep_edge")
    
    echo "$dep_edge" >> "$output_file"
  
  # TODO find way around else
  else
    dep_edge=$(printf "\"%s\" -> \"%s\"" "$script_name" "${#dependencies[0]}")
    echo "$dep_edge" >> "$output_file"
  fi

  # TODO reanable recursion
  # Recursively process the dependency
  # extract_dependencies "${dependency}.sh"
}

# TODO remove when while loop get reenabled 
script_file=$1
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

