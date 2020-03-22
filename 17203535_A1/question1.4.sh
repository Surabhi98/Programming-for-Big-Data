#!/bin/bash
#Question 1.4
#creating a funtion to find unique values in the file

calculate_unique_values(){
	#using cut command to sort the values
	numunique="$(cut -d"," -f$1 Reddit.csv | tail -n +2 | sort -u | wc -l)"
	#If there is only unique value i.e all the values are same
	#The cut command removes the column with this value and puts the
	#rest of the data excluding the column in a temporary csv file
	if [ $numunique -eq 1 ]; then
		cut -d"," -f$1 --complement Reddit.csv > temp.csv
		#updating the file with the new contents
		mv temp.csv Reddit.csv
	fi

}
#Finding the total number of columnsmin the file
#Using the sed command
col_num="$(sed -n 2p Reddit.csv | tr ',' '\n' | wc -l )"

#Looping through the file
while [ $col_num -gt 0 ]; do
	#calls the function with column number as argument
	calculate_unique_values "$col_num"
	#decrements the column
	col_num=$(($col_num-1))
done
