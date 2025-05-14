# AWS DevOps Tasks from RS.SCHOOL course

## Task 1: Software Installation and Configuration  
[Task 1 Code](https://github.com/alextonkovid/aws-devops/tree/task_1)  

I installed and configured AWS CLI v2 and Terraform on my local machine. In AWS, I created a dedicated IAM user with key permissions (e.g., EC2, S3, VPC) and enabled MFA for enhanced security. After generating access keys, I configured AWS CLI to use these credentials.

## Task 2: Basic Infrastructure Configuration  
[Task 2 Code](https://github.com/alextonkovid/aws-devops/tree/task_2)  

Using Terraform, I created networking infrastructure for a Kubernetes cluster. Implemented a VPC with either public-only and a combination of public/private subnets, based on cost and use case. Routing ensured internet access for all subnets. Verified the setup by launching an EC2 instance and pinging external IPs. Configuration used the AWS profile set up in Task 1.

## Task 3: K3s Cluster Configuration and Creation  
[Task 3 Code](https://github.com/alextonkovid/aws-devops/tree/task_3)  

I configured and deployed a Kubernetes cluster on AWS using k3s, choosing the method best suited for resource management and cost efficiency. Extended Terraform code to provision required AWS resources, including a bastion host. Deployed the cluster and accessed it via `kubectl get nodes`. Verified functionality by deploying and running a simple pod workload. Additionally, set up monitoring for the cluster using Prometheus and Grafana to ensure operational visibility.

## Task 4: Jenkins Installation and Configuration  
[Task 4 Code](https://github.com/alextonkovid/aws-devops/tree/task_4)  

I deployed Jenkins on a Kubernetes cluster using Helm, in the public network. Configured persistent volumes (PV) and claims (PVC) for Jenkins storage. Verified installation by creating a freestyle project that logged "Hello world." Additionally, set up a GitHub Actions pipeline to automate Jenkins deployment and configured authentication and security settings. Used an init script for cluster setup.

## Task 5: Simple Application Deployment with Helm  
[Task 5 Code](https://github.com/alextonkovid/aws-devops-application)  

I created a custom Helm chart to deploy a WordPress application on a Kubernetes cluster. Additionally, implemented a CI/CD pipeline to automate WordPress deployment.

## Task 6: Application Deployment via Jenkins Pipeline  
[Task 6 Code](https://github.com/alextonkovid/aws-devops-application/tree/task_6)  

I configured a Jenkins pipeline to automate the deployment of an application to a Kubernetes cluster. The pipeline, stored as a Jenkinsfile, is triggered on each repository push and includes these steps:  

1. **Docker Image Creation and ECR Storage**  
   - Built a Docker image for the application and stored it in AWS ECR.  
   - Configured K3s nodes to access ECR by updating the instance profile.  

2. **Helm Chart Creation**  
   - Developed and manually tested a Helm chart for the application.  

3. **Pipeline Steps**  
   - Application build.  
   - Unit test execution.  
   - Security check using SonarQube.  
   - Docker image build and push to ECR.  
   - Helm-based deployment to the K3s cluster.  

4. **Notifications and Documentation**  
   - Configured notifications for pipeline success or failure.  
   - Documented the setup and deployment process in a detailed README file.  

## Task 7: Prometheus Deployment on K3s  
[Task 7 Code](https://github.com/alextonkovid/aws-devops-provision/tree/task_7)  

I installed Prometheus on my Kubernetes cluster using the Bitnami Helm chart. Configured necessary exporters to collect Kubernetes-specific metrics like node memory usage. 

## Task 8: Grafana Installation and Dashboard Creation  
[Task 8 Code](https://github.com/alextonkovid/aws-devops-provision/tree/task_8)  

I deployed Grafana on the Kubernetes cluster using the Bitnami Helm chart and configured it to use Prometheus as a data source. Created a basic dashboard visualizing key metrics such as CPU and memory utilization and storage usage.

## Task 9: Alertmanager Configuration and Verification  
[Task 9 Code](https://github.com/alextonkovid/aws-devops-provision/tree/task_9)  

I configured Grafana Alerting to send email alerts for specific events like high CPU utilization and low RAM capacity on Kubernetes nodes. Set up an SMTP server for email notifications using AWS SES, and added my email as a contact point. 
