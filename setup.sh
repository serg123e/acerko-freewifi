#!/bin/bash

# pscp -l admin -pw acerko ./portal 192.168.88.96:/flash/portal
source router.env

echo "copying html"
pscp -l $routerAdminUser -pw $routerAdminPassword -scp -r ./portal/ $routerIpAddress:/flash/portal


echo "copying config script"
pscp -l $routerAdminUser -pw $routerAdminPassword -scp hotspot.rsc $routerIpAddress:/

#echo "configuring hotspot"
plink -pw $routerAdminPassword $routerAdminUser@$routerIpAddress "/import verbose=yes hotspot.rsc" 


#echo "configuring hotspot"
# plink -batch -pw $routerAdminPassword -m hotspot.rsc $routerAdminUser@$routerIpAddress 

echo "Done, playing music"
plink -batch -pw $routerAdminPassword -m nokia.rsc $routerAdminUser@$routerIpAddress 