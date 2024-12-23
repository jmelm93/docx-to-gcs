#!/bin/bash

APP_NAME="docx-to-gcs-api"                       # name of the application
REPO_NAME="docx-to-gcs-api-repo"                 # Name of the Artifact Registry repository
PROJECT_ID="seo-workflows"                       # Google Cloud Project ID
CURRENT_DATE_TIME=$(date +%Y-%m-%d-%H-%M)        # e.g. 2020-01-01-12-00
BUILD_TAG="build_${CURRENT_DATE_TIME}"           # Build Tag: e.g., build_2022-07-10-04-01
REGION="us-central1"                             # Google Cloud region
TIMEOUT="60m"                                    # Timeout for the deployment - timeout max for cloudrun is 60 minutes          
MEMORY="12Gi"                                    # Memory for the deployment - 1Gi memory is the default for Cloud Run
CPU="4"                                          # CPU for the deployment - 1Gi CPU is the default for Cloud Run (1Gi = 1 core)

gcloud auth login
gcloud config set project ${PROJECT_ID}

# Load environment variables from .env file. 
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

echo '************************************************************************************'
echo "Starting $APP_NAME as `whoami`"
echo '************************************************************************************'

echo "--------------------------------------------------------------------------------"
echo "Building the Docker image to push to Google Artifact Registry ..."
echo "--------------------------------------------------------------------------------"

# Check if the Artifact Registry repository exists, if not, create it
if ! gcloud artifacts repositories describe ${REPO_NAME} --location=${REGION} > /dev/null 2>&1; then
    echo "Repository ${REPO_NAME} does not exist. Creating it now ..."
    gcloud artifacts repositories create ${REPO_NAME} --repository-format=docker --location=${REGION} --description="AI crawler Docker Repository"
    echo "Repository ${REPO_NAME} created successfully."
else
    echo "Repository ${REPO_NAME} already exists."
fi

# Build and push to Google Artifact Registry
gcloud builds submit --tag ${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${APP_NAME}:${BUILD_TAG} .

echo "--------------------------------------------------------------------------------"
echo "Build Done. Deploying the image to Cloud Run ..."
echo "--------------------------------------------------------------------------------"

gcloud run deploy ${APP_NAME} \
    --set-env-vars "\
        SERVICE_ACCOUNT_JSON=${SERVICE_ACCOUNT_JSON},\
        API_USERNAME=${API_USERNAME},\
        API_PASSWORD=${API_PASSWORD}" \
    --platform managed \
    --region=${REGION} \
    --timeout=${TIMEOUT} \
    --memory=${MEMORY} \
    --cpu=${CPU} \
    --image=${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${APP_NAME}:${BUILD_TAG}

echo "--------------------------------------------------------------------------------"
echo "Done."