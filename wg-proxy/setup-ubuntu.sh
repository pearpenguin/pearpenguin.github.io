#!/bin/bash

# Setup wireguard server from scratch
setup_server () {
    apt-get update
    apt-get -y install wireguard wireguard-tools iptables

    # Foward all traffic to internet
    echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    sysctl -p

    cd /etc/wireguard

    # Generate server keys
    wg genkey | tee server-private.key | wg pubkey > server-public.key
    chmod 600 private.key

    PRIVATE_KEY=`cat server-private.key`

    cat << EOF > wg0.conf
[Interface]
## Local Address : A private IP address for wg0 interface.
Address = 192.168.2.1/24
ListenPort = 33333

## local server privatekey
PrivateKey = $PRIVATE_KEY

## The PostUp will run when the WireGuard Server starts the virtual VPN tunnel.
## The PostDown rules run when the WireGuard Server stops the virtual VPN tunnel.
## Specify the command that allows traffic to leave the server and give the VPN clients access to the Internet.
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp = iptables -t nat -A POSTROUTING -o enX0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT
PostDown = iptables -t nat -D POSTROUTING -o enX0 -j MASQUERADE
EOF

# init wireguard interface
systemctl start wg-quick@wg0
}

# Setup a new peer from scratch (creates keys)
add_peer () {
    # Need to input the public IP
    PUBLIC_HOST=$1
    PEER_IP=$2
    DNS_IP=`resolvectl dns enX0`

    # For generating QR code for mobile WG clients
    apt-get -y install qrencode

    cd /etc/wireguard
    # Generate peer keys and add peer to server conf
    wg genkey | tee peer-private.key | wg pubkey > peer-public.key
    chmod 600 peer-private.key

    PEER_PRIVATE_KEY=`cat peer-private.key`
    PEER_PUBLIC_KEY=`cat peer-public.key`
    SERVER_PUBLIC_KEY=`cat server-public.key`

    cat << EOF >> wg0.conf

[Peer]
PublicKey = $PEER_PUBLIC_KEY
AllowedIPs = $PEER_IP/32
EOF

    # Generate wireguard conf for peer machine
    cat << EOF > peer.conf
[Interface]
PrivateKey = $PEER_PRIVATE_KEY
Address = $PEER_IP/24
ListenPort = 33333

# Resolve DNS via wg server to avoid DNS leak
DNS = $DNS_IP

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
AllowedIPs = 0.0.0.0/0
Endpoint = $PUBLIC_HOST:33333
EOF

    # Reload WG to add the peer
    systemctl reload wg-quick@wg0.service

    # File for desktop client, QR code for mobile client
    echo "Peer WG config: peer.conf"
    qrencode -t ansiutf8 -r "peer.conf"
}

if [ "$1" == "server" ]; then
setup_server
elif [ "$1" == "peer" ]; then
add_peer $2 $3
else
echo "Usage:"
echo "setup-ubuntu.sh server"
echo "setup-ubuntu.sh peer <public_host> <peer_ip> <dns_ip>"
fi
