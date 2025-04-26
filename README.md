# MERN Application Deployment on AWS with Terraform and Ansible

This project demonstrates how to deploy a MERN (MongoDB, Express.js, React.js, Node.js) application on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.

## Prerequisites

- AWS Account
- AWS CLI installed and configured
- Terraform installed (v1.0.0 or later)
- Ansible installed (v2.9 or later)
- Node.js and npm installed
- An SSH key pair for AWS EC2 instances
- MongoDB Atlas account (optional, if using cloud MongoDB)

## Project Structure

```
.
├── Terraform Deployment/
│   ├── modules/
│   │   ├── compute/
│   │   ├── security/
│   │   ├── vpc/
│   │   └── tfvars/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/
│   ├── inventory/
│   ├── templates/
│   ├── webserver.yml
│   ├── dbserver.yml
│   └── security.yml
├── MERN App/
│   ├── frontend/
│   └── backend/
```

## Configuration Steps

### 1. AWS Configuration

1. Configure AWS CLI with your credentials:
```bash
aws configure
```

2. Create an SSH key pair in AWS or import your existing one:
```bash
aws ec2 import-key-pair --key-name "your-key-pair-name" --public-key-material fileb://~/.ssh/id_rsa.pub
```

### 2. Terraform Configuration

1. Update the `dev.tfvars` file in `Terraform Deployment/modules/tfvar/`:

```hcl
# VPC Configuration
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
availability_zone = "us-west-1a"
environment = "development"

# EC2 Configuration
ami_id = "ami-0f8e81a3da6e2510a"  # Ubuntu 20.04 LTS in us-west-1
key_name = "your-key-pair-name"    # Replace with your key pair name
my_ip = "YOUR_IP_ADDRESS"          # Replace with your IP address
```

2. Initialize Terraform:
```bash
cd Terraform Deployment
terraform init
```

3. Plan and apply the infrastructure:
```bash
terraform plan -var-file="modules/tfvar/dev.tfvars"
terraform apply -var-file="modules/tfvar/dev.tfvars"
```

### 3. Ansible Configuration

1. Update the inventory file in `ansible/inventory/aws_ec2.ini`:
```ini
[web]
web_server ansible_host=<web_server_public_ip>

[db]
db_server ansible_host=<database_private_ip>

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/your-key-pair-name.pem
```

2. Set MongoDB password as environment variable:
```bash
export MONGODB_PASSWORD=your_secure_password
```

3. Update the backend environment variables in `ansible/templates/env.j2`:
```
PORT=3001
MONGO_URI=mongodb://mernuser:${MONGODB_PASSWORD}@localhost:27017/merndb
```

4. Run the Ansible playbooks:
```bash
cd ansible
ansible-playbook security.yml
ansible-playbook dbserver.yml
ansible-playbook webserver.yml
```

### 4. Application Configuration

1. Update the frontend environment file `.env`:
```
REACT_APP_BACKEND_URL=http://<web_server_public_ip>:3001
```

2. Update the backend environment file `.env`:
```
PORT=3001
MONGO_URI=mongodb://mernuser:<password>@<database_private_ip>:27017/merndb
```

## Deployment Verification

1. Access the frontend application:
```
http://<web_server_public_ip>
```

2. Test the backend API:
```
http://<web_server_public_ip>:3001/api/hello
```

## Security Considerations

1. The MongoDB server is only accessible from the web server
2. SSH access is limited to your IP address
3. All servers are hardened using the security playbook
4. Web server is in a public subnet with restricted access
5. Database server is in a private subnet
6. Security groups are configured for minimal required access

## Clean Up

To destroy the infrastructure and clean up resources:

```bash
cd Terraform Deployment
terraform destroy -var-file="modules/tfvar/dev.tfvars"
```

## Environment Variables Reference

### Frontend Variables
- `REACT_APP_BACKEND_URL`: URL of the backend API

### Backend Variables
- `PORT`: Backend server port (default: 3001)
- `MONGO_URI`: MongoDB connection string

### Terraform Variables
- `vpc_cidr`: VPC CIDR block
- `public_subnet_cidr`: Public subnet CIDR
- `private_subnet_cidr`: Private subnet CIDR
- `availability_zone`: AWS availability zone
- `environment`: Environment name
- `ami_id`: AWS AMI ID
- `key_name`: SSH key pair name
- `my_ip`: Your IP address for SSH access

### Ansible Variables
- `mongodb_version`: MongoDB version
- `mongodb_port`: MongoDB port
- `mongodb_user`: MongoDB username
- `mongodb_password`: MongoDB password
- `mongodb_database`: Database name
- `app_directory`: Application directory
- `node_version`: Node.js version

## Troubleshooting

1. SSH Connection Issues:
```bash
# Check SSH connection to web server
ssh -i ~/.ssh/your-key-pair-name.pem ubuntu@<web_server_public_ip>

# Check SSH connection to database server (via web server)
ssh -J ubuntu@<web_server_public_ip> ubuntu@<database_private_ip>
```

2. MongoDB Connection Issues:
```bash
# Test MongoDB connection from web server
mongo mongodb://mernuser:password@<database_private_ip>:27017/merndb
```

3. Application Logs:
```bash
# Check PM2 logs
pm2 logs backend

# Check nginx logs
sudo tail -f /var/log/nginx/error.log
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
