# Q2: CI/CD Pipeline

## CI/CD Pipeline for building and deploying backend application to AKS

Assumptions:

- Backend application is of a DotnetCore stack.
- Use ACR as a container registry
- Use Azure DevOps for Board/Repo/pipelines

![Build and Push image to ACR - Flow](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled.png)

Build and Push image to ACR - Flow

![AKS deployment - Flow](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%201.png)

AKS deployment - Flow

## Build Steps

1. Requirement gathering and sprint planning are listed in Azure boards as Workitems and assigned to individual developers. 
2. Setup a ‘ AzureGit Repo’  with master/main branch locked as the fist best practice. This is intended to enable developers to use other branches and raise Pull Request to master branch once they are ready. 
    
    ![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%202.png)
    
3. Enforce Workitem association for any PR submission
4. Add policy to trigger a PR build based on PR submission to master branch. 
    
    ![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%203.png)
    
5. PR-Pipeline details are as follows:
    1. Build project
    2. Run unit and functional testing
    3. Code scan using Sonarqube/Cloud for detecting code smell, code coverage, adhere quality gates
    4. Scan for vulnerabilities and licensing issues with Whiteboult scan
    
    ![PR Pipeline definition ](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%204.png)
    
    PR Pipeline definition 
    

![PR pipeline run](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%205.png)

PR pipeline run

Once the PR is approved, The code will be merged with Master branch. Build pipeline (CI) is configured to be triggered when there is a commit to master branch. Indivudual tasks of this pipeline is as follows

1. Docker Build Image: Using the docker file which includes dotnetbuild as part of the intermediate step will be run
2. Created image is scanned against an Open source scanner for vulnerabilities. In this case I have used ‘Trivia’. Based on the scan results, build will wither fail or succeed to the last step
3. Newly built image is pushed to ACR with the tag latest. 

![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%206.png)

## Release Steps

Now the Image is ready to be deployed, we will look at the deployment to the existing AKS cluster. 

AKS cluster info: 

AKS cluster has different namespaces for different stages. 

- Dev
- QA
- Staging
- Prod

These namespaces corresponds to the Azure pipeline stages with the same name. Service connection for AKS namespaces have been created. 

![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%207.png)

![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%208.png)

Trigger for this pipeline is configured to have from the build pipeline created earlier. 

Prod stage is configured to have `pre-deployment approval` set. 

Manifest file for AKS is shipped as part of the application repo itself. This will be used by deployment pipeline to create/update applications on AKS

![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%209.png)

We are maintaining only one YML file for deployment, use replace tokens to feed environment specific details at runtime for deployment. In this case, all the details related to DEV stage will be replaced in the yaml file and then be deployed to `dev namespace` on AKS.

![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%2010.png)

![Untitled](Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236/Untitled%2011.png)