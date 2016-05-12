# The Jacqueline Project

A simple installer to create a fully functionnal Vagrant environment and instanciate a Symfony3 application in it.

## I. What do you need ?
To run this installer, you need :
- A working **Vagrant** on your system with the **vagrant-hostmanager** and **vagrant-vbguest** plugins (and make also sure that you have the **nfs-kernel-server** package installed).
- A working **Ansible** also.

And we'll take care of everything else.

## II. Let's run it !
### II.1. Clone the project
Use the `$ git clone` commande to get all the sources on your project folder as you usually do.

### II.2. Rename it
If you want to rename your project, just do it now, using the *replace* function of your IDE. Just look for the word "*jacqueline*" and change it everywhere (except in the README) : 
* In **/VagrantFile** : 2 times
* In **/ansible/playbook.yml** : 1 time
* In **/ansible/group_vars/all** : 4 times
* In **/app/config/parameters.yml.dist** : 1 time (database name)

### II.3. Instantiate the Vagrant machine
```sh
$ vagrant up
```
If you have any trouble with others Vagrant machines on your system, just run the hostmanager : 
```sh
$ vagrant hostmanager
```

### II.4. Initialize the project
Now just connect to your Vagrant machine... 
```sh
$ vagrant ssh
```
... and then in your Vagrant machine, just go into the project folder and run the init script :
```sh
$ cd /srv/jacqueline
$ make init-project
```

### II.5. Be patient
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

### II.6. Access your project 
Now just run your web browser and access the project on the following URI : 
```
http://jacqueline.dev/
```
Where *jacqueline* is the name of your project given in step II.2 of course !

Enjoy ;-)