#/bin/bash

touch failing.tests.txt
testgroup=$1
breakonexit=$2

[ -z "$testgroup" ] && echo "specify test group" && exit

if [ -e "$testgroup.tests.txt" ];
then
    msg=`date`
    echo "====================================================================" >> $testgroup.results.txt
    echo "New run $msg" >> $testgroup.results.txt
    bash -x teapotcleanups.sh >> $testgroup.results.txt
    cat "$testgroup.tests.txt" | while read testname rest;
    do
	testr run $testname | tee -a $testgroup.results.txt | tee $testname.result.txt
	grep -q FAIL $testname.result.txt
	if test $? -eq 1;
	then
	    grep -q "$testname" failing.tests.txt
	    [ $? -eq 1 ] && echo "$testname" >> failing.tests.txt
	    bash -x teapotcleanups.sh | tee -a $testname.result.txt
	    [ -n "$breakonexit" ] && [ "$breakonexit" == "yes" ] && exit
	else
	    bash -x teapotcleanups.sh | tee -a $testname.result.txt
	fi
    done
else
    echo "No file for group $testgroup"
fi