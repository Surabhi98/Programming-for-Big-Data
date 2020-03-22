#!/bin/bash

#Question 1.3
#creating a copy of the cleaned file so that we don't overwrite it
cp Reddit.csv newReddit.csv

#counting the total number of columns in the file
col_number="$(head -1 newReddit.csv| sed 's/[^,]//g' | wc -c)"

#Loop through each column starting from the end
for(( counter=col_number;counter>0;--counter)); do
        #Selecting columns from second last line, thereby cutting the colummns
        cut -d"," -f$col_number newReddit.csv | tail -n +2 > temp.csv
        #using is_empty to idenify the empty columns
        #if is_empty is zero , it means the columns is empty, else it is not
        is_empty=0

        #checks if the row is not empty
        #it increments is_empty
        while read -r line; do
                if [ ! -z "${line}" ]; then
                        is_empty=1
                fi
        done < temp.csv

        #if all rows are empty, remove the coluumn
        #updates the file
        if [ $is_empty -eq 0 ]; then
                cut -d"," -f$col_number --complement newReddit.csv > temp.csv
                echo $count
                mv temp.csv newReddit.csv
        fi
done

mv newReddit.csv Reddit.csv

