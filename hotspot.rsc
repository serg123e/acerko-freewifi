# jun/07/2023 23:47:16 by RouterOS 7.9.2
# software id = 462B-B7UI
#
# model = RB952Ui-5ac2nD
# serial number = 8B0808112BE4
:if ([/interface bridge find name=bridge-portal] = "") do={
    /interface bridge add name=bridge-portal
}

/interface/bridge/port/set [ find interface=wlan1 ] bridge=bridge-portal
/interface/bridge/port/set [ find interface=wlan2 ] bridge=bridge-portal

/interface/wireless/set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-Ce country=spain disabled=no distance=indoors frequency=auto mode=ap-bridge ssid=Acerko-FreeWifi station-roaming=enabled wireless-protocol=802.11
/interface/wireless/set [ find default-name=wlan2 ] band=5ghz-a/n/ac channel-width=20/40/80mhz-Ceee country=spain disabled=no distance=indoors frequency=auto mode=ap-bridge ssid=Acerko-FreeWifi station-roaming=enabled wireless-protocol=802.11
/interface wireless security-profiles set [ find default=yes ] mode=none supplicant-identity=MikroTik-FreeWifi

#set [ find default=yes ] authentication-types=wpa2-psk mode=dynamic-keys \
#    supplicant-identity=MikroTik wpa2-pre-shared-key=12345678900

# /interface pppoe-client
# add add-default-route=yes interface=ether1 name=pppoe-out1 user=vpn


/ip hotspot profile set [ find default=yes ] hotspot-address=10.5.50.1 login-by=http-pap
/ip hotspot user profile set [ find default=yes ] add-mac-cookie=no shared-users=200
:if ([/ip pool find name=hotspot-pool-10] = "") do={
    /ip pool add name=hotspot-pool-10 ranges=10.5.50.2-10.5.50.254
}

:if ([/ip dhcp-server find name=dhcp-portal] = "") do={
    /ip dhcp-server add address-pool=hotspot-pool-10 interface=bridge-portal name=dhcp-portal
}

:if ([/ip hotspot find name=hotspot1] = "") do={
    /ip hotspot add address-pool=hotspot-pool-10 disabled=no interface=bridge-portal name=hotspot1
}

:if ([/ip address find comment="hotspot network"] = "") do={
    /ip address add address=10.5.50.1/24 comment="hotspot network" interface=bridge-portal network=10.5.50.0
}

:if ([/ip dhcp-server network find comment="hotspot network"] = "") do={
    /ip dhcp-server network add address=10.5.50.0/24 comment="hotspot network" gateway=10.5.50.1
}

/ip dns set allow-remote-requests=yes servers=1.1.1.3

#/ip firewall filter
#add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes
#add action=accept chain=input comment="defconf: accept established,related,untracked" connection-state=established,related,untracked
#add action=drop chain=input comment="defconf: drop invalid" connection-state=invalid
#add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
#add action=drop chain=input comment="defconf: drop all not coming from LAN" in-interface-list=!LAN
#add action=accept chain=forward comment="defconf: accept in ipsec policy"  ipsec-policy=in,ipsec
#add action=accept chain=forward comment="defconf: accept out ipsec policy" ipsec-policy=out,ipsec
#add action=fasttrack-connection chain=forward comment="defconf: fasttrack" connection-state=established,related hw-offload=yes
#add action=accept chain=forward comment="defconf: accept established,related, untracked" connection-state=established,related,untracked
#add action=drop chain=forward comment="defconf: drop invalid" connection-state=invalid
#add action=drop chain=forward comment="defconf:  drop all from WAN not DSTNATed" connection-nat-state=!dstnat connection-state=new in-interface-list=WAN
#/ip firewall nat
#add action=passthrough chain=unused-hs-chain comment="place hotspot rules here" disabled=yes

# add action=masquerade chain=srcnat comment="defconf: masquerade" ipsec-policy=out,none out-interface-list=WAN

# add action=masquerade chain=srcnat comment="masquerade hotspot network" src-address=10.5.50.0/24

:if ([/ip hotspot user find name=guest] = "") do={
    /ip hotspot user add name=guest
}

:if ([/ip hotspot walled-garden ip find dst-address=139.144.176.154] = "") do={
    /ip hotspot walled-garden ip add action=accept disabled=no dst-address=139.144.176.154
}
