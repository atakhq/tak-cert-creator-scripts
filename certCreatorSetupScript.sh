#!/bin/bash

echo ""
echo "*** YOU MUST RUN THIS FROM INSIDE YOUR TAK DOCKER CONTAINER!!!! ***"
echo ""
echo "This script will walk you through the creation of user certificates, including ITAK compatible datapacks."
read -p "Press any key to being setup..."

cd /opt/tak/certs/
mkdir /opt/tak/certs/files/clients

echo "What is the IP to your TAK Server?"
read  PUB_SERVER_IP

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

#What port does server use?
echo "What port does your TAK server use for COT Streaming?"
echo "(Leave blank and hit enter to use default 8089)"
read TAK_COT_PORT
if [ -z "${TAK_COT_PORT}" ]; then 
    TAK_COT_PORT='8089'
else 
    TAK_COT_PORT=${TAK_COT_PORT}
fi

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
    
    #Make a folder per user
    mkdir /opt/tak/certs/files/clients/$CLIENT_NAME

    #Copy over client certs
    cp /opt/tak/certs/files/tc-$CLIENT_NAME.p12 /opt/tak/certs/files/clients/$CLIENT_NAME
    #Iphone files setup
    cp /opt/tak/certs/files/clients/$CLIENT_NAME/tc-$CLIENT_NAME.p12 /opt/tak/certs/files/clients/$CLIENT_NAME/iphone.p12
    cp /opt/tak/certs/files/$TRUSTSTORE /opt/tak/certs/files/clients/$CLIENT_NAME
    mv /opt/tak/certs/files/clients/$CLIENT_NAME/$TRUSTSTORE /opt/tak/certs/files/clients/$CLIENT_NAME/server.p12

 tee /opt/tak/certs/files/clients/$CLIENT_NAME/manifest.xml >/dev/null << EOF
    <MissionPackageManifest version="2">
    <Configuration>
    <Parameter name="uid" value="bcfaa4a5-2224-4095-bbe3-fdaa22a82741"/>
    <Parameter name="name" value="testbox_DP"/>
    <Parameter name="onReceiveDelete" value="true"/>
    </Configuration>
    <Contents>
    <Content ignore="false" zipEntry="certs\taky-server.pref"/>
    <Content ignore="false" zipEntry="certs\server.p12"/>
    <Content ignore="false" zipEntry="certs\iphone.p12"/>
    </Contents>
    </MissionPackageManifest>
EOF


tee /opt/tak/certs/files/clients/$CLIENT_NAME/taky-server.pref >/dev/null << EOF
<?xml version='1.0' encoding='ASCII' standalone='yes'?>
<preferences>
  <preference version="1" name="cot_streams">
    <entry key="count" class="class java.lang.Integer">1</entry>
    <entry key="description0" class="class java.lang.String">ATAKHQ</entry>
    <entry key="enabled0" class="class java.lang.Boolean">true</entry>
    <entry key="connectString0" class="class java.lang.String">$PUB_SERVER_IP:$TAK_COT_PORT:ssl</entry>
  </preference>
  <preference version="1" name="com.atakmap.app_preferences">
    <entry key="displayServerConnectionWidget" class="class java.lang.Boolean">true</entry>
    <entry key="caLocation" class="class java.lang.String">cert/server.p12</entry>
    <entry key="caPassword" class="class java.lang.String">atakatak</entry>
    <entry key="clientPassword" class="class java.lang.String">atakatak</entry>
    <entry key="certificateLocation" class="class java.lang.String">cert/iphone.p12</entry>
  </preference>
</preferences>
EOF

cd /opt/tak/certs/files/clients/$CLIENT_NAME/
zip itak.zip iphone.p12 server.p12 manifest.xml taky-server.pref

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
