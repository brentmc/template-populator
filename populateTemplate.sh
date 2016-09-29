#!/usr/bin/env bash

################################################################################
# Use this script to clone everything in the template folder then automatically
# rename all directories and files.
################################################################################

################################################################################
#Constants
TEMPLATE_DIRECTORY='template'           #Where it will live e.g. feed_word_monster/
TEMPLATE_ABBREVIATION='template'        #Prefix for filenames e.g. fwm_game.js
TEMPLATE_LOWER_CASE='template'          #All instances of lowercase e.g. import './systems/fwm_game.js'
TEMPLATE_UPPERCASE_CASE='TEMPLATE'      #All instances of uppercase e.g. FWMGame

function cloneTemplateDirectory {
	origDirectory=$TEMPLATE_DIRECTORY
	destDirectory=$1

	cp -r ./$origDirectory ./$destDirectory
}

function renameFiles {
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


function findAndReplace {
	fileToEdit=$1
	searchText=$2
    replaceText=$3

    regEx="s/"$searchText"/"$replaceText"/"

    # Read about this here:
    # http://www.praj.com.au/post/23691181208/grep-replace-text-string-in-files
    grep -r -l $searchText $fileToEdit | sort | uniq | xargs perl -e $regEx -pi
}

function replaceAllContent {
	destLowerCase=$1
	destUpperCase=$2

	for file in $(find . -name "*")
	do
	  echo $file
	  findAndReplace $file $TEMPLATE_LOWER_CASE $destLowerCase
	  findAndReplace $file $TEMPLATE_UPPERCASE_CASE $destUpperCase
	done
}

function determineAbbreviation {
	echo "What do you want to call this folder? e.g. feed_word_monster"
	read directory

	echo "What abbreviation do you want to use? e.g. fwm"
	read abbreviation

	#sanitise to force lowerCase
	lowerCaseDirectory=`echo $directory | tr '[:upper:]' '[:lower:]'`

	#convert to uppercase for Class consts e.g. FWMConsts
 	upperCaseAbbrev=`echo $abbreviation | tr '[:lower:]' '[:upper:]'`

 	#convert to lowercase for filenames e.g. fwm_consts
 	lowerCaseAbbrev=`echo $abbreviation | tr '[:upper:]' '[:lower:]'`

	cloneTemplateDirectory $lowerCaseDirectory


	renameFiles $lowerCaseAbbrev $lowerCaseDirectory
	replaceAllContent $lowerCaseAbbrev $upperCaseAbbrev
}

determineAbbreviation
