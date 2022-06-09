# Q1: Scaling Triggers

## Backend Servers

1. Backend scaling if a a Queue Consumer:
    - Number of Messages in the Queue
    - Total CPU usage.
    - Total Memory Usage.
2. Backend Scaling if a Queue producer. 
    - Weather the Queuing system is in clustered mode and can be scaled horizontally.
    - Before scaling this backend producer, we would first scale the Queue application.
    - CPU and memory Load is to be considered as well while scaling this.

 3. Backend scaling if a Database Client:

- Total load acceptable by the Database
    - Number of connections accepted by the database
    - Total CPU load the database can withstand.
    - Total Memory the database can withstand.
    - Disk IOPS capacity of the database.
1. Backend if it is a Redis Client:
    - Scaling of Pods should be considered based on the acceptable throughput for Redis cluster

## Database performance

Based on the story, the DB that is being used is `Azure CosmosDB` , in this case database performance is mainly based on amount of provisioned throughput expressed in Request Units per second (RU/s). Trigger for scale up and scale down can be evaluated using the metric `Throughput`

Source: [https://docs.microsoft.com/en-us/azure/cosmos-db/sql/scale-on-schedule](https://docs.microsoft.com/en-us/azure/cosmos-db/sql/scale-on-schedule)

## Service Bus performance (RabbitMQ | Azure Service Bus)

Azure Service Bus is being used for this infrastructure, the performance of this being measured in `Messaging Unit` . When provisioning a premium namespace, number of messaging units allocated must be specified. This can be dynamically adjusted based on the workloads.

There are a few factors to take into consideration when deciding the number of messaging units for your architecture:

- Start with ***1 or 2 messaging units*** allocated to your namespace.
- Study the CPU usage metrics within the [Resource usage metrics](https://docs.microsoft.com/en-us/azure/service-bus-messaging/monitor-service-bus-reference#resource-usage-metrics) for your namespace.
    - If CPU usage is ***below 20%***, you might be able to ***scale down*** the number of messaging units allocated to your namespace.
    - If CPU usage is ***above 70%***, your application will benefit from ***scaling up*** the number of messaging units allocated to your namespace.

## Docker + Kubernetes

We are deploying the backend applications on AKS. To adjust to changing application demands, such as between the workday and evening or on a weekend, clusters often need a way to automatically scale. AKS clusters can scale in one of two ways:

- The **cluster autoscaler** watches for pods that can't be scheduled on nodes because of resource constraints. The cluster then automatically increases the number of nodes.
- The **horizontal pod autoscaler** uses the Metrics Server in a Kubernetes cluster to monitor the resource demand of pods. If an application needs more resources, the number of pods is automatically increased to meet the demand.

![https://docs.microsoft.com/en-us/azure/aks/media/autoscaler/cluster-autoscaler.png](https://docs.microsoft.com/en-us/azure/aks/media/autoscaler/cluster-autoscaler.png)