#/bin/bash
grouplist="smoke gate negative network compute orchestration slow image"

for g in $grouplist;
do
    testr list-tests tempest | grep "^tempest"|  grep "\[.*$g.*\]" | sed -e 's/\[.*$//' > $g.tests.txt
done

testr list-tests tempest | grep "^tempest" |  sed -e 's/\[.*$//' > full.tests.txt
testr list-tests tempest | grep "^tempest" | grep -v "\[[A-Za-z,]*\]$" > unlabelled.tests.txt