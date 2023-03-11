#!/bin/bash

while true
do

# Logo

echo -e '\e[40m\e[91m'
echo -e '  ____                  _                    '
echo -e ' / ___|_ __ _   _ _ __ | |_ ___  _ __        '
echo -e '| |   |  __| | | |  _ \| __/ _ \|  _ \       '
echo -e '| |___| |  | |_| | |_) | || (_) | | | |      '
echo -e ' \____|_|   \__  |  __/ \__\___/|_| |_|      '
echo -e '            |___/|_|                         '
echo -e '    _                 _                      '
echo -e '   / \   ___ __ _  __| | ___ _ __ ___  _   _ '
echo -e '  / _ \ / __/ _  |/ _  |/ _ \  _   _ \| | | |'
echo -e ' / ___ \ (_| (_| | (_| |  __/ | | | | | |_| |'
echo -e '/_/   \_\___\__ _|\__ _|\___|_| |_| |_|\__  |'
echo -e '                                       |___/ '
echo -e '\e[0m'

sleep 2

# Menu

PS3='Select an action: '
options=(
"Install"
"Exit")
select opt in "${options[@]}"
do
case $opt in

"Install")
echo "============================================================"
echo "Install start"
echo "============================================================"

# set vars
if [ ! $ADDRESS ]; then
	read -p "Enter IP address: " ADDRESS
	echo 'export ADDRESS='$ADDRESS >> $HOME/.bash_profile
fi
source $HOME/.bash_profile

# update
sudo apt update && sudo apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y

# download binary
wget https://lamina1.github.io/lamina1/lamina1.latest.ubuntu-latest.tar.gz
tar -xvzf lamina1.latest.ubuntu-latest.tar.gz
curl https://lamina1.github.io/lamina1/config.testnet4.tar | tar xf -
cd lamina1

sed -i -e "s/public-ip-resolution-service/public-ip/g" $HOME/configs/testnet4/default.json
sed -i -e "s/opendns/$ADDRESS/g" $HOME/configs/testnet4/default.json

#service
sudo tee /etc/systemd/system/lamina1.service > /dev/null <<EOF
[Unit]
Description=lamina1
After=network-online.target
[Service]
User=root
WorkingDirectory=/root/lamina1
ExecStart=/root/lamina1/lamina1-node  --config-file /root/configs/testnet4/default.json
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

echo "deb [trusted=yes arch=amd64] https://lamina1.s3.eu-west-3.amazonaws.com/ubuntu jammy main"  > /etc/apt/sources.list.d/lamina1.list
apt-get -qqy update 
apt-get -qqy install lamina1-node

# start service
systemctl daemon-reload
systemctl enable lamina1
systemctl restart lamina1

break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
