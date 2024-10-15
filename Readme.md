## Terraform AWS Infrastructure Documentation

### Overview

This repository contains Terraform configuration for deploying a basic infrastructure on AWS, which includes a Virtual Private Cloud (VPC), public and private subnets, a NAT instance for routing traffic, and an Ubuntu-based EC2 instance in the private subnet. The infrastructure provides secure networking setup using security groups and route tables.

### Components

   - Resource map screenshot:
![alt text](/img/image_vpc.png)


   - 2 public subnets in different AZs
   - 2 private subnets in different AZs
   - Internet Gateway
   - Routing configuration:
     - Instances in all subnets can reach each other
     - Instances in public subnets can reach addresses outside VPC and vice-versa

#### 1. **VPC**


- **Resource Name**: `aws_vpc.main_vpc`
- **Description**: Creates a VPC with DNS support and DNS hostnames enabled.
- **CIDR Block**: Defined by `var.vpc_cidr`.
- **Tags**: 
  - `Name: main_vpc`

#### 2. **Internet Gateway**

- **Resource Name**: `aws_internet_gateway.igw`
- **Description**: Attaches an Internet Gateway to the VPC to allow outbound internet access for resources.
- **VPC ID**: `aws_vpc.main_vpc.id`
- **Tags**: 
  - `Name: main_igw`

#### 3. **Subnets**

- **Public Subnets**:
  - **Resources**: `aws_subnet.public_subnet_1`, `aws_subnet.public_subnet_2`
  - **Description**: Creates two public subnets in different availability zones.
  - **CIDR Blocks**: Defined by `var.public_subnet_cidrs`.
  - **Map Public IP on Launch**: `true`
  - **Tags**: 
    - `public_subnet_1`
    - `public_subnet_2`

- **Private Subnets**:
  - **Resources**: `aws_subnet.private_subnet_1`, `aws_subnet.private_subnet_2`
  - **Description**: Creates two private subnets in different availability zones.
  - **CIDR Blocks**: Defined by `var.private_subnet_cidrs`.
  - **Tags**: 
    - `private_subnet_1`
    - `private_subnet_2`

#### 4. **NAT instance and bastion host for secure access to the private subnets**

- **Resource Name**: `aws_instance.nat_instance`
- **Description**: Creates a NAT instance to allow private subnets to communicate with the internet without exposing the instances directly.
- **AMI ID**: Defined by `data.aws_ami.nat.id`.
- **Instance Type**: `t2.micro`
- **Subnet**: `aws_subnet.public_subnet_1.id`
- **Security Group**: `aws_security_group.nat_sg.id`
- **Tags**: 
  - `Name: nat_instance`

#### 5. **Private Instance**

- **Resource Name**: `aws_instance.private_instance`
- **Description**: Creates an Ubuntu instance in the private subnet.
- **AMI ID**: Defined by `data.aws_ami.ubuntu.id`.
- **Instance Type**: `t2.micro`
- **Subnet**: `aws_subnet.private_subnet_1.id`
- **Security Group**: `aws_security_group.private_instance_sg.id`
- **Tags**: 
  - `Name: private_instance`

#### 6. **Elastic IP for NAT Instance**

- **Resource Name**: `aws_eip.nat_eip`
- **Description**: Allocates an Elastic IP for the NAT instance.
- **Instance**: `aws_instance.nat_instance.id`

#### 7. **Route Tables**

- **Public Route Table**:
  - **Resource Name**: `aws_route_table.public_route_table`
  - **Description**: Route table for public subnets.
  - **Routes**: Default route for internet traffic (`0.0.0.0/0`) via the internet gateway.

- **Private Route Table**:
  - **Resource Name**: `aws_route_table.private_route_table`
  - **Description**: Route table for private subnets.
  - **Routes**: Default route (`0.0.0.0/0`) through the NAT instance.

- **Associations**:
  - Public Subnet Associations:
    - `aws_route_table_association.public_assoc_1`
    - `aws_route_table_association.public_assoc_2`
  - Private Subnet Associations:
    - `aws_route_table_association.private_assoc_1`
    - `aws_route_table_association.private_assoc_2`

#### 8. **Security Groups**
- Security groups and network ACLs for the VPC and subnets

- **NAT Instance Security Group**:
  - **Resource Name**: `aws_security_group.nat_sg`
  - **Description**: Allows inbound SSH and outbound internet traffic for the NAT instance.
  - **Ingress Rules**:
    - ICMP from all (`-1`)
    - TCP on specified ports.
  - **Egress Rules**:
    - Allow all outbound traffic.

- **Private Instance Security Group**:
  - **Resource Name**: `aws_security_group.private_instance_sg`
  - **Description**: Manages security for private instances.
  - **Ingress Rules**:
    - TCP on specified ports.
  - **Egress Rules**:
    - Allow all outbound traffic.

### Variables

- **vpc_cidr**: CIDR block for the VPC (default: `10.0.0.0/16`).
- **public_subnet_cidrs**: List of CIDR blocks for public subnets (default: `["10.0.1.0/24", "10.0.2.0/24"]`).
- **private_subnet_cidrs**: List of CIDR blocks for private subnets (default: `["10.0.3.0/24", "10.0.4.0/24"]`).
- **availability_zones**: Availability zones to deploy resources (default: `["eu-west-3a", "eu-west-3b"]`).
- **key_pair_name**: SSH key pair name (default: `rsschool`).
- **nat_ami**: AMI for NAT instance.
- **ubuntu_ami**: AMI for Ubuntu instance.
- **ingress_cidr**: CIDR block for inbound traffic (default: `["0.0.0.0/0"]`).
- **egress_cidr**: CIDR block for outbound traffic (default: `["0.0.0.0/0"]`).
- **ingress_ports**: Inbound ports for security groups (default: `{from_port = 0, to_port = 65535}`).

### Data Sources

- **AWS AMIs**:
  - NAT AMI (`data.aws_ami.nat`)
  - Ubuntu AMI (`data.aws_ami.ubuntu`)

This Terraform configuration enables a secure and efficient infrastructure setup for public and private resources within AWS, allowing flexible control over network traffic and security.
