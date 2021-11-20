# Getting Started

**[Read also my blog](https://www.razorspoint.com/2021/11/19/scalable-container-based-azure-pipelines-pools-with-azure-container-apps/) post for more details.**

## Prerequisites

For this example here the following tools are needed:

* PowerShell V5.0 or higher
* PowerShell [Module VSTeam](https://www.powershellgallery.com/packages/VSTeam) --> `Install-Module VSTeam`
* [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)
* an Azure Subscription
* an Azure DevOps Organization

## Run the example

1. Make sure you have an ACR ready with an admin user activated.
1. Build the agent docker image (ps script `azdoimage/imagebuildAndPush.ps1`) and push it to your ACR. The image was taken [from the docs](https://docs.microsoft.com/azure/devops/pipelines/agents/docker?view=azure-devops#create-and-build-the-dockerfile-1).
1. Make sure you have an [Azure DevOps Services organization](https://docs.microsoft.com/azure/devops/organizations/accounts/create-organization?view=azure-devops#create-an-organization) and [a PAT](https://docs.microsoft.com/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=preview-page#create-a-pat) for that organization with 'Agent Pools, Read & manage' scope
1. fill variables in container-app/resource.ps1
1. run ps script `container-app/resource.ps1`. It creates
    1. resource group
    1. Analytics Workspace
    1. Azure Container App environment
    1. the Azure Container App
    1. agent pool in your organization (or reuses it)

## More Information

[On my blog I wrote a bit more](https://www.razorspoint.com/2021/11/19/scalable-container-based-azure-pipelines-pools-with-azure-container-apps/) than here especially about the connecting technologies and the heart of the scaler.
It assumes you don't need a hand in any of those scripting languages or docker or containers.

But here are some more links to get you started with the used technologies:

* [Azure Container Apps](https://docs.microsoft.com/azure/container-apps/overview)
* [Azure DevOps](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwi2x4_mnaf0AhVC2qQKHcKpAYwQwqsBegQIHBAB&url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DJhqpF-5E10I&usg=AOvVaw3HsXkw7rGpJoZZiILwEpLU)
  * [Azure Pipelines](https://docs.microsoft.com/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops#:~:text=Azure%20Pipelines%20automatically%20builds%20and,ship%20it%20to%20any%20target.)
* [Docker](https://docs.docker.com/get-started/overview/)
* [KEDA](https://keda.sh/#:~:text=KEDA%20is%20a%20Kubernetes%2Dbased,added%20into%20any%20Kubernetes%20cluster.)
* [Kubernetes](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)

## But wait! Isn't this idea specific to Azure DevOps

Basically yes! Because Container Apps don't care what you run.
So you could take the principle to GitHub, GitLab and Jenkins. The thing you need is a scaler available in KEDA and an API on these System where you could check the queue of waiting jobs. Then you just go to [KEDA's github repo](https://github.com/kedacore/keda) and make a PR.
