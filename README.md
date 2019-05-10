# minidream-r-env
Resources for setting up and managing an RStudio environment for interactive mini-DREAM activities

#### AWS instance setup & dependencies:
Note: the order of steps below is, genereally, important.

- Start a Linux EC2 instance (e.g. via PR provisioning system at Sage)
- Log in instance shell
- Install git (yum install git)
- Clone this repo
- Clone https://github.com/milen-sage/minidream-challenge-2018/tree/master (or get the R-session modules on the instance some other way)
- cd in minidream-R-env and run docker-compose up --build 
	   
	Note: to install docker and docker composer composer:

		sudo yum update -y
		sudo yum install -y docker
		sudo service docker start
		sudo usermod -a -G docker <your-ec2-username>
		docker run hello-world

		sudo curl -L "https://github.com/docker/compose/releases/download/<latest-stable-release>/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

		docker composer latest version can be found here 
		https://github.com/docker/compose/releases

		sudo chmod +x /usr/local/bin/docker-compose


- In minidream-R-env run chmod -R 777 ./home   
- Run docker exec -it <container_id> bash
- You should be root in the docker container shell; add groups rstudio-user, rstudio-admin, student
- Run /root/utils/add_students.sh (see the script for usage)
- Run /root/utils/add_admins.sh (e.g. root, see the script for usage)
- From EC2 instance shell (not the docker container shell) go to minidream-challenge-2018 and copy the modules folder to a shared folder with the docker container (e.g. minidream-env-r/home)
- In docker container shell install rsync: 
	apt-get update -y
	apt-get -y install rsync
- In docker container shell run /root/utils/broadcast_modules.sh (see the script for usage)

#### Useful-commands and mics. 
`rstudio-server --help` ex. `rstudio-server suspend-all` will remove the message: "ERROR session hadabend" from an R session console after each service 'reboot'.

#### Useful-links 
- https://hub.docker.com/u/rocker/

