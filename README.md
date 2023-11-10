# CloudUploader CLI

## Overview
CloudUploader CLI is a bash-based tool designed for secure and easy uploading of files to Amazon S3.

## Prerequisites
- Bash (Git Bash for Windows)
- AWS CLI
- GPG (GPG4Win for Windows, GPG Tools for macOS, or GnuPG for Linux)

## Installation & Setup

### AWS CLI
Follow the instructions to install and configure the AWS CLI:
- [AWS CLI Installation](https://aws.amazon.com/cli/)

### GPG
Install GPG based on your operating system:
- **Windows**: [GPG4Win](https://www.gpg4win.org/)
- **macOS**: [GPGTools](https://gpgtools.org/)
- **Linux**: Typically pre-installed. If not, use `sudo apt install gnupg`.

## Usage
Run the script with the file path as an argument:

./clouduploader.sh /path/to/file
Follow the on-screen prompts to choose your S3 bucket and encryption options.

## Decryption
To decrypt a downloaded file, use:
gpg --decrypt yourfile.gpg > decryptedfile
You should also simply just be prompted to decrypt when you click on the file.

# Support
For issues and feature requests, please reach out to raselahmed97x@gmail.com.

Thank you for using CloudUploader CLI!










