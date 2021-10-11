#!/bin/bash

apiManagementOwnerEmail='admin@contoso.com',
apiManagementOwnerName='API Admin',
sqlServerDbUsername='contoso',
sqlServerDbPwd='pass4Sql!4242',
location='westus'
resourceBaseName='contoso'$RANDOM
echo $resourceBaseName

az group create -l westus -n $resourceBaseName
az deployment group create --resource-group $resourceBaseName --template-file deploy.bicep --parameters sqlUsername=$sqlServerDbUsername --parameters sqlPassword=$sqlServerDbPwd --parameters resourceBaseName=$resourceBaseName --parameters currentUserObjectId=$(az ad signed-in-user show --query "objectId") --parameters apimPublisherEmail=$apiManagementOwnerEmail --parameters apimPublisherName=$apiManagementOwnerName

dotnet build ..\Contoso.Construction\Contoso.Construction.csproj
dotnet publish ..\Contoso.Construction\Contoso.Construction.csproj --self-contained -r win-x86 -o ..\publish
dotnet tool install --global Zipper --version 1.0.1
zipper compress -i ..\publish\ -o deployment.zip
az webapp deploy -n "$($resourceBaseName)web" -g $resourceBaseName --src-path .\deployment.zip
az webapp browse -n "$($resourceBaseName)web" -g $resourceBaseName