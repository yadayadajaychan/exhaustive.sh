#!/usr/bin/env sh

for test in *.in
do
	../exhaustive.sh $(cat "$test") | diff -q - "${test%in}out" > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		echo test \#${test%.in} passed
	else
		echo test \#${test%.in} FAILED
		exit 1
	fi
done
