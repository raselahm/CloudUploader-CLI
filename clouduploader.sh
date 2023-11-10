#!/bin/bash

# Function to check if a file exists in the S3 bucket
file_exists_in_s3() {
    aws s3 ls "s3://$1/$2" > /dev/null 2>&1
}

# Function to upload a file to a specified S3 bucket
upload_to_s3() {
    local file_path=$1
    local bucket_name=$2
    local target_file_name=$3

    echo "Uploading as $target_file_name to S3 bucket: $bucket_name..."
    aws s3 cp "$file_path" "s3://$bucket_name/$target_file_name"

    if [ $? -eq 0 ]; then
        echo "Upload successful for $target_file_name."
        local presigned_url=$(aws s3 presign "s3://$bucket_name/$target_file_name" --expires-in 3600)
        echo "Shareable link (expires in 1 hour): $presigned_url"
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

# Iterate over each file provided and upload it but allow overwrite, skip, rename, rename & replace functionality
for file in "$@"; do
    if [ ! -f "$file" ]; then
        echo "Error: File does not exist at path '$file'."
        continue
    fi

    file_name=$(basename "$file")

    if file_exists_in_s3 "$BUCKET_NAME" "$file_name"; then
        echo "File $file_name already exists in $BUCKET_NAME."
        echo "Choose an option: [O]verwrite, [S]kip, [R]ename, [N]ame and replace:"
        read -r user_choice

        case $user_choice in
            [Oo]* ) 
                upload_to_s3 "$file" "$BUCKET_NAME" "$file_name"
                ;;
            [Ss]* ) 
                echo "Skipping $file_name."
                ;;
            [Rr]* ) 
                echo "Enter new file name:"
                read -r new_file_name
                upload_to_s3 "$file" "$BUCKET_NAME" "$new_file_name"
                ;;
            [Nn]* )
                echo "Enter new file name for replacement:"
                read -r replace_file_name
                aws s3 rm "s3://$BUCKET_NAME/$file_name"
                upload_to_s3 "$file" "$BUCKET_NAME" "$replace_file_name"
                ;;
            * )
                echo "Invalid option. Skipping $file_name."
                ;;
        esac
    else
        upload_to_s3 "$file" "$BUCKET_NAME" "$file_name"
    fi
done





