# Notepad Application

This is a simple Notepad application that allows users to sign up, log in, and save notes. The project includes a backend built with Node.js and Express, a frontend with HTML and JavaScript, and infrastructure deployment using Terraform and Docker.

## Features
- User authentication (Sign Up and Login)
- Save and retrieve notes
- Backend API with MongoDB integration
- Frontend served via NGINX
- Infrastructure deployment to Azure using Terraform

## Prerequisites
Before starting, ensure you have the following installed on your system:

1. **Node.js** (v16 or later)
   - [Download and install Node.js](https://nodejs.org/)
2. **MongoDB**
   - Install MongoDB locally or use a cloud service like MongoDB Atlas.
3. **Terraform** (v1.0 or later)
   - [Download and install Terraform](https://www.terraform.io/downloads.html)
4. **Docker**
   - [Download and install Docker](https://www.docker.com/get-started)
5. **Azure CLI** (if deploying to Azure)
   - [Download and install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd notepad1
   ```

2. Install Node.js dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   - Create a `.env` file in the root directory.
   - Add the following variables:
     ```env
     MONGO_URI=<your-mongodb-connection-string>
     PORT=5000
     ```

4. Start the development server:
   ```bash
   npm start
   ```
   The server will run on `http://localhost:5000`.

## Running the Frontend

The frontend files are located in the `public/` directory. To serve the frontend:

1. Use the provided Dockerfile to build and run the NGINX container:
   ```bash
   docker build -t notepad-frontend .
   docker run -p 80:80 notepad-frontend
   ```

2. Access the frontend at `http://localhost`.

## Deploying to Azure

1. Configure Azure credentials:
   - Set up your Azure subscription and resource group.
   - Update the `main.tf` file with your Azure subscription details.

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

4. Access the deployed application using the output URLs from Terraform.

## CI/CD

This project includes a GitHub Actions workflow for deploying to Azure Container Apps. Ensure you have the required secrets configured in your GitHub repository:
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `REGISTRY_NAME`
- `CONTAINER_APP_NAME`
- `RESOURCE_GROUP`

## License
This project is licensed under the ISC License.