#!/bin/bash

echo ""
echo "*** YOU MUST RUN THIS FROM INSIDE YOUR TAK DOCKER CONTAINER!!!! ***"
echo ""
echo "This script will walk you through the creation of user certificates, including ITAK compatible datapacks."
read -p "Press any key to being setup..."

cd /opt/tak/certs/

#Make the Client Keys
echo "How many clients do you want to configure?"
read CLIENT_COUNT
CLIENT_ARR=()
for ((i=1; i<=$CLIENT_COUNT;i++))

do
    CLIENT_ARR+=($CLIENT_NAME)
    echo ""
    echo "************************************"
    echo "What is the username for client #$i?"
    echo "************************************"
    echo ""
    read CLIENT_NAME
    
    echo "Creating certs for $CLIENT_NAME"
    ./makeCert.sh client tc-$CLIENT_NAME

 done 
 
 echo "******************************************************************************"
 echo "******************************************************************************"
 echo "All certs have been created, please exit docker shell and run the final script"
 echo ""
 echo "exit"
 echo ""
 echo "cd /tmp/tak-cert-creator-scripts/ && . certCreatorPostSetupScript.sh"
 echo ""
 echo "******************************************************************************"
 echo "******************************************************************************"
