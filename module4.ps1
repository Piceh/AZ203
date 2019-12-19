# Module 4

az login

## 1. Create a nice webapp

$resourcegroup = "MonitoredAssets"
$insightname = "instrmphilip"
$_location = "westeurope"
$appserviceplan = "MonitoredPlan"

function CreateApplicationInsights {
    param (
        $group = $resourcegroup,
        $name = $insightname,
        $location = $_location
    )
    
    # Make sure we have the app insight extension!
    az extension add --name application-insights
    az group create -l $location -n $group
    az monitor app-insights component create --app $name --location $location --resource-group $group
}

CreateApplicationInsights

# Get Instrumentation Key! # Fif output til JSON og få dens "query name!"
$instrumentationkey = $(az monitor app-insights component show --app $insightname --resource-group $resourcegroup --query 'instrumentationKey' -o tsv)
echo $instrumentationkey

# Task 3 Create an Web App resource

$webappname = "smapapiphilip"

function createWebAppResource {
    param (
        $group = $resourcegroup,
        $name = $webappname,
        $publish = "Code",
        $runtimeStack=".NET Core 3.0",
        $region = $_location,
        $NewAppServicePlan=$appserviceplan,
        $SKU="Free",
        $applicationInsight="true",
        $existingApplicatinInsightRessource=$insightname,
        $location = $_location
    )
    
    az appservice plan create --name $NewAppServicePlan --resource-group $group --sku $SKU --location $location
    az webapp create --name $name --plan $NewAppServicePlan --resource-group $group
}

createWebAppResource

# Record the URI
$site = $( az webapp show -n $webappname -g $resourcegroup --query "defaultHostName" -o tsv)

start-process("https://$site")

az webapp --help

# Get Appservice JSON
az appservice plan list --resource-group $resourcegroup -o json # --help

# Set numbers of instances

$testmax = "maximumNumberOfWorkers=8"

az appservice plan update --name $appserviceplan --resource-group $resourcegroup --set $testmax

