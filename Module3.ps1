function CreateRedis {
    param (
        $dns="polyrediscachephilip",
        $location="westeurope",
        $ressourcegroup="PolyglotData",
        $sku="basic",
        $vmsize="c0"
    )
    
    az group create -l $location -n $ressourcegroup
    az redis create -l $location -n $dns -g $ressourcegroup --sku $sku --vm-size $vmsize

}

az login
CreateRedis

function CreateSQLServer {
    param (
        $ServerName="polysqlsrvrphilip",
        $group="PolyglotData",
        $admin="testuser",
        $password="TestPa$$w0rd",
        $location="westeurope",
        $allowASAS="true"
    )
    
    az group create -l $location -n $group
    az sql server create --admin-password $password --admin-user $admin --location $location --name $ServerName -g $group 
}

CreateSQLServer

az sql server firewall-rule create --resource-group PolyglotData --server polysqlsrvrphilip -n alloASAS --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

function CreateAzureCosmosDB {
    param (
        $AccountName="polycosmosphilip",
        $group="PolyglotData",
        $api="Core(SQL)",
        $location="westeurope",
        $GEORedundency="False",
        $multiregionwrites="false"
    )
    
    az cosmosdb create --name $AccountName -g $group --enable-multiple-write-locations $multiregionwrites
    
}

CreateAzureCosmosDB

## Find primary key in cosmosdb
az cosmosdb list-keys --resource-group PolyglotData --name polycosmosphilip ## figure out how to get it out!
# cosmosdb primary
# woduszWO7Bc7ermfDJ4BIkzOHZzxYHZKqBwMQLNYLoWMEkBDpZvMDtsFoFdcj8BsKzYlfYEzPH1mHV73HFaxhQ==

function CreateAzureStorageAccount {
    param (
        $name="polystorphilip",
        $group="PolyglotData",
        $account="StorageV2",
        $location="westeurope",
        $sku="Standard_LRS",
        $accesstier="hot"
    )
    az storage account create --name $name -g $group --access-tier Hot --location $location --kind $account --sku $sku
}

CreateAzureStorageAccount

function CreateContainer {
    param (
        $name="images",
        $public='blob',
        $group="PolyglotData",
        $accountname="polystorphilip"
    )
    # todo: https://learning-azure.azurewebsites.net/azure-cli/
    $showconnectionstring = az storage account show-connection-string -g $group  -n $accountname
    $connectionstring = $showconnectionstring.GetValue(2)
    print $connectionstring
    az storage container create --name $name --public-access $public --connection-string $connectionstring
} 

CreateContainer

$conn='DefaultEndpointsProtocol=https;AccountName=polystorphilip;AccountKey=ohX/TdN2wTCdYwXG411Rbljm4oEwNtl1EUBVnSh7q78eJ5H25CHXJ9CRwlq0bT5hxlP9CyS1P7zBLdEsVqvKTg==;EndpointSuffix=core.windows.net'


az storage container show --name images --account-name polystorphilip --connection-string $conn
az storage container --help # -n images --connection-string $conn # --help

az storage blob url -n images --help
