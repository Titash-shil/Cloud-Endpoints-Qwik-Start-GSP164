
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])")

# Instruction for extracting the region
export REGION=$(echo "$ZONE" | cut -d '-' -f 1-2)

# Enabling required services
gcloud services enable apikeys.googleapis.com

# Downloading and extracting the quickstart files
gsutil cp gs://spls/gsp164/endpoints-quickstart.zip .
unzip endpoints-quickstart.zip

# Navigating to the required directories
cd endpoints-quickstart
cd scripts

# Deploying the API
./deploy_api.sh

# Deploying the application
./deploy_app.sh ../app/app_template.yaml $REGION

# Querying the API
./query_api.sh

# Querying the API with a parameter
./query_api.sh JFK

# Deploying the API with rate limiting
./deploy_api.sh ../openapi_with_ratelimit.yaml

# Redeploying the application
./deploy_app.sh ../app/app_template.yaml $REGION

# Creating an API key
gcloud alpha services api-keys create --display-name="awesome" 

# Fetching the API key name
KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=awesome")

# Fetching the API key string
export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

# Querying the API with the API key
./query_api_with_key.sh $API_KEY

# Generating traffic with the API key
./generate_traffic_with_key.sh $API_KEY

# Querying the API again with the API key
./query_api_with_key.sh $API_KEY

