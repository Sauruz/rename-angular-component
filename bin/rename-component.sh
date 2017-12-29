#!/bin/bash

RED='\033[0;31m'
NOCOLOR='\033[0m' 
ORANGE='\033[0;33m'

echo "Class name of component to replace (e.g. ExampleComponent): "
read old_class_name
# old_class_name="BuildingOverviewComponent"
echo "New class name of component (e.g. NewComponent): "
read new_class_name
#new_class_name="BuildingTestTestComponent"

#Rename old class to file name 
old_file_name="${old_class_name/Component/}"
old_file_name="$(tr '[:upper:]' '[:lower:]' <<< ${old_file_name:0:1})${old_file_name:1}"
old_file_name=$(sed -E 's/([A-Z])/-\1/g' <<< $old_file_name)
old_file_name=$(echo "$old_file_name" | tr '[:upper:]' '[:lower:]')

#Rename new class to file name 
new_file_name="${new_class_name/Component/}"
new_file_name="$(tr '[:upper:]' '[:lower:]' <<< ${new_file_name:0:1})${new_file_name:1}"
new_file_name=$(sed -E 's/([A-Z])/-\1/g' <<< $new_file_name)
new_file_name=$(echo "$new_file_name" | tr '[:upper:]' '[:lower:]')

#Directory
directory=`find ./src/app -name "$old_file_name"`
if [ -z "$directory" ]; then
    echo -e "${RED}ERROR: Could not find a directory with name '$old_file_name'${NOCOLOR}"
else
	component=`find ./src/app -name "*$old_file_name.component.ts"`
	if [ -z "$component" ]; then
		echo -e "${RED}ERROR: Could not find $old_file_name.component.ts ${NOCOLOR}"
	else
	
		#Replace and rename component
		sed -i '' 's/'$old_class_name'/'$new_class_name'/g' $component
		sed -i '' 's/'$old_file_name'/'$new_file_name'/g' $component
		new_component="$directory/$new_file_name.component.ts"
		mv "$component" "$new_component"

		#Replace and rename test
		spec=`find . -name $old_file_name.component.spec.ts`
		if [ -z "$spec" ]; then
    		echo "$old_file_name.component.spec.ts was not found"
    	else 
    		sed -i '' 's/'$old_class_name'/'$new_class_name'/g' $spec
 			sed -i '' 's/'$old_file_name'/'$new_file_name'/g' $spec
 			new_test="$directory/$new_file_name.component.spec.ts"
			mv "$spec" "$new_test"
		fi
		
		#Replace and rename html
		html=`find . -name $old_file_name.component.html`
		if [ -z "$html" ]; then
    		echo "$old_file_name.component.html was not found."
    	else 
 			new_html="$directory/$new_file_name.component.html"
			mv "$html" "$new_html"
		fi
		
		#Replace and rename CSS
		css=`find . -name $old_file_name.component.css`
		if [ ! -z "$css" ]; then
    		new_css="$directory/$new_file_name.component.css"
			mv "$css" "$new_css"
    	fi
    	
    	#Replace and rename SCSS
		scss=`find . -name $old_file_name.component.scss`
		if [ ! -z "$scss" ]; then
    		new_scss="$directory/$new_file_name.component.scss"
			mv "$scss" "$new_scss"
    	fi
		
		#Rename directory
		new_directory="${directory//$old_file_name/$new_file_name}"
		mv "$directory" "$new_directory"
	fi
fi

echo -e "${ORANGE}Please replace $old_class_name in app.module.ts and/or in the modules the componend is used. ${NOCOLOR}"
