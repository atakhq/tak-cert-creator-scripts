#!/bin/bash

echo "YOU MUST RUN THIS FROM INSIDE YOUR TAK DOCKER CONTAINER!!!!"
read -p "Press any key to being setup..."

cd opt/tak/certs/

#Make the Client Keys
echo "How many clients do you want to configure?"
read CLIENT_COUNT
CLIENT_ARR=()
for ((i=1; i<=$CLIENT_COUNT;i++))

do
    CLIENT_ARR+=($CLIENT_NAME)
    echo "What is the username for client #$i?"
    read CLIENT_NAME
    
    echo "Creating certs for $CLIENT_NAME"
    ./makeCert.sh client $CLIENT_NAME

 done 
 
 echo "******************************************************************************"
 echo "******************************************************************************"
 echo "All certs have been created, please exit docker shell and run the final script"
 echo ""
 echo "exit"
 echo ""
 echo "cd /tmp/tak-cert-enrollment-script/ && . certCreatorPostSetupScript.sh"
 echo ""
 echo "******************************************************************************"
 echo "******************************************************************************"
