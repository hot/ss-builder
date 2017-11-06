#!/bin/bash
echo "开始安装shadowsocks"
sleep 2

mkdir -p /tmp/ss
cd /tmp/ss

sudo apt-get update
sudo apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev gawk debhelper dh-systemd init-system-helpers pkg-config xmlto apg zlib1g-dev libudns-dev libsodium-dev -y
sudo apt-get install --no-install-recommends gettext libpcre3-dev asciidoc libev-dev libc-ares-dev automake libmbedtls-dev -y
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init

echo "开始编译"
sleep 2

./autogen.sh && ./configure && make
sudo make install

echo "开始创建配置"
sleep 2

PORT=$(( ( RANDOM % 50000 )  + 8000 ))
PASS=`openssl rand -base64 32`


#echo "按任意键运行shadowsocks"
#read -s -n 1 key  

#开启BBR加速
sysctl net.core.default_qdisc=fq
sysctl net.ipv4.tcp_congestion_control=bbr

ss-server -s 0.0.0.0 -p $PORT -k $PASS -m aes-256-cfb --fast-open &

RED='\033[0;31m'
NC='\033[0m' # No Color

printf "${RED}>>>>>>请记下下面的配置<<<<<<<${NC}\n"
printf "端口(port):${RED}${PORT}${NC}\n"
printf "密码(password):${RED}${PASS}${NC}\n"
printf "加密方法(cipher):${RED}aes-256-cfb${NC}\n"
printf "${RED}>>>>>>请记下上面的配置置<<<<<<<${NC}\n"
echo "shadowsocks安装完成，用客户端链接一下试试吧：）"

