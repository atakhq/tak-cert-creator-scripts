# TAK Server User Cert Creation Helper
Script package to help with the mass creation of user certificates in TAK server Docker install, including ITAK compatible package output.

## More info Here: https://atakhq.com/en/tak-server/cert-enrollment

Login as TAK Superuser and clone this repo to your machine

`su - tak`

`cd /tmp/ && git clone https://github.com/atakhq/tak-cert-enrollment-script.git && sudo chmod -R +x * /tmp/tak-cert-creator-scripts/`

Open a shell for your Docker container running TAK Server

`docker exec -it tak-server-tak-1 /bin/bash`

Clone this project into the docker container, make executable, run it

`cd /tmp/ && git clone https://github.com/atakhq/tak-cert-creator-scripts.git && cd /tmp/tak-cert-creator-scripts/ && chmod +x * && ./certCreatorSetupScript.sh`


