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
sudo apt update && sudo apt upgrade -y && \
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop screen unzip bc fail2ban htop -y

# download binary
cd $HOME
wget https://lamina1.github.io/lamina1/lamina1.latest.ubuntu-latest.tar.gz
tar -xvzf lamina1.latest.ubuntu-latest.tar.gz
curl https://lamina1.github.io/lamina1/config.testnet.tar | tar xf -
    ./lamina1-node  --config-file configs/testnet/default.json
    
#service
sudo tee /etc/systemd/system/lamina1.service > /dev/null <<EOF
[Unit]
Description=lamina1
After=network-online.target
[Service]
User=root
WorkingDirectory=/root/lamina1
ExecStart=/root/lamina1/lamina1-node  --config-file /root/lamina1/configs/testnet/default.json
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sed -i -e "s/^"public-ip" *=.*/"public-ip" = \"$ADDRESS\"/" $HOME/lamina1/configs/testnet/default.json

# start service
sudo systemctl daemon-reload
sudo systemctl start lamina1

break
;;

"Exit")
exit
;;
*) echo "invalid option $REPLY";;
esac
done
done
