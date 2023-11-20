#!/bin/bash

echo "Starting the LimeSurvey deployment script."

# Prompt for download URL
echo "Please enter the download URL for LimeSurvey."
read -p "Download URL: " download_url
zip_file=$(basename "$download_url")
unzipped_dir="limesurvey" # Assuming the unzipped directory is named 'limesurvey'

# Remove the old directory
echo "Removing any existing LimeSurvey directory..."
rm -rf "$unzipped_dir"

# Download the file
echo "Downloading LimeSurvey from $download_url..."
wget "$download_url" || { echo "Download failed. Exiting."; exit 1; }

# Unzip the file
echo "Unzipping the downloaded file..."
unzip "$zip_file" || { echo "Unzip failed. Exiting."; exit 1; }

# Synchronize with the target directory
echo "Synchronizing files with the web server directory..."
rsync -av --progress ./"$unzipped_dir"/ /var/www/html/ --exclude 'application/config/config.php' --exclude 'upload/'

# Change ownership
echo "Setting appropriate permissions..."
chown -R www-data:www-data /var/www/html

# Clean up downloaded zip file and unzipped directory
echo "Cleaning up temporary files..."
rm -f "$zip_file"
rm -rf "$unzipped_dir"

echo "LimeSurvey deployment completed successfully."
