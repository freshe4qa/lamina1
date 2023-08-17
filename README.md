<p align="center">
  <img height="100" height="auto" src="https://github.com/freshe4qa/lamina1/assets/85982863/d144c3fc-068a-46ad-8e16-4f740e2c7ad6">
</p>

# Lamima1 Betanet

Official documentation:
>- [Validator setup instructions](https://docs.lamina1.com/docs/Running-a-Betanet-Node)

Explorer:
>- [https://explorer.test.taiko.xyz](https://testnet-explorer.lamina1.global)

Ubuntu 22.04
### Minimum Hardware Requirements
 - 4 CPUs;
 - 8GB RAM
 - 100GB (SSD or NVME)

## Установка
```
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y    
```

```
screen -S lamina1
```

```
echo "deb [trusted=yes arch=amd64] https://snapshotter.lamina1.global/ubuntu jammy main" > /etc/apt/sources.list.d/lamina1.list && 
apt update && apt install lamina1-betanet
```
Выйти из screen
```
CTRL + A + D
```
Зайти в сессию
```
screen -r lamina1
```
Проверить статус ноды
```
sudo systemctl status lamina1-node.betanet
```
Посмотреть синхронизацию
```
lamina1.check-bootstrap.sh
```

Получить Node-ID 
```
lamina1.get_my_nodeid.sh
```

Чтобы стать валидатором в сети нужно заполнить форму
```
https://blocksurvey.io/betanet-validator-sign-up-form-Cjw7TfwYQN6Z7yOot4Zdjg-o
```
