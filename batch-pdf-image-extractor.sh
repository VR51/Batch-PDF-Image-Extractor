#!/bin/bash
clear

###
#
#	Batch PDF Image Extractor 1.0.1
#
#	Lead Author: Lee Hodson
#	Donate: paypal.me/vr51
#	Website: https://journalxtra.com
#	First Written: 18th Oct. 2015
#	First Release: 2nd Nov. 2015
#	This Release: 24th Jun. 2017
#
#	Copyright 2016 Lee Hodson <https://journalxtra.com>
#	License: GPL3
#
#	Programmer: Lee Hodson <journalxtra.com>, VR51 <vr51.com>
#
#	Use of this program is at your own risk
#
#	TO RUN:
#
#	- Ensure the script is executable.
#	- Command line: ./batch-pdf-image-extractor.sh
#	- File browser: click batch-pdf-image-extractor.sh
#
#	Use Batch PDF Image Extractor to extract images from a bulk lot of PDF files
#	Place this script file in the same directory as the PDF files you need to process then either click the script file or run the script through a terminal. Clicking the script file will open a terminal to run the program.
#	Edit the configs if you wish to. The default settings should be fine.
#
#	REQUIREMENTS
#
#	Bash, pdfimage (part of popplar tools), imagemagick (for mogrify) and PDF files to work on.
#
#
#	WHAT TO EXPECT
#
#
#	Batch PDF Image Extractor will use pdfimage to extract images from all PDF files stored in the same directory as this script. Extracted images are converted to any specified image format. Images are extracted and processed as soon as the script is executed.
#
#
#	CONFIGS
#
#	The default settings convert TIFF, TIF, PMB and PPM file formats to PNG. Files extracted as JPG or JPEG will be left unconverted.
#	Adjust the file conversion settings by adding unwanted file formats to the 'extensions' array and by changing the preferred 'format' value to whatever format you want to convert files of the unwanted extensions into.
#
###



##
#
# Configs
#
##

extensions=( tiff tif pmb ppm ccitt params ) # List the output image extensions that should be converted to a different format
format='png' # State the format images with $extensions should be converted to.
organize='move' # 'copy' or 'move' all files into subdirectories organised by extension type. Leave empty for no organization.

## END Configs






title="Batch PDF Image Extract"


###
#
# System Checks
#
###

	###
	#
	#	Confirm we are running in a terminal
	#		If not, try to launch this program in a terminal
	#
	###

	tty -s

	if test "$?" -ne 0
	then

		terminal=( konsole gnome-terminal x-terminal-emulator xdg-terminal terminator urxvt rxvt Eterm aterm roxterm xfce4-terminal termite lxterminal xterm )
		for i in ${terminal[@]}; do
			if command -v $i > /dev/null 2>&1; then
				exec $i -e "$0"
				break
			fi
		done

	fi


	###
	#
	#	Check for required software dependencies
	#
	###

	printf "\nTesting for necessary software requirements:\n\n"

	error=0
	requirement=( pdfimages )
	for i in ${requirement[@]}; do

		if command -v $i > /dev/null 2>&1; then
			statusmessage+=("%4sFound:%10s$i")
			statusflag+=('0')
		else
			statusmessage+=("%4sMissing:%8s$i")
			statusflag+=('1')
			whattoinstall+=("$i")
			error=1
		fi

	done

	# Display status of presence or not of each requirement

	for LINE in ${statusmessage[@]}; do
		printf "$LINE\n"
	done

	# Check for critical errors and warning errors. Set critical flag if appropriate.

	critical=0

	if test ${statusflag[0]} = 1
	then
		printf "\n%4sWe need the program 'pdfimages' for $title to work.\n"
		critical=1
	fi

	# Display appropriate status messages

	if test "$error" == 0 && test "$critical" == 0; then
		printf "\nThe software environment is optimal for this program.\n"
	fi

	if test "$error" == 1 && test "$critical" == 0; then
		printf "Non essential software required by $title is missing from this system. If $title fails to run, consider to install with, for example,\n\n%6ssudo apt-get install ${whattoinstall[*]}"
	fi

	if test "$critical" == 1; then
		printf  "Critical error" "essential software dependencies are missing from this system. $title will stop here. install missing software with, for example,\n\n%6ssudo apt-get install ${whattoinstall[*]}\n\nthen run $title again."
		read something
		exit 1
	fi

	
###
#
# Process the PDF Files
#
###

echo 'Press any key to continue. All PDF files in the current directory will be processed.'
echo 'Press Ctrl+C to cancel.'
read something

###
#
# Process the PDF Files
#
###


# Locate Where We Are
filepath="$(dirname "$(readlink -f "$0")")"

# A Little precaution
cd "$filepath"

# Extract images from PDFs in the current directory
printf "\nStage 1: Extracting images from PDFs\n\n"

count=1
for f in "$filepath"/*.pdf
do
	if test -f "$f"
	then
		pdfimages -all "$f" "$f"
		printf "%4s$count) Extracting images from '$f'\n"
		let "count += 1"
	else
		printf "%4sNo PDFs here. Run this script in a location that contains PDFs'\n"
		read something
		exit 0
	fi
	
done

# Convert $extensions to preferred extension $format
printf "\nStage 2: Converting images to preferred image format\n\n"

round=1
for ext in ${extensions[@]}
do
	printf "\n%4sRound: $round of ${#extensions[@]}. Converting $ext to $format\n\n"
	
	for f in "$filepath/"*."$ext"
	do
		if test -f "$f"
		then
			mogrify -format "$format" "$f"
			printf "%8sConverting $f\n"
		else
			printf "%8sNo images of this format to convert. Moving on...'\n"
		fi
	done

	let "round += 1"
done

# Organize the files.. or not

# Update $extensions array
extensions+=("$format" "pdf" "jpg" "jpeg" "svg")

if test $organize
then
	printf "\nStage 3: $organize files into sub directories\n\n"
	printf "%4s"
	for ext in ${extensions[@]}
	do

		for f in "$filepath"/*.$ext
		do
			if test -f "$f"
			then
				if test ! -d "$filepath/$ext"
				then
					mkdir "$filepath/$ext" # Make sub directory for each extension
				fi
				case $organize in
				
					copy)
						cp "$filepath"/*."$ext" "$filepath/$ext/"
						printf '.'
					;;
					move)
						mv "$filepath"/*."$ext" "$filepath/$ext/"
						printf '.'
					;;
				esac
			fi
		done
	done
fi

printf "\n\nAll Done!\n\n"
