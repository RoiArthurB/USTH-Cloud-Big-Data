#!/bin/bash


while [ $(stat -c%s "data/sample1.txt") -lt 2000000000 ]; do
	cat data/sample1.txt >> data/tmpSample.txt
	cat data/tmpSample.txt >> data/sample1.txt
done

rm data/tmpSample.txt
