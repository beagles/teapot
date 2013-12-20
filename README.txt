tempest in a teapot scripts
===========================

WARNING: running any of these tools might overwrite something or remove
something you didn't want "gone". Read this before monkeying around. Most
notably if you have VMs in your devstack environment or networks other than
the two "default" devstack ones, running these scripts will obliterate
them. You've been warned.

The teapot scripts are meant to simplify running a series of tempest tests
for the purpose of debugging the tests and/or cleanup issues with the code
and/or the tests themselves. It is *not* a replacement for running the
tests in the normal tempest fashion.

The general concept is to make sure that each test has a relatively clean
environment before running. Remnant VMs, networks and routers as well as
network namespaces are among the things that are cleaned up after each
test. If cleanup scripts print the cleanups they are performing to stdout
and it is appended to the tempest output for the relevant test aiding in
locating which tests are not cleaning up properly and potentially
interfering with other tests.

Test "groups"
============

These are somewhat analagous to the value passed to "tox -e[ ]". A group
name is essentially a label that is related to a file containing a list of
tests to be run. For example, for the group "smoke", test names in the file
"smoke.tests.txt" in the current directory are run and the output is
recorded to "smoke.results.txt". The test output for each individual is
logged to a file named the same as the test itself with a .result.txt
suffix. The idea being quick access to the relevant results.

Creating the groups based on tempest test lists is easy. Just run the
"gengroups.sh" script in /opt/stack/tempest (or wherever you have tempest)
and it will create group files for several standard sets of tests
(e.g. smoke, gate, compute). If desired, you can copy one of these files
and add or remove tests in your favorite editor for custom groups.

Special groups - failing and passing

There are two special files that are created whenever you run iso_run.sh:
failing.tests.txt and passing.tests.txt. These can be run like test groups
themselves. e.g.

	    iso_run.sh failing

NOTE: iso_run.sh does not ever remove a failed test from the
failing.tests.txt file. Once it has passed, you will have to remove it
manually if you do not want to run it as part of the failed tests. A failed
test always gets removed from passing.tests.txt

The iso_run.sh script
=====================

iso_run.sh is a very UN-sophisticated shell script that simply reads a
file, calls other scripts to cleanup and captures results. It takes two
positional arguments of which the second is optional.

iso_run.sh [group] [break on failure]

group - is the name of the test group you want to run (see above for more
info)
break on failure - if you specify "yes" as the second argument, iso_run.sh
will stop executing tests on the first failed test. Handy if you are
picking through a set of tests one a time.

The output:

failing.tests.txt - a text file recording the last time a test has failed.

passing.tests.txt - a text file recording the last time a test has passed.

[group].results.txt - a mondo file containing all of the output of the
tests that have been run. It doesn't include cleanup info at this time.

[testname].result.txt - a test specific file that captures the tempest
output as it would appear on the screen if you were to run 'testr run
[testname]'. If the test did not clean up after itself, the cleanup scripts
will append what stuff had to be cleaned up.


The cleanup scripts
===================

A collection of really naively written, brain dead scripts that run some
OpenStack commands to try and clean things up when VMs, networks, etc are
left behind. The fact that these scripts are very heavy handed means that

a.) you should not run iso_run.sh in an OpenStack environment where there
are VMs etc that are other than the default devstack things.. they will get
trashed

b.) error handling is minimal

c.) changes in structure and format in client tools may break the scripts.

Heck it's all hacking, so deal with it :)
