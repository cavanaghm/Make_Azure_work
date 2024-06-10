#!/bin/bash

FUNCTION_NAME="ai-email-ingest"

RESOURCE_GROUP="ai-services"

RESOURCE_NAME="travelman.zip"

if ! command -v az >/dev/null 2>&1; then
  echo "Error: Azure CLI is not installed. Please install it from https://docs.microsoft.com/en-us/azure/cli/install/"
  exit 1
fi

LOGGED_IN=$(az account show | jq '.user.name')

if [ "$LOGGED_IN" == "" ]; then
  echo "Error: Please login to Azure CLI using 'az login' command"
  exit 1
fi

echo "Deploying Function App: $FUNCTION_NAME"


python -m venv .venv
source .venv/bin/activate

rm ./.python_packages -rf
pip install --target="./.python_packages/lib/site-packages" -r requirements.txt

deactivate

# zip -r $RESOURCE_NAME ./function_app.py ./__init__.py ./requirements.txt ./local.settings.json ./nodes/ ./utils \
# 	./clients/ ./functions/
zip -r $RESOURCE_NAME . -x "*.git*" "*__pycache__*" "*build.sh*" ".venv/*"

ZIPPED_SIZE=$(du -h $RESOURCE_NAME)
echo "Zipped Size: $ZIPPED_SIZE"

echo "Deploying to Azure..."
az functionapp deployment source config-zip \
	-g $RESOURCE_GROUP \
	-n $FUNCTION_NAME \
	--src $RESOURCE_NAME


echo "Deployment Completed"
echo "Cleaning up..."
rm $RESOURCE_NAME

