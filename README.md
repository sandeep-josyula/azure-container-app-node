### azure-container-app-node
This is a NodeJS app on Azure Container Apps

### Tasks Overview
- Create a Node App.
    - `npm init -y`
- Install Express
    - `npm install express`
- Update `package.json`
    - `"start": "node index.js"`
- Create `index.js` and create a basic app. 
- Start app locally 
    - Run `npm start`
    - Output :
        - ```npm start

            > azure-container-app-node@1.0.0 start
            > node index.js

            This basic App is running 3000
        ```
- Create `Dockerfile` - and update with the app specifics. 
- Create `.dockerignore` 
    - ```node_modules
        npm-debug.log
        Dockerfile```
- Create Image using the `Dockerfile` - locally
    - Run : `docker build -t nodeazcontainerapp . --platform linux/amd64` 
    - The ` . ` at the end indicates the working directory. 
    - the `nodeazcontainerapp` is the name of the repository it will build. 

- Review the image file created locally.
    - Run : `docker images`
    - Output : ```docker images   
                REPOSITORY           TAG       IMAGE ID       CREATED         SIZE
                nodeazcontainerapp   latest    1e4866bc3aba   2 minutes ago   181MB
              ```
- Ensure `az cli` is on your machine
    - Command : `az --version`
- Create Azure resource group.
    - `az account set --subscription "Azure subscription 1"`
    -  `az group create --name node-app-rg --location eastus`
- Create Azure container registry. 
    - Provider required : `Microsoft.ContainerRegistry`
    - `az acr create --resource-group node-app-rg --name myacrinstance --sku Basic --location eastus`

- Login to your Azure Container Registry instance 
    - `az acr login --name myacrinstance`
    - Output : `Login Succeeded` 

- Create an alias or a new name (tag) for an existing Docker image
    - When the `docker build` command was run, the image `nodeazcontainerapp` is locally create. 
    - To create an alias 
        - `docker tag nodeazcontainerapp myacrinstance.azurecr.io/nodeazcontainerapp`
        - Since this azure container registry is your private one, an acceptable naming convention is : `myregistry.example.com/myimage`
    - Review the created "tag" (Local Command : `docker images`)
        - ```REPOSITORY                                     TAG       IMAGE ID       CREATED             SIZE
            nodeazcontainerapp                             latest    1e4866bc3aba   About an hour ago   181MB
            myacrinstance.azurecr.io/nodeazcontainerapp   latest    1e4866bc3aba   About an hour ago   181MB
          ```
- Now push the image to the Azure container registry
    - `az acr login --name myacrinstance`
    - `docker push myacrinstance.azurecr.io/nodeazcontainerapp`
- After the push completes, review the Azure Container instance "repositories"
    - Command : `az acr repository list --name myacrinstance`
    - Output : `[ "nodecontainerapp" ]`
- Now, you can use this image in the Azure Container Instance - Repositiry to build the container app. 
- Before creating an Azure Container App - you will need an Azure Container Environment (ASE)
    - Command `az containerapp env create --name nodecontainerappenv --resource-group node-app-rg --location eastus`
    - Note : Provider required - `Microsoft.App`.
    - This will also create a Log Analytics Workspace as well ( if you do not provide one during ASE creation)
    - You can group containers into a single Azure Container Environment, and they will all point to a single Log Analytics Workspace. 
- Use the image from Azure Container Registry and Create Azure Container App - and associate it with the Azure Container Environment. 
    - Head to az portal 
        - Azure container registry > Access Keys
        - Get the username and password of your azure container registry. 
    - Command : 
        - `az containerapp --name azurecontainerapp123 --resource-group node-app-rg --image myacrinstance.azurecr.io/nodecontainerapp --env nodecontainerappenv -cpu 1 --memory 2Gi --target-port 3000 --ingress external --registry-server myacrinstance.azurecr.io --registry-username myacrinstance --registry-password $env-saved`
