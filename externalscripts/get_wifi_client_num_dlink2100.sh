#!/bin/bash
# получение суммарного числа клиентов WiFi на ТД D-Link, у которых нет отдельного OID для этого.
# Через подсчет количества строк в таблице:
# adClientTable
# OID	 .1.3.6.1.4.1.171.11.37.4.4.5.2
# MIB	 AP-Config
# если клиентов нет, то таблица не существует, и используется проверка на 
# сообщения "No Such Object available" или "No Such Instance currently exists at this OID"


sta_table=`echo $(/usr/bin/snmpwalk -Ov -v2c -Cp -c $2 $1 .1.3.6.1.4.1.171.11.37.4.4.5.2.1.2.1)`
error_msg="No Such"


if [[ $sta_table == *"$error_msg"* ]]
 then
    echo 0
else
    echo $sta_table | awk 'END {print $NF}'
fi
