#!/bin/bash

if false; then
- Write a shell script x.sh that searches in the subtree of the home directory of the user each file having extension
- .c, and it renames these files with extension .c_new only if the file includes a string equal to the name of the file.
- For example, if only two files are found, namely, first.c and second.c, and file first.c includes these two lines:
- 
-    // this is first.c
-    main{ print ”Hello\n”}
- 
- while file second.c includes these two lines:
- 
-    // this is my program n. 1
-    main{ print ”Hello\n”}
- 
- only file first.c will be renamed as first.c_new.
fi


find ~ -type f -name "*.c" > tmp.txt

while read -r line; do
    name=$(basename "$line")
    eq=$(grep -e "$name" "$line")
    if [ ! -z "$eq" ]; then
        mv "$line" "$line""_new"
    fi
done < tmp.txt
rm tmp.txt