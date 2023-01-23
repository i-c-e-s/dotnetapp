#!/bin/bash
RESULT="'wget -q0- http://locahost:5083/weatherforecast'"
wget -q locahost:5083/weatherforecast
if [ $? -eq 0 ]
then
    echo 'ok - serviço no ar!'
elsif [[ $RESULT == *"Number"* ]]
then
    echo 'ok - number of visits'
    echo $RESULT
else
    echo 'not ok - number of visits'
    exit 1
fi