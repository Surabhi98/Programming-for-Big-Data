#!/bin/bash
cp Reddit.csv newReddit.csv
#Question 1.5
#Calculate the total number of columns
col_number="$(head -1 Reddit.csv| sed 's/[^,]//g' | wc -c)"

#Function to convert the seconds in the variables created and retrieved
#Passing column title as argument
convert_seconds_to_day(){
	#checking for the title name
	#if title is created_utc then we amend the values of the variable
	#changing the seconds to a specific day
	if [ $1 == "created_utc" ]; then
	#while loop to read the temporary file line by line
                while IFS= read -r var; do
	#creating a new variable to store the days
                        day=$(date --date="@${var}" +%a)
	#replaces each occurence of the variable in place
                        sed -i "s/$var/$day/" newReddit.csv
                done < tmp.csv

	#Similarly, we do the same for retrieved_on
        elif [ $1 == "retrieved_on" ]; then
	#while loop to read the temporary file line by line
                while IFS= read -r var; do
                  #creating a new variable to store the days
                        day=$(date --date="@${var}" +%a)
                        sed -i "s/$var/$day/" newReddit.csv
                done < tmp.csv
        fi
}

#looping through the total number of columns
#in reverse order
for ((i=$col_number; i>0; i--)); do
	cut -d"," -f$i newReddit.csv | tail -n +2 > tmp.csv
	title=$(cut -d"," -f$i newReddit.csv | head -n 1)

	convert_seconds_to_day "$title"

done

mv newReddit.csv Reddit.csv

