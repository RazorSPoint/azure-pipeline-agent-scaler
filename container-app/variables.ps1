$RESOURCE_GROUP = "RG-POC_ContainerApps-AzDOAgent"
$LOCATION = "northeurope"
$CONTAINERAPPS_ENVIRONMENT = "containerapps-env"
$LOG_ANALYTICS_WORKSPACE = "containerapps-logs"
$OrgName = "<your org name>"
$AZP_TOKEN = "<PAT>" #for poc reasons use a full scoped PAT, then can use the same PAT for all the resources
$AZP_POOL = "Container-App-POC"
$AZP_URL = "https://dev.azure.com/$OrgName"
$subscriptionId = "1a96bd6b-d0ef-4083-9ebb-3d7feae16116"

#registry is expected to already exist
$registryEndpoint = "https://<acr name>.azurecr.io"
$registryUserName= "<admin>"
$registrySecret="<admin password>"