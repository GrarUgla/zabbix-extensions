#!/bin/bash
pools_all=`dhcpd-pools -c /etc/dhcp/dhcpd_subnet.conf -l /var/lib/dhcp/dhcpd.leases -AL02|awk '{print $1}'`

# pools_all=`dhcpd-pools -c /etc/dhcp3/dhcpd.conf -l /var/lib/dhcp3/dhcpd.leases -L02|egrep -io "^[a-z]*(\-|\_)?[a-z]*"`  

pools_qtd=`echo $pools_all|wc -w`
retorno=`echo -e "{\n\t\t"\"data\"":["`
for p in $pools_all
do
 if [ "$pools_qtd" -le "1" ]
 then
 retorno=$retorno`echo -e "\n\t\t{\"{#DHCPPOOL}\":\"$p\"}"`
 else
 retorno=$retorno`echo -e "\n\t\t{\"{#DHCPPOOL}\":\"$p\"},"`
 fi
 pools_qtd=$(($pools_qtd - 1))
done
retorno=$retorno`echo -e "]}"`
echo -e $retorno