sudo apt update
sudo apt install openjdk-8-jdk

#Install Jenkins
#To install latest version of Jenkins, add the repository key to the system and add the repository address to the sources list.

sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

#Now you can update and install Jenkins.

sudo apt update
sudo apt install jenkins

#Starting Jenkins
#Once the installation is complete you can start Jenkins using the following command.
sudo ufw enable
sudo ufw allow 8080

sudo systemctl start jenkins
