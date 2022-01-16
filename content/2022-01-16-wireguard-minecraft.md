+++
title = "Today I Did: Minecraft behind a point to point wireguard VPN"
date = 2022-01-15

slug = "minecraft-wireguard"
[taxonomies]
categories = ["Today I Did", "Technical", "All"]
tags = ["wireguard", "Networking", "Minecraft"]
+++

Today I set up a point to point wireguard VPN and forwarded minecraft traffic via it.

<!-- more -->

# Background

I live in a student home with about 100 people. Some of us tested positive for the omnicron variant of COVID-19 so we all had to be quarantined.  
One of our people who is responsible for board games and such wanted to set up minecraft server we could all play on during our 10 day quarantene. Unfortunately our servers can't handle running a minecraft server, so it'd have to run on his computer. This posed multiple challenges.

# Network

Our network is pretty bad (though I'm working on this). Every room is behind their own routers and NATs behind another NAT. It would probably be enough for him to port forward from his NAT so that all the other people could reach it locally, but the routers adress is on DHCP and we wanted the ability to connect from the internet.  
We have a server locally which seems to be DMZed or otherwise have a global ip.  
To break through the NATs I set up a two node wireguard network. The server listened, and his computer would connect to it, opening up a tunnel from the server to his desktop via the virtual network card `wg0`. The servers ip in this virtual network was `192.168.42.1` and his desktop was `192.168.42.2`

To route the traffic properly however we needed to use some iptables rules:

```bash
iptables -t nat -A PREROUTING -p tcp --dport 25565 -j DNAT --to-destination 192.168.42.2
iptables -t nat -A POSTROUTING -o wg0 -p tcp --dport 25565 -d 192.168.42.2 -j SNAT --to-source 192.168.42.1

iptables -t nat -A PREROUTING -p udp --dport 25565 -j DNAT --to-destination 192.168.42.2
iptables -t nat -A POSTROUTING -o wg0 -p udp --dport 25565 -d 192.168.42.2 -j SNAT --to-source 192.168.42.1
```

These rules mean that before routing takes place all tcp and udp packets which are going to the standard minecraft port `25565` will be changed so that their destination instead points to the desktop computer actually hosting the minecraft server.  
After routing, the source adress pm the packet gets set to the server's ip adress so that when the minecraft server replies with information. It knows how to route the information back. This has the downside of making you "lose" the player's IP adress, since the minecraft server will think all network traffic comes from the relaying server.  
To avoid this you would probably need some other tool to do the relaying. Like for example waterfall or some other dedicated minecraft proxy.

We also need allow these packets through the firewall, since its probable your default iptables setup blocks forwarding like this.

```
iptables -A FORWARD -i enp0s3 -o wg0 --dst 192.168.42.2 -p tcp --dport 25565 -j ACCEPT
iptables -A FORWARD -i enp0s3 -o wg0 --dst 192.168.42.2 -p udp --dport 25565 -j ACCEPT
```

# Wrap up

These rules need to be saved somehow, but I'll leave that as an exercise for the reader. Maybe you should add them to the pre execute phase of your wireguard systemd unit? 

Hopefully this works for you. I'm not an expert in networking or iptables. But if you have any issues feel free to ask in the comments, can't guarantee an answer though!
