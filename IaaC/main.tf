# get VPC
data "aws_vpc" "main" {
    tags = {
      Name = "Main"
    }
}
# get SG
data "aws_security_group" "main" {
  tags = {
    Name = "my_sg"
  }
}
# get key
data "aws_key_pair" "main" {
  tags = {
    Name ="mumbai-key"
  }
}

resource "aws_instance" "main"{
  instance_type = "t2.micro"
  ami = "ami-0d473344347276854"
  vpc_security_group_ids = [ data.aws_security_group.main.id ]
  key_name = data.aws_key_pair.main.key_name
  associate_public_ip_address = true
#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install -y openjdk-11-jdk
#     curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
#         /usr/share/keyrings/jenkins-keyring.asc > /dev/null
#     echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
#         https://pkg.jenkins.io/debian binary/ | sudo tee \
#         /etc/apt/sources.list.d/jenkins.list > /dev/null
#     sudo apt update -y
#     sudo apt install -y jenkins
#     sudo systemctl start jenkins
#     sudo systemctl enable jenkins
#     sudo ufw allow 8080
#     sudo systemctl restart jenkins
# EOF

user_data = <<-EOF
              #!/bin/bash
              # Update the package index
              sudo yum update -y

              # Install Java (Jenkins dependency)
              sudo amazon-linux-extras install java-openjdk11 -y

              # Add the Jenkins repo and import the GPG key
              sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

              # Install Jenkins
              sudo yum install jenkins -y

              # Enable and start Jenkins service
              sudo systemctl enable jenkins
              sudo systemctl start jenkins

              # Install Git (optional, but useful for Jenkins)
              sudo yum install git -y
              EOF

 
  tags = {
    Name = "Jenkins Server"
  }
}

output "link" {
  value = "http://${aws_instance.main.public_ip}:8080"
}

