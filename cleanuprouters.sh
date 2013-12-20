#/bin/bash
neutron router-list -f csv | while read;
do
    router_name=`echo $REPLY | cut -f 2 -d ',' | sed -e 's/\"//g'`
    if test "$router_name" == "name";
    then
	continue
    fi
    if test "$router_name" == "router1";
    then
	continue
    fi
    router_id=`echo $REPLY | cut -f 1 -d ',' | sed -e 's/\"//g'`
    
    if [ -n "$router_id" ];
    then
	neutron router-port-list -f csv -c id -c fixed_ips "$router_id" | sed -e 's/\"//g' \
-e 's/,/ /g' -e 's/{\|}//g' | while read id_fld lbl1 subnet_fld remainder ; do
	    if test "$id_fld" == "id";
	    then
		continue
	    fi
	    [ -n "$id_fld" ] && [ -n "$subnet_fld" ] && neutron router-interface-delete $router_id $subnet_fld
	done
	echo "Cleaning up left over router : $router_name"
	neutron router-delete "$router_id"
    fi
done
