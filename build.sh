#!/bin/bash

command_exists() {
  command -v "$1" &> /dev/null
}

required_dependency() {
  if ! command_exists "$1"; then
    echo "Error: Dependency '$1' is not installed" >&2
    exit 1
  fi
}

# dependency checks
required_dependency 'jq'
required_dependency 'zip'

# Retrieving mod name and version
name=$(jq -r '.name' src/info.json)
version=$(jq -r '.version' src/info.json)

# The base name for the zip file
base_name=${name}_${version}

[[ ! -d ${base_name} ]] && mkdir "${base_name}"

cp -r src/* "${base_name}" &&
zip -r "${base_name}.zip" "${base_name}" &&
rm -r "${base_name}"

[[ ! -d out ]] && mkdir build

mv "${base_name}.zip" build/
