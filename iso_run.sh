#/bin/bash

touch failing.tests.txt
touch passing.tests.txt
testgroup=$1
breakonfail=$2

[ -z "$testgroup" ] && echo "specify test group" && exit

if [ -e "$testgroup.tests.txt" ];
then
    msg=`date`
    echo "====================================================================" >> $testgroup.results.txt
    echo "New run $msg" >> $testgroup.results.txt
    bash -x teapotcleanups.sh >> $testgroup.results.txt
    cat "$testgroup.tests.txt" | while read testname rest;
    do
	ts=`date`
	testr run $testname | tee -a $testgroup.results.txt | tee $testname.result.txt
	grep -q FAIL $testname.result.txt
	if test $? -eq 0;
	then
	    sed -i.bak -e "/$testname/d" failing.tests.txt
	    sed -i.bak -e "/$testname/d" passing.tests.txt
	    echo "$testname $ts" >> failing.tests.txt
	    bash -x teapotcleanups.sh | tee -a $testname.result.txt
	    [ -n "$breakonfail" ] && [ "$breakonfail" == "yes" ] && exit
	else
	    # don't delete the failing entry.. I want to keep track
	    # of if it ever has failed.
	    sed -i.bak -e "/$testname/d" passing.tests.txt
	    echo "$testname $ts" >> passing.tests.txt
	    bash -x teapotcleanups.sh | tee -a $testname.result.txt
	fi
    done
else
    echo "No file for group $testgroup"
fi