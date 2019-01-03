#!/bin/bash

# Get docker-compose parameters	
while ! [[ "$nbrWorkers" =~ ^[0-9]+$ ]] ; do
	echo "How many workers of 1 core do you want to start ? [1-9]";
	read nbrWorkers
done

# start HDFS & Spark
sudo docker-compose up -d --scale worker=$nbrWorkers

# Format HDFS
echo "Do you want to format the hdfs? [y-N]"
read hdfsFormat
if [[ $hdfsFormat == "y" ||  $hdfsFormat == "" ]]; then
	sudo docker exec -ti namenode sh -c "/opt/hadoop-2.7.1/bin/hdfs namenode -format"
fi

# Add file in HDFS
echo "Do you want to add file in the DFS ? [y-N]"
read dfsAdd
if [[ $dfsAdd == "y" ||  $dfsAdd == "" ]]; then
	echo "Create folder /input in DFS"
	sudo docker exec -ti namenode sh -c "/opt/hadoop-2.7.1/bin/hdfs dfs -mkdir /input"
	echo "Add samplefile1.txt in DFS"
	sudo docker exec -ti namenode sh -c "/opt/hadoop-2.7.1/bin/hdfs dfs -put /tmp/data/sample1.txt /input"
fi

# Run WordCount task
sudo docker exec -ti v3_master_1 sh -c '$SPARK_HOME/bin/spark-submit --class WordCount --master spark://master:7077 /tmp/data/wc.jar hdfs://namenode:8020/input/sample1.txt'

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

# Remove all
echo "Do you want to clean this version from your computer? [y-N]"
read cleanDocker
if [[ $cleanDocker == "y" || $cleanDocker == "" ]]; then
	sudo docker-compose down --volume
	rm -fr data
fi
