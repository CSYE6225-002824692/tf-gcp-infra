#!/bin/bash

cd /home/csye6225 
sudo mkdir /home/csye6225/webapp/

DB_HOST=$(curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/db-host)
DB_USER=$(curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/db-user)
DB_PASS=$(curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/db-password)
DataBase_NAME=$(curl -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/db-name)

cat <<EOF > /home/csye6225/webapp/env
DB_NAME=${DataBase_NAME}
DB_USERNAME=${DB_USER}
DB_PASSWORD=${DB_PASS}
DB_IP=${DB_HOST}
EOF
