# ERP_application
 A little project on a ERP (Enterprise Resource Planning) application.

This project use Docker to run.

## Commands

All the commands are launched where the *docker-compose.yml* file is at the project root.

First iteration (needed to extract consistent data from database and phalcon):
> Init.bat

Launch the project:
> docker-compose up

Project only in local network:
> http://localhost:8000/

Access PHPMyAdmin:
> Username : root\
> Password : admin\
> http://localhost:8080/

Pause the project:
> docker-compose stop

Close the project (the script is only to secure persistent data in compressed files, can be used to transfert the Docker project more easily):
> Close.bat\
> docker-compose down
