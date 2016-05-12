# The Jacqueline Project

A simple installer to create a fully functionnal Vagrant environment and instanciate a Symfony3 application in it.

## What do you need ?
To run this installer, you need :
- A working **Vagrant** on your system with the **vagrant-hostmanager** and **vagrant-vbguest** plugins (and make also sure that you have the **nfs-kernel-server** package installed).
- A working **Ansible** also.

And we'll take care of everything else.

## Let's run it !
### Clone the project
Use the `$ git clone` commande to get all the sources on your project folder as you usually do.

### Instantiate the Vagrant machine
```sh
$ vagrant up
```
If you have any trouble with others Vagrant machines on your system, just run the hostmanager : 
```sh
$ vagrant hostmanager
```

### Initialize the project
Now just connect to your Vagrant machine... 
```sh
$ vagrant ssh
```
... and then in your Vagrant machine, just go into the project folder and run the init script :
```sh
$ cd /srv/jacqueline
$ make init-project
```

### Be patient
The installation can be long, because Ansible create a full web server and add to it a lot of useful softwares like :
* APT
* Composer 
* Curl
* Git
* MailCatcher
* PHP5
* MySQL
* PostgreSQL
* Nginx
* NPM [Gulp ; Angular ; Browserify]
* VIM
* ...

The vendors install and the NPM install can be very long, so just let it run, go drink a coffee, and when you'll be back, you'll have a fully functionnal Symfony3 clean project.

Enjoy ;-)