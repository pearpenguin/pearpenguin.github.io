# Script to setup an Wireguard proxy as a VPN gateway

## On the server
* To setup Wireguard server: `sudo ./setup-ubuntu.sh server`
    * The server WG interface is hardcoded to `192.168.2.1`
* To add a peer (with new keys): `sudo ./setup-ubuntu.sh peer <public_host> <peer_ip>`, where
    * `public_host` is the publicly accessible hostname or IP address of the server
    * `peer_ip` is the unique IP address of the peer (within CIDR block `192.168.2.0/24`). It can start from `192.168.2.2`

## On each client
### Linux
1. `sudo apt-get install wireguard`
1. Copy `peer.conf` from server to the client folder `/etc/wireguard`
1. To start the VPN client: `sudo wg-quick up peer`
### Mobile
Scan the QR code generated when adding the peer on the server with the appropriate wireguard app