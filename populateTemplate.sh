#!/usr/bin/env bash
TEMPLATE_DIRECTORY='template'
TEMPLATE_ABBREVIATION='template'

function cloneTemplateDirectory {
	origDirectory=$TEMPLATE_DIRECTORY
	destDirectory=$1

	cp -r ./$origDirectory ./$destDirectory
}

function replaceFileNameAbbreviation {
	origAbbrev=$TEMPLATE_ABBREVIATION
	destAbbrev=$1
	destDirectory=$2

	cd $destDirectory

	# Replaces the template abbreviation in all directories
	# e.g. path/to/$orig_file.txt -> path/to/$dest_file.txt
	for file in $(find . -name "*$origAbbrev*")
	do 
	  mv $file `echo $file | sed s/$origAbbrev/$destAbbrev/`
	done

	# Note this will currently not update files that are children of a directory that needs to be renamed.
	# e.g. 1: path/to/$orig_folder/$orig.txt 
	# e.g. 2: path/to/$orig_folder/$orig_folder2/$orig.txt
	# To fix the first example we can just run the for loop again.
	# The fix the second example we could run it again, but then how many times do we cycle it?
}


function determineAbreviation {
	echo "What do you want to call this folder? e.g. feed_word_monster"
	read directory

	echo "What abreviation do you want to use? e.g. fwm"
	read abreviation

	#sanitise to force lowerCase
	lowerCaseDirectory=`echo $directory | tr '[:upper:]' '[:lower:]'`

	#convert to uppercase for Class consts e.g. FWMConsts
 	upperCaseAbbrev=`echo $abreviation | tr '[:lower:]' '[:upper:]'`

 	#convert to lowercase for filenames e.g. fwm_consts
 	lowerCaseAbbrev=`echo $abreviation | tr '[:upper:]' '[:lower:]'`
	
	cloneTemplateDirectory $lowerCaseDirectory


	replaceFileNameAbbreviation $lowerCaseAbbrev $lowerCaseDirectory
}




determineAbreviation