#!/usr/bin/env bash

# Write note posts:
for f in note/*; do
	# Grab filename and title
	file="$(basename $f)"
	notetitle="$(sed '2q;d' $f | sed 's/title: //;s/\"//g')"
	notefile=html/${file%.md}.html

	printf "%s\n" "Creating ${f%.md}.html ($notetitle)..."
	# Append to list:
	notelist="$notelist<li><a href="$notefile">$notetitle</a><br/>$file</li>"

	# Append all content to the respective file...
	# Header
	printf "%s\n" "<!DOCTYPE html>\
<html><head>\
  <meta charset=\"UTF-8\">\
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\
  <title>$notetitle</title>\
  <link href=\"../style.css\" rel=\"stylesheet\" type=\"text/css\" media=\"all\">\
</head><body><div id=\"main\">\
  <p><sup><a href=\"../index.html\">index.html</a> &mdash; Negoițescu Mario &mdash; <a href=\"https://github.com/mnegoitescu/notes\">GitHub</a/></sup></p>\
  <h1>$notetitle</h1>" > "$notefile"

	# Content
	pandoc -s --toc --template=blank.html "$f" >> "$notefile"

	# Ending
	printf "%s\n" "</div></body></html>" >> "$notefile" 

done


# Write index.html
printf "%s\n" "Writing index.html ..."

# Use cat EOF for the gist of the file
cat > index.html << EOF
<!DOCTYPE html>
<html><head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>notes - negoitescu</title>
  <link href="./style.css" rel="stylesheet" type="text/css" media="all">
</head><body><div id="main">
  <h1>notes</h1>
  <ul>
  $notelist
  </ul>
  <hr/>
  <p>Hosted by <a href="https://github.com/mnegoitescu/notes">GitHub</a>. All notes available here are licensed under the <a href="https://www.creativecommons.org/licenses/by-nc/4.0/deed.en">CC BY-NC 4.0</a>, unless otherwise noted.</p>
</div></body>
</html>
EOF
