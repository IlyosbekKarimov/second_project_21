#!/bin/bash

# Read input parameter
log_file_path=$1

# Check if the log file path is provided
if [ -z "$log_file_path" ]; then
  echo "Error: Log file path is missing."
  echo "Usage: ./log_analyzer.sh <log_file_path>"
  exit 1
fi

# Check if the log file exists
if [ ! -f "$log_file_path" ]; then
  echo "Error: Log file not found: $log_file_path"
  exit 1
fi

# Initialize counters
total_records=0
unique_files=0
hash_changes=0

# Read the log file line by line
while IFS= read -r line; do
  # Increment the total number of records
  ((total_records++))

  # Extract the file path from the log line
  file_path=$(echo "$line" | awk -F ' - ' '{print $1}')

  # Check if the file path is unique
  if ! grep -q "^$file_path$" <<< "$unique_files"; then
    # Increment the number of unique files
    ((unique_files++))
  fi

  # Extract the hash value from the log line
  hash_value=$(echo "$line" | awk -F ' - ' '{print $4}')

  # Check if the hash value is "NULL" or not
  if [ "$hash_value" != "NULL" ]; then
    # Increment the number of hash changes
    ((hash_changes++))
  fi
done < "$log_file_path"

# Output the results
echo "$total_records $unique_files $hash_changes"