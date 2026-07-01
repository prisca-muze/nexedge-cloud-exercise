
# NEXEDGE Cloud Exercise

This project is a simple learning exercise for building the same basic cloud setup in three different cloud providers: AWS, Azure, and Google Cloud Platform (GCP).

The main idea is simple: create a small cloud environment that can host a virtual machine, connect it safely to the internet, and give it a way to be managed. Each folder in this project does that in its own cloud system.

---

## What this project is trying to teach

This project helps a beginner understand how cloud infrastructure works using Terraform.

Terraform is a tool that writes the instructions for creating cloud resources automatically. Instead of clicking around in a cloud dashboard, you write a set of files that say what should be created.

In this project, the same general idea is used in each cloud provider:

- create a network space
- create a small computer/server inside that network
- allow safe access using security rules
- optionally add extra services such as a database or a container platform

---

## How the folders work together

The folders in this repository are separate because each cloud provider has its own rules and naming style. Even though they are different, they all serve the same purpose:

1. they create an environment for a cloud application
2. they help users learn how the same task is done in different clouds
3. they show how Terraform can be reused for different platforms

So, the folders are linked by one shared goal: learning cloud deployment in a simple and practical way.

---

## Folder-by-folder guide

### 1. AWS folder

Purpose:
- This folder creates a basic AWS network and a virtual machine on Amazon Web Services.

What it creates:
- a virtual private network
- a public and private subnet
- an internet gateway
- a route table
- a security group for access
- an EC2 virtual machine
- an SSH key pair

Main files:
- main.tf: contains the actual AWS resources
- variables.tf: defines the values the setup needs
- providers.tf: tells Terraform how to connect to AWS
- outputs.tf: shows the important results after deployment
- terraform.tfvars: stores the actual values used

Simple explanation:
- Think of this folder as building a small office building in Amazon's cloud.
- The network is the building structure.
- The virtual machine is the computer inside the building.
- The security group is the security guard.

What was observed here:
- The AWS deployment completed successfully during the last run, so this folder is working.

---

### 2. Azure folder

Purpose:
- This folder creates a similar environment in Microsoft Azure.

What it creates:
- a resource group
- a virtual network
- a subnet
- a public IP address
- a security group
- a network interface
- a Linux virtual machine

Main files:
- main.tf: contains the Azure resources
- variables.tf: defines the required Azure values
- providers.tf: configures the Azure provider
- outputs.tf: exposes useful information after deployment
- terraform.tfvars: stores Azure-specific values

Simple explanation:
- This folder builds the same kind of small cloud setup, but inside Microsoft's cloud platform.
- It is useful for comparing how Azure handles networking and virtual machines compared with AWS and GCP.

What was observed here:
- The Azure folder did not complete successfully during the latest run, so it needs attention before it can be used confidently.
- In simple terms, this folder is not fully ready yet and should be checked again before deployment.

---

### 3. GCP folder

Purpose:
- This folder builds a cloud environment in Google Cloud Platform.

What it creates:
- a custom virtual network
- two subnets in different regions
- firewall rules for web and SSH access
- two virtual machines
- IAM permissions for users
- a Cloud SQL database
- a Kubernetes cluster and node pool

Main files:
- main.tf: contains the GCP resources
- variables.tf: defines the values the setup needs
- providers.tf: connects Terraform to Google Cloud
- outputs.tf: shows the important results after deployment
- terraform.tfvars: stores the actual values used

Simple explanation:
- This folder is like building a more advanced cloud project in Google Cloud.
- It includes more services than the other two folders, such as a database and Kubernetes.

What was observed here:
- The GCP deployment hit an error while creating the Kubernetes node pool.
- The error said the connection was lost while talking to Google Cloud.
- In simple words, the cloud service was interrupted during the request, so the setup did not finish successfully.

---

## How each resource block works and why it is used

The files in this project are made of Terraform resource blocks. A resource block is a simple instruction that tells Terraform, "please create this cloud item for me." Each block has a job, and the blocks work together like pieces of a puzzle.

### AWS resources and how they work together

- aws_vpc: this creates the main private network in AWS. It is the base foundation for everything else.
- aws_subnet (public and private): these create smaller sections inside the network. The public subnet is used for resources that need to be reached from the internet, while the private subnet is used for internal resources.
- aws_internet_gateway: this connects the VPC to the internet so traffic can move in and out.
- aws_route_table: this tells the network where traffic should go. It acts like a traffic guide.
- aws_route_table_association: this links the public subnet to the route table so internet traffic can flow correctly.
- aws_security_group: this acts like a security guard. It decides which traffic is allowed in and out of the virtual machine.
- aws_instance: this creates the actual virtual machine, which is the computer that will run your services.
- aws_key_pair: this provides the SSH key so the machine can be accessed securely.

How they work hand in hand:
- The VPC is created first.
- The subnets are created inside that VPC.
- The internet gateway and route table connect the network to the outside world.
- The security group protects the machine.
- The virtual machine is placed inside the public subnet and uses the security group for access.

### Azure resources and how they work together

- azurerm_resource_group: this creates a container that holds all Azure resources for this project.
- azurerm_virtual_network: this creates the main network in Azure.
- azurerm_subnet: this splits the network into smaller sections for organization and control.
- azurerm_public_ip: this gives the virtual machine a public address so it can be reached from outside Azure.
- azurerm_network_security_group: this controls who can connect to the machine and on which ports.
- azurerm_network_interface: this connects the virtual machine to the network.
- azurerm_network_interface_security_group_association: this connects the security rules to the network interface so the machine is protected.
- azurerm_linux_virtual_machine: this creates the actual Linux server that will run the workload.

How they work hand in hand:
- The resource group holds everything together.
- The network and subnet create the environment.
- The public IP gives the machine an address.
- The security group controls access.
- The network interface connects the machine to the network.
- The virtual machine is the final server that uses all of these pieces.

### GCP resources and how they work together

- google_folder: this creates folders inside the Google Cloud organization structure to help keep resources organized.
- google_compute_network: this creates the main network in GCP.
- google_compute_subnetwork: this creates the two subnetworks in different regions.
- google_compute_firewall: this opens the right ports for web traffic and SSH access.
- google_compute_instance: this creates the virtual machines that act as servers.
- google_project_iam_member: this gives the right people permission to manage the project.
- google_sql_database_instance: this creates the managed database service.
- google_sql_user: this creates a database user account so applications can connect to the database.
- google_container_cluster: this creates the Kubernetes cluster for running container-based applications.
- google_container_node_pool: this creates the worker machines inside the Kubernetes cluster.

How they work hand in hand:
- The network is created first.
- The subnets are placed inside that network.
- Firewalls open the required access.
- The virtual machines provide compute power.
- IAM permissions make sure the right users can manage the environment.
- The database and Kubernetes services add more advanced application capabilities.

### The big picture

Across all three folders, the pattern is always the same:

1. create the network foundation
2. create access points and security rules
3. create a server or compute resource
4. add extra services such as databases or Kubernetes when needed

That is why the resources are linked the way they are. Each block depends on another block to make the full environment work properly.

---

## Why the folders are built this way

The folders are structured in the same general pattern because they are teaching the same cloud concept in different places.

They are linked this way because:

- they all follow the same Terraform workflow
- they all create a cloud environment step by step
- they all use similar building blocks such as networks, security access, and virtual machines
- they help a learner compare providers side by side

This makes the project easier to understand. Instead of learning one cloud at a time in a random way, the learner can see the same idea repeated in AWS, Azure, and GCP.

---

## Basic steps to use this project

For each folder, the process is usually the same:

1. Open the cloud folder you want to use.
2. Check the Terraform variable values in terraform.tfvars.
3. Make sure your cloud account is ready and the required credentials are available.
4. Run terraform init to prepare Terraform.
5. Run terraform plan to preview what will be created.
6. Run terraform apply to create the resources.
7. Use the outputs to find the important information, such as IP addresses or resource names.

---

## Common problems and what they mean

Here is a simple explanation of the main issues seen in this project:

- AWS: no problem was reported in the latest run, so this folder is currently in a good state.
- Azure: the deployment did not finish successfully, so it needs to be checked again before use.
- GCP: the Kubernetes part failed because the connection to Google Cloud was interrupted during setup.

In simple terms, these are not always serious code problems. Sometimes they happen because of temporary network issues, missing permissions, or wrong values in the setup.

---

## Final summary

This repository is a beginner-friendly cloud training project.

It shows that cloud infrastructure can be built using a simple set of instructions, and that the same idea can be repeated across different providers.

The folders are linked because they all teach the same lesson in different environments:
- build a network
- add security
- create a server
- connect the pieces together

That is why they are organized the way they are.
