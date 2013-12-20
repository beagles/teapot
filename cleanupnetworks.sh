#/bin/bash

neutron net-list -f csv -c id -c name | sed -e 's/\"//g' -e 's/\,/ /g' | while read id_fld name_fld rest;
do
    [ -z "$id_fld" ] || [ -z "$name_fld" ] && continue
    if test "$id_fld" == "id";
    then
	continue
    fi
    case "$name_fld" in
	private*|public*)
	    continue
	    ;;
	*)
	    ;;
    esac
    echo "Cleaning up leftover network: $name_fld"
    neutron net-delete $id_fld
done