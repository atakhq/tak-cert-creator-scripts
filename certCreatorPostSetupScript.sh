#!/bin/bash

echo ""
echo "*** MAKE SURE YOU ARE RUNNING THIS FROM YOUR MACHINE, NOT INSIDE DOCKER CONTAINER!!!! ***"
echo ""
echo "This script will tranfer over the cert files from inside the docker image to your machine so you can download and give to users"
echo ""
read -p "Press any key to being..."

#Figure out which truststore to use
while true; do
echo "Does your server use Certificate Enrollment (intermediate CA)?"
echo "Y: Yes (use truststore-intermediate-CA.p12)"
echo "N: No (use truststore-root.p12)"
echo "(if unsure, choose N)"
read transferoption
        case $transferoption in
                [Yy]* )
                        TRUSTSTORE="truststore-intermediate-CA.p12"
                        break
                ;;
                [Nn]* )
                        TRUSTSTORE="truststore-root.p12"
                        break
                ;;
                * ) echo "You must select a valid option to continue";;
        esac
done


#Find docker container and copy the files over
CONTAINER_NAME=$(sudo docker container ls | awk 'NR==2{print substr($2,1,length($2))}')

if [ $CONTAINER_NAME != "tak-server-tak" ]; then 
    echo "UNABLE TO FIND TAK DOCKER CONTAINER!"
    exit
else 
    CONTAINER_ID=$(sudo docker container ls | awk 'NR==2{print substr($1,1,length($2))}')
fi

sudo mkdir ~/tak-server/certs
sudo docker cp $CONTAINER_ID:/opt/tak/certs/files/$TRUSTSTORE ~/tak-server/certs
sudo docker cp $CONTAINER_ID:/opt/tak/certs/files/tc-*.p12 ~/tak-server/certs
sudo chmod 777 ~/tak-server/certs/*

 echo "******************************************************************************"
 echo "******************************************************************************"
 echo ""
 echo "All certs have been moved to ~/tak-server/certs/ you can now download them from there"
 echo ""
 echo "******************************************************************************"
 echo "******************************************************************************"
