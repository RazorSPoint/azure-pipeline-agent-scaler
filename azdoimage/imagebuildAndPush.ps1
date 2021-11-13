
$AZP_URL = "https://dev.azure.com/<org name>"
$AZP_TOKEN = "<PAT>" #needs manage agent and pool scope
$AZP_POOL = "<pool name>"

$baseImageName = "basedockeragent"
$tag = "latest"

docker build -t $baseImageName .

#test locally
docker run -e AZP_URL=$AZP_URL -e AZP_TOKEN=$AZP_TOKEN -e AZP_POOL=$AZP_POOL $baseImageName --once

#push to ACR
$acr = "<acr name>.azurecr.io"

docker tag $baseImageName "$acr/$($baseImageName):$tag"
docker push "$acr/$($baseImageName):$tag"
