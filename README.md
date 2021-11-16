# Note: This is not working yet. Check Github issue with Container Apps
https://github.com/microsoft/azure-container-apps/issues/31

# Getting Started

1. Make sure you have an ACR ready with an admin user activated.
1. Build the agent docker image (ps script `azdoimage/imagebuildAndPush.ps1`) and push it to your ACR
1. Make sure you have a Azure DevOps Services organization and a PAT for that organization with full scope
1. fill variables in container-app/variables.ps1
1. run ps script `container-app/ressource.ps1`. It creates
    1. the Azure Container App
    1. agent pool in your organization (or reuses it)
