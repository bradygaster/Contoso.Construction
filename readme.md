# Contoso Construction

This repo contains .NET source code for the ASP.NET Core API highlighted in the CODE Magazine .NET 6 release issue for the article **Power Up your Power Apps with .NET 6 and Azure**. (Link TBD)

## Prerequisites

In order to make get this code working you'll need a few things on your machine:

* .NET 6 - [download link](https://dotnet.microsoft.com/download)
* Visual Studio 2022 Preview - [available here](https://visualstudio.microsoft.com/vs/preview/)

To deploy the code to Azure, you'll need to have:

* An Azure subscription - [sign up here](https://azure.microsoft.com/free/)
* The Azure CLI - [installation documentation](https://docs.microsoft.com/cli/azure/install-azure-cli)
* PowerShell (an `.sh` version of the setup script will be added soon)

To build a Power App that uses this API, you'd need to sign up for a [Power Apps account](http://powerapps.microsoft.com/).

## What's in this repository?

This repository's code is configured to use .NET Core 6 to access relational data in an Azure SQL Database and to store binary image uploads in an Azure Blob Storage container. Both of these resources' connection strings are stored in a Key Vault, so the web app can access them securely. All the resources are created by running the `setup/setup.ps1` file, which uses the [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) and [Azure Bicep](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview) to create the following resources:

* An Azure SQL Database server and database
* An Azure Storage account to store images uploaded via the Power App UI
* An Azure App Service to host the .NET 6 code in the repository and App Service plan (free mode)
* An Azure API Management (consumption mode) instance
* An Azure Key Vault instance to store the SQL DB and Storage connection strings

The `setup/deploy.bicep` file contains code that performs all of these actions:

* Creates each of the resources in the appropriate order
* Creates Key Vault secrets to store the SQL and Storage connection strings securely
* Defines the active CLI user and the web app as the valid Key Vault identities
* Imports the OpenAPI description produced from the .NET 6 minimal API project's endpoints into Azure API Management

## Get Started

Here's how you can create this app in your own Azure subscription. First, login to the Azure CLI on your machine:

```
az login
```

Then, clone this repository:

```
git clone https://github.com/bradygaster/Contoso.Construction
```

Finally, CD into the `setup` directory and run the `setup.ps1` file:

```
cd Contoso.Construction\setup
.\setup.ps1
``` 

Once the Azure resources are all created, `setup.ps1` compiles the .NET 6 code and publishes it using the `--self-contained` switch to make sure the .NET Core version runtime is installed with the app. The Azure CLI's `az webapp deploy` command uploads the site's code. Once the upload completes, the site's Swagger UI page is opened in the browser so you can start adding sample data. Or, you can browse to the API Management Service instance the script creates and find the API, then test it from within the API Management portal blade.

## Feedback and contributions welcome

Feel free to submit issues, fork the project and create pull requests. 