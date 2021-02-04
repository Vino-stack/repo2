Steps to deploy application on compute engine VM instance using Deployment Manager

1. Enable deployment manager API and Compute engine API

2.Create VPC .Configure firewall rules

3.Configure yaml configuration file for creating VM instance through Deployment Manager(Refer vm.yaml)

4.SSH to your VM

5.Install Nginix on VM
    sudo apt install nginx
    
  Configure UFW/Firewall for Nginx
     sudo apt install ufw
     
  Allow connections to SSH and the ports for Nginx
    sudo ufw allow ssh
    sudo ufw allow 'Nginx Full'
    sudo nano var/www/html/index.nginx.debian.html
    
    Enable UFW
     sudo ufw enable
     
  Check External IP to view your application
