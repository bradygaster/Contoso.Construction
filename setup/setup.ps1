param (
    $resourceBaseName="contoso$( Get-Random -Maximum 1000)",
    $apiManagementOwnerEmail='admin@contoso.com',
    $apiManagementOwnerName='API Admin',
    $sqlServerDbUsername='contoso',
    $sqlServerDbPwd='pass4Sql!4242',
    $location='westus'
)

Write-Host 'Creating resource group' -ForegroundColor Green
az group create -l westus -n $resourceBaseName

Write-Host 'Creating Azure resources' -ForegroundColor Green
az deployment group create --resource-group $resourceBaseName --template-file deploy.bicep --parameters sqlUsername=$sqlServerDbUsername --parameters sqlPassword=$sqlServerDbPwd --parameters resourceBaseName=$resourceBaseName --parameters currentUserObjectId=$(az ad signed-in-user show --query "objectId") --parameters apimPublisherEmail=$apiManagementOwnerEmail --parameters apimPublisherName=$apiManagementOwnerName

Write-Host 'Building .NET 6 minimal API project' -ForegroundColor Green
dotnet build ..\Contoso.Construction\Contoso.Construction.csproj

Write-Host 'Packaging .NET 6 minimal API project for deployment' -ForegroundColor Green
dotnet publish ..\Contoso.Construction\Contoso.Construction.csproj --self-contained -r win-x86 -o ..\publish

try {
    dotnet tool install --global Zipper --version 1.0.1
} catch {
    # no work to do
}

try {
    Remove-Item -Path deployment.zip -Force
}
catch {
    # no work to do
}

# Compress-Archive -Path ..\publish\*.* -DestinationPath deployment.zip -Force
zipper compress -i ..\publish\ -o deployment.zip

Write-Host 'Deploying .NET 6 minimal API project to Azure Web Apps' -ForegroundColor Green
az webapp deploy -n "$($resourceBaseName)web" -g $resourceBaseName --src-path .\deployment.zip

Write-Host 'Browsing to the test page of the app' -ForegroundColor Green
az webapp browse -n "$($resourceBaseName)web" -g $resourceBaseName
