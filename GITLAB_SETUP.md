# GitLab CI/CD Setup for eShop

This document explains how to set up GitLab CI/CD for automatic deployment of the eShop application to Azure.

## 🔧 Prerequisites

1. **GitLab Repository** - Your code should be in a GitLab repository
2. **Azure Subscription** - Active Azure subscription
3. **Docker Hub Account** - For storing container images
4. **Azure Service Principal** - For GitLab to access Azure

## 🔐 Required GitLab CI/CD Variables

Navigate to your GitLab project: `Settings > CI/CD > Variables` and add these variables:

### Azure Authentication
- `AZURE_CLIENT_ID` - Azure Service Principal Client ID
- `AZURE_CLIENT_SECRET` - Azure Service Principal Client Secret (mark as **Protected** and **Masked**)
- `AZURE_SUBSCRIPTION_ID` - Your Azure Subscription ID
- `AZURE_TENANT_ID` - Your Azure Tenant ID

### Docker Hub Authentication
- `DOCKERHUB_USERNAME` - Your Docker Hub username
- `DOCKERHUB_TOKEN` - Your Docker Hub access token (mark as **Protected** and **Masked**)

## 🎯 How to Get Azure Service Principal

Run these commands in Azure CLI or Azure Cloud Shell:

```bash
# Create a service principal
az ad sp create-for-rbac --name "eShop-GitLab-SP" --role="Contributor" --scopes="/subscriptions/YOUR_SUBSCRIPTION_ID"
```

This will output:
```json
{
  "appId": "your-client-id",
  "displayName": "eShop-GitLab-SP",
  "password": "your-client-secret",
  "tenant": "your-tenant-id"
}
```

Use these values for the GitLab variables:
- `AZURE_CLIENT_ID` = `appId`
- `AZURE_CLIENT_SECRET` = `password`
- `AZURE_TENANT_ID` = `tenant`

## 🚀 Pipeline Stages

### 1. **Build Stage**
- Uses .NET 8 SDK image
- Builds the application
- Creates artifacts for deployment

### 2. **Infrastructure Stage**
- Uses Terraform to create Azure resources
- Provisions Resource Group, App Service Plan, and Web App
- Exports infrastructure details for deployment

### 3. **Deploy Stage**
- Builds Docker image
- Pushes to Docker Hub
- Deploys container to Azure Web App
- Provides deployment URL

## 🔄 Pipeline Triggers

- **Automatic**: Runs on pushes to `main` branch
- **Manual**: Can be triggered manually from GitLab UI
- **Merge Requests**: Build stage runs on MRs for validation

## 📁 Required Files

Ensure these files exist in your repository:
- `.gitlab-ci.yml` - CI/CD pipeline configuration
- `infrastructure/main.tf` - Terraform infrastructure code
- `Dockerfile` - Container build instructions
- `src/WebApp/WebApp.csproj` - .NET application

## 🔍 Monitoring

1. **Pipeline Status**: Go to `CI/CD > Pipelines` in GitLab
2. **Job Logs**: Click on individual jobs to see detailed logs
3. **Artifacts**: Download build artifacts from completed jobs
4. **Environment**: View deployment status in `Deployments > Environments`

## 🛠️ Troubleshooting

### Common Issues:

1. **Authentication Errors**
   - Verify all Azure variables are set correctly
   - Ensure Service Principal has Contributor role

2. **Docker Build Failures**
   - Check Dockerfile syntax
   - Verify base image availability

3. **Terraform Errors**
   - Ensure Azure provider is properly configured
   - Check resource naming conflicts

4. **Deployment Failures**
   - Verify Web App exists and is running
   - Check container registry authentication

## 📊 Pipeline Comparison: GitHub Actions vs GitLab CI/CD

| Feature | GitHub Actions | GitLab CI/CD |
|---------|---------------|--------------|
| Configuration File | `.github/workflows/deploy.yml` | `.gitlab-ci.yml` |
| Secrets Management | Repository Secrets | CI/CD Variables |
| Artifact Storage | Actions Artifacts | GitLab Artifacts |
| Docker Support | Built-in | Docker-in-Docker service |
| Manual Triggers | `workflow_dispatch` | `when: manual` |

## ✅ Next Steps

1. Push `.gitlab-ci.yml` to your GitLab repository
2. Configure all required CI/CD variables
3. Push to `main` branch to trigger first deployment
4. Monitor pipeline execution in GitLab UI
5. Access your deployed application at the provided URL

The pipeline will automatically:
- ✅ Build your .NET 8 application
- ✅ Create Azure infrastructure with Terraform
- ✅ Build and push Docker image
- ✅ Deploy to Azure Web App
- ✅ Provide deployment URL

Your eShop application will be live on Azure! 🎉