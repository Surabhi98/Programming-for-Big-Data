#Question 1.6 [d]
#!/bin/bash
stem_words_file="./diffs.txt"

cp Reddit.csv newReddit.csv
col_number="$(head -1 newReddit.csv | sed 's/[^,]//g' | wc -c)"

stem_words_insert(){
	col_number=$1

	# save column with name: "title" in a temporary .csv file for processing
	cut -d"," -f$col_number newReddit.csv | tail -n +2 > temp.csv

	# loop through temp.csv one line at a time
	while IFS= read -r current_line; do
		#echo $current_line
		# save old record in a variable that will be modified later
		original_record=$(echo $current_line)
		echo "Original string: $original_record"
		# loop through stem_words_file and save original word and
		# its stem equivalent in variables
		while IFS= read -r curr_stem_word; do
			original_word=$(echo $curr_stem_word | cut -d" " -f1)
			stem_word=$(echo $curr_stem_word | cut -d" " -f2)

			# check if there's a match in the temp.csv file with
			# some word from the file with stem words and perform
			# replacement by using 'sed'
			if [[ "$original_record" == *"$original_word"* ]] && [[ "$original_word" != "$stem_word" ]]; then
				#echo "Found a match: $original_word / $stem_word"
				original_record=$(echo $original_record | sed "s/$original_word/$stem_word/g")
				#echo "New string: $original_record"
			fi

		done < "$stem_words_file"

		# replace old line with new modified one
		sed -i "s/$current_line/$original_record/g" newReddit.csv

	done < temp.csv

	mv newReddit.csv Reddit.csv
}



while [ $col_number -gt 0 ]; do

	column_title=$(cut -d"," -f$col_number newReddit.csv | head -n 1)

	if [ $column_title == "title" ]; then
		stem_words_insert "$col_number"
		break
	fi

col_number=$(($col_number-1))
done




