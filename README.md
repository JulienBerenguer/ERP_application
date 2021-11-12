# ERP_application
 A little project on a ERP (Enterprise Resource Planning) application.

This project use Docker to run.

## Commands

First iteration (needed to extract consistent data from database and phalcon)
> Init.bat

Launch the project (where the *docker-compose.yml* file is)
> docker-compose up

Project only in local network
> http://localhost:8000/

Access PHPMyAdmin
> Username : root\
> Password : admin\
> http://localhost:8080/

Pause the project
> docker-compose stop

Close the project (caution, at risk to lost persistent data)
> docker-compose down
