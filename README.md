# MasterClass Back End

This is the back end apis for master class learning manegement system.


## Requierments

- you must have the .env file in the root directory.
## Example for .env
```
     JWT_SECRET=secret
     JWT_EXP_DATE=10000
     MAIL_SERVICE=smtp.gmail.com
     MAIL_PORT=587
     EMAIL=example@gmail.com
     PASSWORD=password
     AUTHENTICATION=plain
```

- You must have the master.key file in the config file

- You must have Docker and docker-compose installed.

## Install instructions
- Run `docker-compose up -d` on this directory
- Head to your request to `localhost:3000`