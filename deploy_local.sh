# Load environment variables from .env file. 
if [ -f .env ]; then
    export $(cat .env | xargs)
fi


# Build docker image with build arguments
docker build -t docx-writer-api \
  --build-arg OPENAI_API_KEY=${OPENAI_API_KEY} \
  --build-arg LLM_MODEL=${LLM_MODEL} \
  --build-arg LLM_TEMPERATURE=${LLM_TEMPERATURE} \
  --build-arg PROXY_HOST=${PROXY_HOST} \
  --build-arg PROXY_USERNAME=${PROXY_USERNAME} \
  --build-arg PROXY_PASSWORD=${PROXY_PASSWORD} \
  --build-arg API_USERNAME=${API_USERNAME} \
  --build-arg API_PASSWORD=${API_PASSWORD} .
  

# Stop anything running on port 8080
docker stop $(docker ps -q --filter "ancestor=docx-writer-api") || true

# Launch in background
docker run -d -p 8080:8080 \
  -e OPENAI_API_KEY=${OPENAI_API_KEY} \
  -e LLM_MODEL=${LLM_MODEL} \
  -e LLM_TEMPERATURE=${LLM_TEMPERATURE} \
  -e PROXY_HOST=${PROXY_HOST} \
  -e PROXY_USERNAME=${PROXY_USERNAME} \
  -e PROXY_PASSWORD=${PROXY_PASSWORD} \
  -e API_USERNAME=${API_USERNAME} \
  -e API_PASSWORD=${API_PASSWORD} \
  docx-writer-api
