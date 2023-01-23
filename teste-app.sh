#!/bin/bash
RESULT="'wget -qO- http://localhost:5083/weatherforecast'"
wget -q localhost:5083/weatherforecast
if [ $? -eq 0 ]
then
    echo 'ok - serviço no ar!'
elif [[ $RESULT == *"Number"* ]]
then
    echo 'ok - number of visits'
    echo $RESULT
else
    echo 'not ok - number of visits'
    exit 1
fi