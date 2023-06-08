# jun/07/2023 23:47:16 by RouterOS 7.9.2
#
# model = RB952Ui-5ac2nD

:if ([/interface bridge find name=bridge-portal] = "") do={
    /interface bridge add name=bridge-portal
}

/interface/bridge/port/set [ find interface=wlan1 ] bridge=bridge-portal
/interface/bridge/port/set [ find interface=wlan2 ] bridge=bridge-portal

/interface/wireless/set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=20/40mhz-Ce country=spain disabled=no distance=indoors frequency=auto mode=ap-bridge ssid=Acerko-FreeWifi station-roaming=enabled wireless-protocol=802.11
/interface/wireless/set [ find default-name=wlan2 ] band=5ghz-a/n/ac channel-width=20/40/80mhz-Ceee country=spain disabled=no distance=indoors frequency=auto mode=ap-bridge ssid=Acerko-FreeWifi station-roaming=enabled wireless-protocol=802.11
/interface wireless security-profiles set [ find default=yes ] mode=none supplicant-identity=MikroTik-FreeWifi

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

:if ([/ip hotspot user find name=guest] = "") do={
    /ip hotspot user add name=guest
}

:if ([/ip hotspot walled-garden ip find dst-address=139.144.176.154] = "") do={
    /ip hotspot walled-garden ip add action=accept disabled=no dst-address=139.144.176.154
}
