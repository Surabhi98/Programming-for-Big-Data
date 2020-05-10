SURABHI AGARWAL 17203535

This ReadMe explains the layout of my submission. The explanation of each of the tasks is in the report.

1. The folder Question 1 contains the screenshots of my scala code which I used to do the tasks, these can be referred in order to run the code. 

2. The folder Question 2 contains both the files Question2_MapReduce.java and Question2_GraphX.java

For Question2_MapReduce.java, open a docker container and run the following commands:
-	docker exec -it namenode bash
-	export HADOOP_CLASSPATH=/usr/lib/jvm/java-1.8.0-openjdk-amd64/lib/tools.jar
-	hadoop com.sun.tools.javac.Main Question2_MapReduce.java
-	jar cf Question2_MapReduce.jar Question2_MapReduce*.class
-	hadoop jar Question2_MapReduce.jar MapReduce /input/output1/output2
-	hdfs dfs -cat /output2/part-r-00000 | sort —k 2 -n —reverse | head -n 10

For Question2_Graphx.java, the code can be copied and pasted into the spark-shell itself.

3. Thank you :)
