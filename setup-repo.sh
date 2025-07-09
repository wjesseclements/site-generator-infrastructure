#!/bin/bash

# Setup script for site-generator-infrastructure repository
# Run this script after cloning your GitHub repository

echo "Setting up Site Generator Infrastructure Repository..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "Error: This script should be run from the root of your git repository"
    echo "Please clone https://github.com/wjesseclements/site-generator-infrastructure first"
    exit 1
fi

# Create directory structure
echo "Creating directory structure..."
mkdir -p .github/workflows
mkdir -p templates/{data-explorer,company-pulse,pixelworks,team-polls}

echo "Repository structure created successfully!"
echo ""
echo "Next steps:"
echo "1. Copy the files from infrastructure-repo-setup/ to your repository"
echo "2. Configure GitHub repository secrets"
echo "3. Update your main Site Generator terraform.tfvars"
echo "4. Deploy the infrastructure changes"
echo ""
echo "See README.md for detailed setup instructions."