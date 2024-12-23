# Load environment variables from .env file. 
if [ -f .env ]; then
    export $(cat .env | xargs)
fi

echo "SERVICE_ACCOUNT_JSON: ${SERVICE_ACCOUNT_JSON}"


# # Build docker image with build arguments
# docker build -t docx-to-gcs-api \
#   --build-arg SERVICE_ACCOUNT_JSON=${SERVICE_ACCOUNT_JSON} \
#   --build-arg API_USERNAME=${API_USERNAME} \
#   --build-arg API_PASSWORD=${API_PASSWORD} .
  

# # Stop anything running on port 8080
# docker stop $(docker ps -q --filter "ancestor=docx-to-gcs-api") || true

# # Launch in background
# docker run -d -p 8080:8080 \
#   -e SERVICE_ACCOUNT_JSON=${SERVICE_ACCOUNT_JSON} \
#   -e API_USERNAME=${API_USERNAME} \
#   -e API_PASSWORD=${API_PASSWORD} \
#   docx-to-gcs-api
