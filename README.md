# Getting Started

1. Make sure you have an ACR ready with an admin user activated.
1. Build the agent docker image (ps script `azdoimage/imagebuildAndPush.ps1`) and push it to your ACR. The image was taken [from the docs](https://docs.microsoft.com/azure/devops/pipelines/agents/docker?view=azure-devops#create-and-build-the-dockerfile-1).
1. Make sure you have an [Azure DevOps Services organization](https://docs.microsoft.com/azure/devops/organizations/accounts/create-organization?view=azure-devops#create-an-organization) and [a PAT](https://docs.microsoft.com/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page#create-a-pat) for that organization with 'Agent Pools, Read & manage' scope
1. fill variables in container-app/ressource.ps1
1. run ps script `container-app/ressource.ps1`. It creates
    1. resource group
    1. Analytics Workspace
    1. Azure Container App environment
    1. the Azure Container App
    1. agent pool in your organization (or reuses it)
