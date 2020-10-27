#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/danielebarbaro/node-systemd/main/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/danielebarbaro/node-systemd/main/install.sh)"

for filename in "etc/sudoers.d/deployer" "etc/systemd/system/nodeserver.service"
do
read -p "Enter node user: " user
read -p "Enter node root: " folder

if [[ $user != "" && $replace != "" ]]; then
    sed -i "s/DEPLOYER_USER/$user/g" $filename
    sed -i "s/ROOT_FOLDER/$folder/g" $filename
fi

done
