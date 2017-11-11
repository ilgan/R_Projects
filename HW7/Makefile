clean:
	rm -f wind_data.csv words.en.length words.en.html

words.en.crlf.txt:
	curl -o wind_data.csv https://github.com/ilgan/STAT545-hw-ganelin-ilya/blob/master/HW6/10.0.103.10.csv
	
words.en.txt: words.en.crlf.txt
	tr -d '\r' <words.en.crlf.txt >words.en.txt
	
#words.en.length: words.en.txt
#	awk '{print length}' <words.en.txt >words.en.length

words.en.length: words.en.txt
	awk '{print length}' <words.en.txt >words.en.length
	
words.en.html: words.en.length words.en.rmd
	Rscript -e 'rmarkdown::render("words.en.rmd")'