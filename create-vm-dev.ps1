function create-vm-dev{
    param(
        $rgName="ContainerCompute",
        $VMName="quickvm",
        $secret
    )

    az group create --location westeurope --name $rgName
    az vm create --resource-group $rgName --name $VMName --image Debian --admin-username sysadmin --admin-password $secret
}

$credential = Get-Credential -UserName sysadmin -Message "angiv password for azure vm"
$networkcredential =  $credential.GetNetworkCredential()

create-vm-dev -secret $networkcredential.Password
