# Ensure software packages on instance are upto date
echo "==== Updating system Pakcages ===="
sudo yum update –y

# Add the Jenkins repo
echo "==== Adding Jenkins repo ===="
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo


echo "==== Import a key file from Jenkins-CI to enable installation from the package ====="
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key; sudo yum upgrade


echo "Installing Java"
sudo yum install java-21-amazon-corretto -y

echo "Install Maven"
yum install -y maven 

echo "Install git"
yum install -y git

echo "Install Docker engine"
yum update -y
yum install docker -y
#sudo usermod -a -G docker jenkins
#sudo service docker start
sudo chkconfig docker on



echo "Installing Jenkins"
sudo yum install jenkins -y

sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on


echo "Enable the Jenkins service to start at boot"
sudo systemctl enable jenkins

echo "Start Jenkins as a service"
sudo systemctl start jenkins

echo "Status of the Jenkins service"
sudo systemctl status jenkins