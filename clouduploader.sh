#!/bin/bash

# Get the file path from the first argument
FILE_PATH="$1"

# Check if the file path has been provided
if [ -z "$FILE_PATH" ]; then
  echo "Error: No file path provided."
  echo "Usage: $0 /path/to/file"
  exit 1
fi

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File does not exist at path '$FILE_PATH'."
  exit 1
fi

# Prompt the user to enter the bucket name
echo "Please enter the S3 bucket name:"
read BUCKET_NAME

# Check if the bucket name has been provided
if [ -z "$BUCKET_NAME" ]; then
  echo "Error: No S3 bucket name provided."
  exit 1
fi

# Check if the S3 bucket exists
if ! aws s3 ls "s3://$BUCKET_NAME" > /dev/null 2>&1; then
  echo "Error: Bucket named '$BUCKET_NAME' does not exist or you do not have permission to access it."
  exit 1
fi

# Proceed with file upload
echo "Preparing to upload file: $FILE_PATH"
echo "Uploading to S3 bucket: $BUCKET_NAME..."
aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/"
if [ $? -eq 0 ]; then
  echo "Upload successful."
else
  echo "Upload failed."
  exit 1
fi


