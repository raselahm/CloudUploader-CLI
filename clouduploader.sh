#!/bin/bash

# Function to upload a file to a specified S3 bucket
upload_to_s3() {
    local file_path=$1
    local bucket_name=$2

    echo "Uploading $file_path to S3 bucket: $bucket_name..."
    aws s3 cp "$file_path" "s3://$bucket_name/"

    if [ $? -eq 0 ]; then
        echo "Upload successful for $file_path."
    else
        echo "Upload failed for $file_path."
        return 1
    fi
}

# Check if at least one file path has been provided
if [ $# -eq 0 ]; then
    echo "Error: No file paths provided."
    echo "Usage: $0 /path/to/file1 /path/to/file2 ... /path/to/filen"
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

# Iterate over each file provided and upload it
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Error: File does not exist at path '$file'."
        continue
    fi

    upload_to_s3 "$file" "$BUCKET_NAME" || exit 1
done



