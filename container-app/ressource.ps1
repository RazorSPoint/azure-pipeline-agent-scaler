# az cli code is taken from the docs:
#https://docs.microsoft.com/en-us/azure/container-apps/microservices-dapr-azure-resource-manager?tabs=bash#setup

#uncomment for the first time only
#az login
#az upgrade
#az extension add --source "https://workerappscliextension.blob.core.windows.net/azure-cli-extension/containerapp-0.2.0-py2.py3-none-any.whl"
#az provider register --namespace Microsoft.Web

$scriptPath = $PSScriptRoot
#& "$scriptPath/variables.ps1"
& "$scriptPath/variables.dev.ps1"

az account set --subscription $subscriptionId

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
$AZP_POOLID = (& "$scriptPah/azDOResources.ps1" -OrgName $OrgName -PAT $AZP_TOKEN -PoolName $AZP_POOL).id

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
    registryEndpoint=$registryEndpoint `
    registryUserName=$registryUserName `
    registrySecret=$registrySecret `
    registryImage="$registryEndpoint/basedockeragent:latest"


# get container logs
az monitor log-analytics query `
    --workspace $LOG_ANALYTICS_WORKSPACE_CLIENT_ID `
    --analytics-query "ContainerAppConsoleLogs_CL | where ContainerAppName_s == 'my-container-app' | project ContainerAppName_s, Log_s, TimeGenerated | take 3" `
    --out table