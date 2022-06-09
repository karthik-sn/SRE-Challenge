# Flechenpost Interview

## STORY CONSICE - (My interpretation)

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

As shown in the Diagram, the whole of backend stack are hosted within our Private Vnet while the Load balancer would be a public Load balancer which would be connected to our Gateway Ingress Controller.

Answers to the questions requested are listed in the below pages: 

[Q1: Scaling Triggers](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Q1%20Scaling%20Triggers%20a6aa38b2c3954912b762e9ec2d862376.md)

[Q2: CI/CD Pipeline](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Q2%20CI%20CD%20Pipeline%20962bdcdac74a495c91fcc88ca187e236.md)

[Q3: Program to Analyze log file](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Q3%20Program%20to%20Analyze%20log%20file%20ce11bbf22f3e47de8ac782eb7f989b8a.md)

[Q4: log aggregation](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Q4%20log%20aggregation%20e8630df4f3bf4e069860418139f17285.md)

[Q5: Automation to create user and SSH access](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Q5%20Automation%20to%20create%20user%20and%20SSH%20access%20156cfe2ff660490889c41fdd56d3dc6c.md)

[Q6: AKS Deployment](Flechenpost%20Interview%20b4e4d8d8419c438885c8d82907950557/Q6%20AKS%20Deployment%20744f200228aa49a9b444d4b4d17a8e61.md)