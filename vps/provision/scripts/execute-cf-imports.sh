#!/bin/bash

source .env

# directory containing the import_cmds.txt files
DIR="../terraform"

# function to process a single import block
process_import_block() {
  local TO=""
  local ID=""

  while IFS= read -r LINE; do
    # extract the 'to' and 'id' values from the line
    if [[ "$LINE" =~ to\ =\ ([^ ]+) ]]; then
      TO="${BASH_REMATCH[1]}"
    elif [[ "$LINE" =~ id\ =\ \"([^\"]+)\" ]]; then
      ID="${BASH_REMATCH[1]}"
    fi

    # if both 'to' and 'id' are found, run the import command
    if [[ -n "$TO" && -n "$ID" ]]; then
      echo "Importing $TO with ID $ID..."
      terraform import "$TO" "$ID"
      # reset TO and ID for the next block
      TO=""
      ID=""
    fi
  done
}

# find all files ending with import_cmds.txt in the directory
for FILE in $(find "$DIR" -name "*import_cmds.txt"); do
  echo "Processing $FILE..."

  # split the file into individual import blocks and process each block
  awk -v RS="\n\n" '{print > "block_" NR ".tmp"}' "$FILE"
  for BLOCK_FILE in block_*.tmp; do
    process_import_block < "$BLOCK_FILE"
    rm "$BLOCK_FILE"
  done
done