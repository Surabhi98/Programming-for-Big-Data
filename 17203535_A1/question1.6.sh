#Question 1.6 [a,b,c] parts:
#making a copy of our previously cleaned file
cp Reddit.csv newReddit.csv
#storing stop words in a new file
filename="stopwords.txt"
#getting total number of columns in the file
col_number="$(head -1 Reddit.csv| sed 's/[^,]//g' | wc -c)"

#Function to alter the title column, converting all letters to lowercase
#Removing punctuation
#Removing stop words
altering_title_column(){
	#adding each column to a temporary file (without the first line)
	cut -d"," -f$1 newReddit.csv | tail -n +2 > tmp.csv

	#while loop to read the temporary file line by line
		while IFS= read -r var; do
			#converting letters to lowercase
			lowercase=$(echo "$var" | tr A-Z a-z )
			#removing punctuation
			punctuation=$(echo "$lowercase" | tr -d '[:punct:]')
			#changing the original line so that sed ignores special characters
			var=$(echo "$var" | sed 's,\[,\\\[,g' | sed 's,\],\\\], g')
			#looping through the stopwords.txt file to remove the stopwords
			while IFS= read -r line; do
			#removing the stopwords
				echo $line
				punctuation=$(echo $punctuation | sed "s/\b$line\b/ /g")
			done < "$filename"
			#searching for the line in the column
			#replace it with lowercase
			sed -i.bak "s,$var,$punctuation,g" newReddit.csv
		done < tmp.csv

}

#looping through the total number of columns
for ((i=$col_number; i>0; i--)); do
	#getting the title of the current column
        title=$(cut -d"," -f$i newReddit.csv | head -n 1)
	#if the variable matches title then, calling the function
	if [ "$title" == "title" ]; then
	#calling the function with title passed as paramenter
        altering_title_column "$i"
	fi


done

#renaming the file back to Reddit.csv
mv newReddit.csv Reddit.csv


