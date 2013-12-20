#/bin/bash
nova list --all-tenants --minimal | sed -e '/^\+/d' -e '/ID.*Name/d' | sed -e 's/|//g' | \
while read uuid_fld name_fld rest;
do
    echo "Cleanup up leftover instance : $name_fld"
    nova delete $uuid_fld
done
