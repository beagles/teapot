#/bin/bash
qrouter_ns_list=`sudo ip netns | grep "^qrouter"`
neutron router-list -f csv -c id -c name | sed -e 's/\"//g' -e 's/,/ /g' | tr -d '\r' | while read id_fld name_fld rest;
do
    if test "$id_fld" == "id";
    then
	continue
    fi

    new_ns_list=`echo $qrouter_ns_list | sed -e "s/qrouter-$id_fld//"`
    qrouter_ns_list=new_ns_list
done

if [ -n "$qrouter_ns_list" ];
then
    echo "There are router namespaces to clean up:"
    for ns in $qrouter_ns_list;
    do
	echo "\t$ns"
	sudo ip netns delete $ns
    done
fi

dhcp_ns_list=`sudo ip netns | grep "^qdhcp"`
neutron net-list -f csv -c id | sed -e 's/\"//g' -e 's/,/ /g' | tr -d '\r' | while read id_fld rest;
do
    if test "$id_fld" == "id";
    then
	continue
    fi
    
    new_ns_list=`echo $dhcp_ns_list | sed -e "s/qdhcp-$id_fld//"`
    dhcp_ns_list=new_ns_list
done

if [ -n "$dhcp_ns_list" ];
then
    echo "There are dhcp namespaces to clean up:"
    for ns in $dhcp_ns_list;
    do
	echo "\t$ns"
	sudo ip netns delete $ns
    done
fi