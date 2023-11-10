#! /bin/bash

FILE_PATH="$1"

if [ -z "$FILE_PATH" ]; then
  echo "Error: No file path provided."
  echo "Usage: $0 /path/to/file"
  exit 1
fi

echo "Preparing to upload file: $FILE_PATH"

if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File does not exist at path '$FILE_PATH'."
  exit 1
else
  echo "File found: $FILE_PATH"
fi

