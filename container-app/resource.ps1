# az cli code is taken from the docs:
#https://docs.microsoft.com/en-us/azure/container-apps/microservices-dapr-azure-resource-manager?tabs=bash#setup

#uncomment for the first time only
#az login
#az upgrade
#az extension add --source "https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.0-py2.py3-none-any.whl"
#az provider register --namespace Microsoft.Web

$scriptPath = $PSScriptRoot

$SUBSCRIPTION_ID = "1a96bd6b-d0ef-4083-9ebb-3d7feae16116"
$RESOURCE_GROUP = "RG-POC_ContainerApps-AzDOAgent"
$LOCATION = "northeurope"
$CONTAINERAPPS_ENVIRONMENT = "containerapps-env"
$LOG_ANALYTICS_WORKSPACE = "containerapps-logs"
$ORG_NAME = "<your org name>"
$AZP_TOKEN = "<PAT>" #for poc reasons use a full scoped PAT, then can use the same PAT for all the resources
$AZP_POOL = "Container-App-POC"
$AZP_URL = "https://dev.azure.com/$ORG_NAME"

#registry is expected to already exist
$REGISTRY_ENDPOINT = "https://<acr name>.azurecr.io"
$REGISTRY_ADMIN= "<admin>"
$REGISTRY_SECRET="<admin password>"

# uncomment this if you want to override vars with local vars for development
# you need to add a file 'variables.dev.ps1' to the folder 'container-app'
. "$scriptPath/variables.dev.ps1"

# select subscription
az account set --subscription $SUBSCRIPTION_ID

# create resource group
az group create `
    --name $RESOURCE_GROUP `
    --location "$LOCATION"

# log analytics workspace
az monitor log-analytics workspace create `
    --resource-group $RESOURCE_GROUP `
    --workspace-name $LOG_ANALYTICS_WORKSPACE

$LOG_ANALYTICS_WORKSPACE_CLIENT_ID = (az monitor log-analytics workspace show --query customerId -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET = (az monitor log-analytics workspace get-shared-keys --query primarySharedKey -g $RESOURCE_GROUP -n $LOG_ANALYTICS_WORKSPACE --out tsv)

# container app environement
az containerapp env create `
    --name $CONTAINERAPPS_ENVIRONMENT `
    --resource-group $RESOURCE_GROUP `
    --logs-workspace-id $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
    --logs-workspace-key $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET `
    --location "$LOCATION"

# create pool in azdo
$AZP_POOLID = (& "$scriptPath/AzDO-Pool.ps1" -OrgName $ORG_NAME -PAT $AZP_TOKEN -PoolName $AZP_POOL).id

# container app
az deployment group create `
    --resource-group $RESOURCE_GROUP `
    --template-file "$scriptPath/conatinerApp.json" `
    --parameters `
    environment_name="$CONTAINERAPPS_ENVIRONMENT" `
    location="$LOCATION" `
    azp_url="$AZP_URL" `
    azp_token="$AZP_TOKEN" `
    azp_pool="$AZP_POOL" `
    azp_poolId="$AZP_POOLID" `
    registryEndpoint=$REGISTRY_ENDPOINT `
    registryUserName=$REGISTRY_ADMIN `
    registrySecret=$REGISTRY_SECRET `
    registryImage="$REGISTRY_ENDPOINT/basedockeragent:latest"