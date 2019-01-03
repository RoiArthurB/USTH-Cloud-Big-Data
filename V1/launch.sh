#!/bin/bash  

# Run Docker-compose :
sudo docker-compose up -d

# Launch work in Master container :
sudo docker exec -ti v1_spark_1 sh -c '$SPARK_HOME/bin/spark-submit --class WordCount --master local /tmp/data/wc.jar /tmp/data/sample1.txt'

# Result :
echo "Do you want to display result? [y-N]"
read displayResult
if [[ $displayResult == "y" ||  $displayResult == "" ]]; then
	sudo cat ../data/result/*
fi

# Stop containers
echo "Do you want to stop containers? [y-N]"
read stopDocker
if [[ $stopDocker == "y" || $stopDocker == "" ]]; then
	sudo docker-compose stop
fi
