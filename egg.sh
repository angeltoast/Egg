#!/bin/bash

###############################################################################
# 		Egg - a simple script to do in one minute what would otherwise take		#
#		you one minute to do on your own. It creates and populates a working		#
#		directory for your next project, after you tell it what you want to do.	# 
#   			Developed by Elizabeth Mills - Version 0.00 2023/10/12  				#
###############################################################################

# This program is free software; you can redistribute it and/or modify it under the terms of the
# GNU General Public License as published by the Free Software Foundation; either version 2 of
# the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.

# A copy of the GNU General Public License is available from:
# the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

source lister.sh     # The Lister library of user interface functions

# Global variables
Gnumber=0            # For returning integers from functions
Gstring=""           # For returning strings from functions
Grow=0               # Manages the cursor vertical position between functions
Gcol=0               # Manages the cursor horizontal position between functions

Editors="$(grep 'Editors:' nest.egg | cut -d':' -f2-)"
TemplatesPath="$(grep 'Templates:' nest.egg | cut -d':' -f2)"
WorkshopPath="$(grep 'Workshop:' nest.egg | cut -d':' -f2)"

function Main() {
	declare projectPath chosenTemplate mainFile chosenEditor		# User data
	local level=1
	while [ $level -gt 0 ] 
   do  
		case "$level" in	 		# Inc/decrement to display next or previous question
      1) DoHeading				# Prepares a clean page
			GetPath					# User sets the path and project directory name
      ;;
		2) DoHeading				# Prepares a clean page
			Grow=$((Grow+1))		# Add an empty row above
			DoFirstItem "Project Location: $projectPath"	"f"	# Display previous results
			Grow=$((Grow+1))		# Add an empty row below
			GetMainFileName		# User sets the name of the 'main' file
		;;
		3) GetTemplate				# User chooses a template or 'None' from a menu
		;;
		4) GetEditor				# User chooses an editor from a menu
		;;
		*) level=0					# Failsafe
		esac
	done
	LayEgg												# Create directory and main file
	DoYesNo "Open new $mainFile?"
	if [ "$Gstring" == "Yes" ]; then
		$chosenEditor "$projectPath/$mainFile"    # Open main file in chosen editor
	fi
	DoFirstItem "Thank you for using Egg. Goodbye"
	echo
}	#End main()

function GetPath() {				# User sets path to project and directory name
	Grow=$((Grow+1))				# Add an empty row above
	DoFirstItem "Name and full path of the new directory?" 
	DoFirstItem "Add to Workshop Path, or start with / if alternative full path"
	Grow=$((Grow+1))				# Add an empty row below
	DoForm "$WorkshopPath"
	case ${Gstring:0:1} in			# Validate input using Parameter Expansion
	"/")	projectPath="$Gstring"	# First character is / so use as path
		level=2
	;;
	"")	EggMenu						# Backing out menu with settings
	;;
	*)		projectPath="$WorkshopPath$Gstring"	# Add to workshop path
		level=2
	esac
}	#End GetPath()

function GetMainFileName() {			# User enters name of 'main' file
	Grow=$((Grow+1))						# Add an empty row above
	DoForm "Name of the 'main' file (including extension): " 
	case $Gstring in						# Validate input using Parameter Expansion
	"")	level=1							# If empty, backing out
	;;
	*)		mainFile="$Gstring"
			level=3
	esac
}	#End GetMainFileName()

function GetTemplate() {				# User selects a template or 'None'
	local templates
	# shellcheck disable=SC2086
	templates="None $(ls $TemplatesPath)"
	DoMenu "$templates" "Select Exit" "Template to use for the 'main' file" 
	case "$Gstring" in
	"")	level=2
	;;
	*)	chosenTemplate="$Gstring"
		level=4
	esac
}	#End GetTemplate()

function GetEditor() {					# User selects an editor
	DoMenu "$Editors" "Select Exit" "Editor to use for this project" 
	if [ "$Gstring" == "" ]; then
		level=3
	else
		chosenEditor="$Gstring"
		level=0
	fi
}	#End GetEditor()

function LayEgg() {	
	DoYesNo "Ok to create new directory and files?"
	if [ "$Gstring" == "No" ]; then
		level=0
		return
	fi
	# Create project directory
	if [ -d "$projectPath" ]; then			# Check if pre-existing
		DoMessage "$projectPath exists, so not created"
	else
		mkdir "$projectPath"
		if [ -d "$projectPath" ]; then		# Check if created
			DoMessage "$projectPath successfully created."
		else
			DoMessage "Problem creating $projectPath."
			level=1									# Abort
			return 1
		fi
	fi
	# Create main file from template	or empty
	if [ -f "$projectPath/$mainFile" ]; then
		DoMessage "$projectPath/$mainFile exists, so not created"
	else
		if [ "$chosenTemplate" == "None" ]; then
			touch "$projectPath/$mainFile"
		else
			cp "$TemplatesPath/$chosenTemplate" "$projectPath/$mainFile"
		fi
		# Optional create README.md and change.log from template	or empty
		if [ -f "$projectPath/$mainFile" ]; then		# Check
			DoMessage "$projectPath/$mainFile successfully created."
			DoYesNo "Add a README.md and change.log?"
			if [ "$Gstring" == "Yes" ]; then
				# First try to create the README.md
				if [ -f "$TemplatesPath/README.md" ]; then
					cp "$TemplatesPath/README.md" "$projectPath/"
					DoMessage "README.md successfully created from template."
				else
					touch "$projectPath/README.md"
					if [ -f "$projectPath/README.md" ]; then
						DoMessage "Empty README.md successfully created."
					else
						DoMessage "README.md could not be created."
					fi
				fi
				# Then try to create the change.log
				if [ -f "$TemplatesPath/change.log" ]; then
					cp "$TemplatesPath/change.log" "$projectPath/"
					DoMessage "change.log successfully created from template."
				else
					touch "$projectPath/change.log"
					if [ -f "$projectPath/change.log" ]; then
						DoMessage "Empty change.log created."
					else
						DoMessage "change.log could not be created."
					fi
				fi
			fi
		else
			DoMessage "Problem creating $projectPath/$mainFile."
			level=1
			return 1
		fi
	fi
	echo
}	#End LayEgg()

function EggMenu() {
   DoMenu "Restart Settings" "" "Restart project specification, change settings, or quit"
   case $Gnumber in
   1)  DoHeading
       level=1
   ;;
	2)  nano nest.egg    # Open the file in editor until I can code properly
		# After editor is closed, reload the new settings in current session ...
		Editors="$(grep 'Editors:' nest.egg | cut -d':' -f2-)"
		TemplatesPath="$(grep 'Templates:' nest.egg | cut -d':' -f2)"
		WorkshopPath="$(grep 'Workshop:' nest.egg | cut -d':' -f2)"
		level=1
   ;;
   *)  level=0
   esac
}	#End EggMenu()

function Debug() {   # Insert at any point ...
   # Debug "$BASH_SOURCE" "$FUNCNAME" "$LINENO" " any variables "
   echo
   read -p "In file: $1, function:$2, at line:$3 > $4"
   return 0
} # End Debug

Gtitle=" ~ Egg - Start A New Project ~ "
Main
