az login
az account set --subscription '<SUBSCRIPTION_ID>'

$prefix              = 'INH-'+ (Get-Random -Minimum 1000 -Maximum 9999)
$resource_group_name = "$prefix-WRKSHP-D-AZWE-RG-1"
$template            = "./main.bicep"


$parameters = @{
    prefix      = $prefix
    serviceTag  = "WRKSHP"
    environment = "D"
    regionTag   = "AZWE"
}

$parameters = $parameters.Keys.ForEach({"$_=$($parameters[$_])"}) -join ' '

Write-Host "Deploying resources in $resource_group_name"

# Create a new resource-group
az group create -l westeurope -n $resource_group_name

# Deploy resources inside resource-group
$cmd = "az deployment group create --mode Incremental --resource-group $resource_group_name --template-file $template --parameters $parameters"
Write-Host $cmd
Invoke-Expression  $cmd

az functionapp deployment source config-zip --resource-group $resource_group_name --name $functionAppName --src ".\bin\Release\net6.0\publish.zip"

Write-Host "Function App deployed."
