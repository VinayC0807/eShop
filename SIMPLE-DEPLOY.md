# Simple eShop Azure Deployment

Deploy eShop to Azure with one click! 🚀

## Setup

1. **Create Docker Hub account** at [hub.docker.com](https://hub.docker.com)
2. **Create Azure Service Principal**:
   ```bash
   az ad sp create-for-rbac --name "eshop-deploy" --role contributor --scopes /subscriptions/{subscription-id} --sdk-auth
   ```
3. **Add GitHub Secrets**:
   - `AZURE_CREDENTIALS` = JSON output from step 2
   - `DOCKERHUB_USERNAME` = Your Docker Hub username
   - `DOCKERHUB_TOKEN` = Your Docker Hub access token

## Deploy

Push to `main` branch or click "Run workflow" in GitHub Actions.

## What it creates

- 1 Azure Resource Group
- 1 Azure App Service Plan (B1)
- 1 Azure Web App (Linux)
- Docker image on Docker Hub

## Architecture

```
GitHub → Docker Hub → Azure Web App
```

That's it! No database, no monitoring, no complexity. Just a simple web app deployment.

## Cost

~$13/month for B1 App Service Plan