# minidream-r-env
Resources for setting up and managing an RStudio environment for interactive mini-DREAM activities

#### Synapse miniDREAM project setup
- Clone previous year miniDREAM project
- Clean Synapse submission folders (e.g. [here](https://www.synapse.org/#!Synapse:syn25653271))
- Update miniDREAM student and organizer teams
- Add a challenge to the miniDREAM project
- Add evaluation queue to the challenge
- Update logo, wikis (including leaderboard wikis), miniDREAM schedule

#### AWS instance setup & dependencies:
Note: the order of steps below is, genereally, important.

- Start a Linux EC2 instance (e.g. via PR provisioning system at Sage)
- Log in instance shell
- Install git (yum install git)
- Clone this repo
- cd in minidream-R-env and edit Dockerfile
	- update to [this Dockerfile](https://github.com/milen-sage/minidream-r-env/blob/develop/Dockerfile); it contains needed dependencies
	- update to rocker/rstudio docker v4.0

- run docker-compose up --build 
	   
	**Note**: to install docker and docker composer composer:

		sudo yum update -y
		sudo yum install -y docker
		sudo service docker start
		sudo usermod -a -G docker <your-ec2-username>
		docker run hello-world

		sudo curl -L "https://github.com/docker/compose/releases/download/<latest-stable-release>/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

		docker composer latest version can be found here 
		https://github.com/docker/compose/releases

		sudo chmod +x /usr/local/bin/docker-compose

- In minidream-R-env run chmod -R 777 ./home (create the dir if it doesn't exist)   
- Get the contents of https://github.com/milen-sage/minidream-challenge in ./home/shared (create the dir if it doesn't exist) 
- Update submission [folders](https://github.com/milen-sage/minidream-challenge/blob/66835505c1ff3f52d4081a3b3ffac61e750c6f1f/R/submission_helpers.R#L160) in  ./home/shared/R/submission_helpers.R; these need to point to submission module folders in Synapse miniDREAM project (for instance [here](https://www.synapse.org/#!Synapse:syn25653271)).
- Update [evaluation queue](https://github.com/milen-sage/minidream-challenge/blob/66835505c1ff3f52d4081a3b3ffac61e750c6f1f/R/submission_helpers.R#L176) ./home/shared/R/submission_helpers.R; this needs to point to evaluation queue of the challenge in Synapse miniDREAM project
- Update [evaluation queue](https://github.com/milen-sage/minidream-challenge/blob/66835505c1ff3f52d4081a3b3ffac61e750c6f1f/R/collect_submissions.R#L8) in ./home/shared/R/collect_submission.R
- Update ./home/shared/scoring_harness/challenge_config.py (miniDREAM project, challenge name, challenge evaluation queue, admin users)
- Install dependencies for scoring harness scripts (e.g. using conda)
- Update ./home/shared/scoring_harness/challenge_eval.sh (i.e. venv source and admin users notified of challenge submissions)
- Add ./home/shared/scoring_harness/challenge_eval.sh to cronjob list using crontab; set to run every 1-2 minutes
- Run docker exec -it <container_id> bash 
- You should be root in the docker container shell; add groups rstudio-user, rstudio-admin, student
- Run /root/utils/add_students.sh (see the script for usage; needs a list of miniDREAM students prior to running)
- Run /root/utils/add_admins.sh (e.g. root, see the script for usage)
- In docker container shell install rsync (if needed): 
	apt-get update -y
	apt-get -y install rsync


#### Updating module materials, challenges and related dependencies
- To update module content
	- copy new module content to ./home/shared/modules/<module_name> (e.g. via scp)
	- in docker container shell run /root/utils/broadcast_modules.sh with proper parameters (see the script for usage); this distributes the specified updated module to users in a specified group (e.g. students); make sure the script overwrites the existing content)
- To update challenge solution evaluation scripts
	- update the eval function in the ./home/shared/modules/<module_name>/.eval/eval_fxn.R
	- update corresponding submission helper function in ./home/shared/R/submission_helpers.R
- To update module content dependencies
	- for RStudio: in docker container run R -e "install.packages(...)" (e.g. R -e "install.packages('synapser', repos=c('http://ran.synapse.org', 'http://cran.fhcrc.org'))" installs synapser dependency used in modules for challenge submission) 
	- for docker linux image: in docker container run sudo apt-get install (e.g. sudo apt-get install libpng-dev libtiff-dev fftw-dev installs dependencies for imageR)


#### Useful-commands and mics. 
`rstudio-server --help` ex. `rstudio-server suspend-all` will remove the message: "ERROR session hadabend" from an R session console after each service 'reboot'.

#### Useful-links 
- https://hub.docker.com/u/rocker/

