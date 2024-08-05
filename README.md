# CI-CD-using-Jenkins
A project implementing CI/CD using Jenkins


Created EC2 instance on aws using terraform 
```
terraform init
terraform plan
terraform apply
```

Install Docker in EC2 and add Jenkins user in docker group
```
sudo yum install docker
usermod -aG docker jenkins

```

