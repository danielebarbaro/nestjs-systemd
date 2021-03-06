#!/bin/bash
if [[ $EUID -ne 0 ]]; then
    echo -e "❌ You must be root to do this."
    exit 1
fi

read -p "Enter a valid node user (deployer): " user
if [[ -z "${user}" ]]; then
    echo -e "❌ Error: Insert a valid user. ❌"
    exit 1
fi
if [[ $(getent passwd ${user}) ]]; then
    echo -e "🎉 ${user} exist"
else
    echo -e "❌ Error: ${user} not found. ❌"
    exit 1
fi

read -p "Enter a valid user group (deployer): " group
if [[ -z "${group}" ]]; then
    echo -e "❌ Error: Insert a valid group. ❌"
    exit 1
fi
if [[ $(getent group ${group}) ]]; then
    echo -e "🎉 ${group} exist"
else
    echo -e "❌ Error: ${group} not found. ❌"
    exit 1
fi

read -p "Enter a valid node root folder (/var/www/node): " folder
if [[ -z "${folder}" ]]; then
    echo -e "❌ Error: Insert a valid folder. ❌"
    exit 1
fi
clean_folder=$(realpath -s ${folder})

if [[ -d "${clean_folder}" ]]; then
    echo -e "🎉 ${clean_folder} exist"
else
    echo -e "❌ Error: ${clean_folder} not found. ❌"
    exit 1
fi

touch /etc/sudoers.d/${user}

if [[ ${user} != "" ]]; then
    sed -e "s#DEPLOYER_USER#$user#g" "templates/etc/sudoers.d/DEPLOYER_USER" >"/etc/sudoers.d/$user"
fi

if [[ ${user} != "" && ${clean_folder} != "" && ${group} != "" ]]; then
    sed -e "s#DEPLOYER_USER#$user#g; ; s#DEPLOYER_GROUP#$group#g; s#ROOT_FOLDER#$clean_folder#g" "templates/etc/systemd/system/nodeserver.service" >"/etc/systemd/system/nodeserver.service"
fi

chmod 440 /etc/sudoers.d/${user}
chmod 644 /etc/systemd/system/nodeserver.service

systemctl enable nodeserver.service
systemctl start nodeserver.service
