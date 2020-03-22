#!/bin/bash

#Question 1.1:
#Removing characters that fail to split the file

#making a copy of the original file so that we can work on it
#without modifying the original file
cp Reddit_shorter_COMP30770_top1000.csv Reddit.csv

#Looping through the file to find these characters
#which fail to split the file, resulting in failure of
#cut commands

#searching the characters with grep
while grep -q '"[^"][^"]*,.*"' Reddit.csv ;do
        #removing the characters with sed and saving the result in another file
        sed 's/\("[^"][^"]*\),\(.*"\)/\1;\2/' Reddit.csv > Reddit2.csv
        #updating our file
        mv Reddit2.csv Reddit.csv
done


#Question 1.2
#safely removing the first column of the file with the
#cut command by selecting the first column and transferring
#everything else accept the first column to another file
cut -d"," -f1 --complement Reddit.csv > Reddit1.csv
#updating Reddit.csv by mmoving the contents of Reddit1.csv to Reddit.csv
mv Reddit1.csv Reddit.csv
