# Flechenpost Interview

## STORY CONSICE

---

### APPLICATION STACK:

- JS / CSS and HTML for frontend applications.
- .NET for backend applications
- RABBIT-MQ (Service PaaS) for queueing application.
- Redis for InMemory data base of KV.
- Azure Cosmos DB for RDBMS.
- Azure Data Lake for Bulk storing for data which would be used for analysis.

For the architecture design, we would make use of Azure services and host all our backend applications in Kubernetes Cluster. While, all of our frontend services would be hosted on `Azure Blob storage` which would be connected to the `Azure Front Door` (CDN) service. We would be making DNS pointers for the `application gateway Ingress Controller`  and Azure frontdoor service respectively. 

Below mentioned diagram depicts the flow of data and the architecture for our application stack.

![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled.png)

As shown in the Diagram, the whole of backend stack are hosted within our Private VPC while the Load balancer would be a public Load balancer which would be connected to our Gateway Ingress Controller.

For scaling purposes, we would be considering the following aspects:

1. Backend scaling if a a Queue Consumer:
    - Number of Messages in the Queue
    - Total CPU usage.
    - Total Memory Usage.

 2. Backend scaling if a Database Client:

- Total load acceptable by the Database
    - Number of connections accepted by the database
    - Total CPU load the database can withstand.
    - Total Memory the database can withstand.
    - Disk IOPS capacity of the database.
1. Backend Scaling if a Queue producer. 
    - Weather the Queuing system is in clustered mode and can be scaled horizontally.
    - Before scaling this backend producer, we would first scale the Queue application.
    - CPU and memory Load is to be considered as well while scaling this.
2. Backend if it is a Redis Client:
    - Wheather Redis is deployed as HA service or a clustered

## CI/CD Pipeline for building and deploying backend application to AKS

Assumptions:

- Backend application is of a DotnetCore stack.
- Use ACR as a container registry
- Use Azure DevOps for Board/Repo/pipelines

Flow:

1. Requirement gathering and sprint planning are listed in Azure boards as Workitems and assigned to individual developers. 
2. Setup a ‘ AzureGit Repo’  with master/main branch locked as the fist best practice. This is intended to enable developers to use other branches and raise Pull Request to master branch once they are ready. 
    
    ![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%201.png)
    
3. Enforce Workitem association for any PR submission
4. Add policy to trigger a PR build based on PR submission to master branch. 
    
    ![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%202.png)
    
5. PR-Pipeline details are as follows:
    1. Build project
    2. Run unit and functional testing
    3. Code scan using Sonarqube/Cloud for detecting code smell, code coverage, adhere quality gates
    4. Scan for vulnerabilities and licensing issues with Whiteboult scan
    
    ![PR Pipeline definition ](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%203.png)
    
    PR Pipeline definition 
    

![PR pipeline run](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%204.png)

PR pipeline run

Once the PR is approved, The code will be merged with Master branch. Build pipeline (CI) is configured to be triggered when there is a commit to master branch. Indivudual tasks of this pipeline is as follows

1. Docker Build Image: Using the docker file which includes dotnetbuild as part of the intermediate step will be run
2. Created image is scanned against an Open source scanner for vulnerabilities. In this case I have used ‘Trivia’. Based on the scan results, build will wither fail or succeed to the last step
3. Newly built image is pushed to ACR with the tag latest. 

![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%205.png)

### Release Pipeline

Now the Image is ready to be deployed, we will look at the deployment to the existing AKS cluster. 

AKS cluster info: 

AKS cluster has different namespaces for different stages. 

- Dev
- QA
- Staging
- Prod

These stages corresponds to the Azure pipeline stages with the same name. Service connection for AKS namespaces have been created. 

![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%206.png)

![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%207.png)

Trigger for this pipeline is configured to have from the build pipeline created earlier. Each stage points to individual namespaces in AKS. 

Manifest file for AKS is listed as part of the application repo itself. 

![Untitled](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Untitled%208.png)