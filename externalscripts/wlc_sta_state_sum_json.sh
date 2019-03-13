#!/bin/bash
# external script for Template "Cisco WLC Discovery v2"
# analogue of the command "sh client state summary" in the WLC 
# Zabbix key: wlc_sta_state_sum_json.sh[{HOST.CONN},{$SNMP_COMMUNITY},{$SNMP_PORT}]

# echo $(/usr/bin/snmpwalk -Ov -Oq -v2c -c $2 $1 .1.3.6.1.4.1.14179.2.1.4.1.23 | sort | uniq -c)

# get snmp table bsnMobileStationPolicyManagerState
sta_table=`echo $(/usr/bin/snmpwalk -Ov -Oq -v2c -c $2 $1:$3 .1.3.6.1.4.1.14179.2.1.4.1.23)`

# count the number of rows with different states
run_num=`echo $sta_table | grep -o RUN | wc -l`
dhcp_reqd_num=`echo $sta_table | grep -o DHCP_REQD | wc -l`
start_num=`echo $sta_table | grep -o START | wc -l`
dot1x_reqd_num=`echo $sta_table | grep -o 8021X_REQD | wc -l`
sum_num=`echo $(($start_num + $dhcp_reqd_num + $dot1x_reqd_num + $run_num))`

# forming JSON
output=`echo -e "{\n"\"sta_state\"":{"`
output=$output`echo -e "\n\t\t\"start\":\"$start_num\","`
output=$output`echo -e "\n\t\t\"dot1x_reqd\":\"$dot1x_reqd_num\","`
output=$output`echo -e "\n\t\t\"dhcp_reqd\":\"$dhcp_reqd_num\","`
output=$output`echo -e "\n\t\t\"run\":\"$run_num\","`
output=$output`echo -e "\n\t\t\"sum\":\"$sum_num\""`
output=$output`echo -e "}}"`

echo -e $output
