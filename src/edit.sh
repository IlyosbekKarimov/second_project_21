#!/bin/bash

replace_substring() {
  local file=$1
  local search=$2
  local replace=$3
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local file_size=$(stat -c%s "$file")
  local file_hash=$(sha256sum "$file" | awk '{print $1}')

  sed -i "s/$search/$replace/g" "$file"

  echo "src/$file - $file_size - $timestamp - $file_hash - SHA256" >> files.log
}

file_path=$1
search_string=$2
replacement=$3

if [ -z "$file_path" ] || [ -z "$search_string" ] || [ -z "$replacement" ]; then
  echo "Usage: ./edit.sh <file_path> <search_string> <replacement>"
  exit 1
fi

if [ ! -f "$file_path" ]; then
  echo "Error: File not found: $file_path"
  exit 1
fi

replace_substring "$file_path" "$search_string" "$replacement"

echo "Replacement completed successfully."