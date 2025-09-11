resource "aws_vpc" "demo_vpc" {
    cidr_block = "10.0.0.0/16" # CIDR block for the VPC

    tags = {
        Name = "VaultVPC" # Tagging the VPC with a name
    }
}

resource "aws_subnet" "demo_sub1" {
    vpc_id            = aws_vpc.demo_vpc.id # Reference to the VPC created above
    cidr_block        = "10.0.0.0/24" # CIDR block for the subnet
    availability_zone = "ap-south-1a" # Availability zone for the subnet
    map_public_ip_on_launch = true # Enable public IP assignment on launch

    tags = {
        Name = "VaultSubnet" # Tagging the subnet with a name
    }
}   

resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id # Reference to the VPC created above

    tags = {
        Name = "VaultIGW" # Tagging the Internet Gateway with a name
    }
}

resource "aws_route_table" "demo_rt" {
    vpc_id = aws_vpc.demo_vpc.id # Reference to the VPC created above

    route {
        cidr_block = "0.0.0.0/0" # Route for all outbound traffic
        gateway_id = aws_internet_gateway.demo_igw.id # Reference to the Internet Gateway created above
    }

    tags = {
        Name = "VaultRouteTable" # Tagging the route table with a name
    }
}

resource "aws_route_table_association" "demo_rta" {
    subnet_id      = aws_subnet.demo_sub1.id # Reference to the subnet created above
    route_table_id = aws_route_table.demo_rt.id # Reference to the route table created above

}

resource "aws_security_group" "demo_sg" {
    vpc_id = aws_vpc.demo_vpc.id # Reference to the VPC created above
    name   = "demo_sg" # Name of the security group

    ingress {
        from_port   = 22 # Allow SSH access
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Open to all IPs for demonstration purposes
    }
    
    ingress {
        from_port   = 8200 # Allow Vault access
        to_port     = 8200
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # Open to all IPs for demonstration purposes
    }

    ingress {
        from_port   = 80 # Allow HTTP access
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0 # Allow all outbound traffic
        to_port     = 0
        protocol    = "-1" # -1 means all protocols
        cidr_blocks = ["0.0.0.0/0"] # Open to all IPs
    }

    tags = {
        Name = "VaultSecurityGroup" # Tagging the security group with a name
    }
}

resource "aws_instance" "vault_instance" {
    ami           = var.ami_id_ubuntu # variable for ubuntu AMI ID
    instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro") # lookup instance type based on workspace, default to t3.micro
    subnet_id     = aws_subnet.demo_sub1.id # Reference to the subnet created above
    vpc_security_group_ids = [aws_security_group.demo_sg.id] # Attach the security group created above
    key_name      = var.key_name # variable for the key pair name 

    connection {
        type        = "ssh"
        user        = "ubuntu" # Default user for Ubuntu AMIs
        private_key = file("~/.ssh/demo-key-pair.pem") # Path to your private key file
        host        = self.public_ip # Use the public IP of the instance
    }

    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update -y",
            "sudo apt-get install -y unzip",
            "sudo apt install gpg",
            "wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
            "gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint",
            "echo \"deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list",
            "sudo apt update -y",
            "sudo apt install vault", # After this ssh into the instance and start vault with "vault server -dev -dev-listen-address="0.0.0.0:8200"
        ]
    }

    tags = {
        Name = "VaultInstance" # Tagging the instance with a name 
    }
}