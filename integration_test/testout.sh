#!/bin/bash
rm output.txt
cat 1> ./integration_test/output-temp.txt
cat ./integration_test/output-temp.txt | tr -d '\000' > ./integration_test/output.txt
if cat ./integration_test/output.txt | grep -q '^Failure Details:'; then
if ! cat ./integration_test/output.txt | grep -q '^The value of ErrorWidget.builder was changed by the test.'; then
echo -e '==========================================================='
echo -e '= ERROR DETAILS                                           ='
echo -e '==========================================================='
cat ./integration_test/output.txt | grep '^Error'
cat ./integration_test/output.txt | grep -A5000 '^Failure Details:'
fi
fi
echo -e '==========================================================='
echo -e '= STEPS                                                   ='
echo -e '==========================================================='
cat ./integration_test/output.txt | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep '\"STARTED\"$'
cat ./integration_test/output.txt | pcregrep -M  '^@\=@\=.*@\+@\+$' | sed -e 's/\(@=@=,\)//g' | sed -e 's/\(,@+@+\)//g'
cat ./integration_test/output.txt | pcregrep -M  '^@\-@\-.*@\|@\|$' | sed -e 's/\(@-@-,\)//g' | sed -e 's/\(,@|@|\)//g' | grep -v '\"STARTED\"$' | tail -1 | grep -v '\"Passed\"$' | sed 's/BEFORE/Failed/g'
echo -e '==========================================================='
echo -e '= ERROR SUMMARY                                           ='
echo -e '==========================================================='
cat ./integration_test/output.txt | sed -n -e '/^The following TestFailure object was thrown running a test:/,/^When the exception was thrown, this was the stack:$/ p' | grep -v '^When the exception was thrown, this was the stack:$'
if cat ./integration_test/output.txt | grep -q -v '^The following TestFailure object was thrown running a test:'; then
cat ./integration_test/output.txt | sed -n -e '/^The following TestFailure object was thrown running a test:/,/^When the exception was thrown, this was the stack:$/ p' | grep -v '^When the exception was thrown, this was the stack:$'
fi
if cat ./integration_test/output.txt | grep -q -v '^The following StateError was thrown running a test:'; then
cat ./integration_test/output.txt | sed -n -e '/^The following StateError was thrown running a test:/,/^When the exception was thrown, this was the stack:$/ p' | grep -v '^When the exception was thrown, this was the stack:$'
fi
