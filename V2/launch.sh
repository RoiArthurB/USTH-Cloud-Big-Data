#!/bin/bash  

# Get docker-compose parameters	
while ! [[ "$nbrWorkers" =~ ^[0-9]+$ ]] ; do
	echo "How many workers do you want to start ? [1-9]";
	read nbrWorkers
done

while ! [[ "$nbrCores" =~ ^[0-9]+$ ]] ; do
	echo "How many cores by worker do you want to use ? ";
	read nbrCores 
done

# Clean .env file
truncate -s 0 .env

# Set new var in .env file
echo "CORES=$nbrCores" > ".env"

# Run Docker-compose :
sudo docker-compose up -d --scale worker=$nbrWorkers

# Launch work in Master container :
sudo docker exec -ti v2_master_1 sh -c '$SPARK_HOME/bin/spark-submit --class WordCount --master spark://master:7077 /tmp/data/wc.jar /tmp/data/sample1.txt'

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