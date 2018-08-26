# web_server
These scripts buid a web server to host a RoR web site promo_demo.
The site is hosted with [nginx](https://www.nginx.com/resources/wiki/) and passenger.

There are two methods for building the server [Docker](https://www.docker.com/) or [Vagrant](https://www.vagrantup.com/)


NOTE: Docker version is built on Ubuntu, )Vagrant version is built on CentOS
Docker is the prefered method, the Vagrant version is no longer being maintained

## 1. Docker
Based OS ubuntu 14.04
This builds the [cha53c/web_server](https://hub.docker.com/r/cha53c/web_server/)  on docker hub
Using this method the container is built with the application and there is no need for a seperate deployment process for the application, but you do need to pull the web app  before building the container 

NOTE:  Rails env is set in nginx conf and is set to development.

### Build
Pull this repo git@github.com:cha53c/web_server.git
cd to web_server dir
Pull the web app https://github.com/cha53c/promo_demo to the local docker contest (web_server dir). the name of the dir containing app must be the same as the name in the nginx conf. i.e. my_webapp

`docker build -t cha53c/web_server<:tag>.`


`docker push <image_name>`

### Run
The container starts nginx and the web app


`docker run -d -p 80:80 cha53c/web_server`


## 2. Vagrant (not maintained)
This contains a Vagrant file which can be used to build a server on Virtualbox or Digital Ocean.

`vagrant up --provider=virtualbox`

`vagrant up --provider=digitalocean`
 
Using this method rvm, ruby, nginx, passenger and capistrano are installed on the server and the appropriate permissions are set up for the deployment.

The site is deployed and set up using [Capistrano](http://capistranorb.com/) see (promo project??) 
ssh pub key needs to be created for deploy user
