#!/bin/bash
usage()
{
cat << EOF
usage: $0 options

This script is to generate a javascript file that contains an array used for learning a language

OPTIONS:
   -h			Show this message
   -c			specify the csv file separated by "|" from where to load the vocabulary (Required)
   -v			Specify the variable name for the array that will held the vocabulary (Required)
   -o			Specify the output file name where to put the variable array  (Required)
EOF
}

while getopts “h:c:v:o:” OPTION
do
    case $OPTION in
		h)
             usage
             exit 1
             ;;
		c)
			file="${OPTARG}"
			;;
		v)
			var="${OPTARG}"
			;;
		o)
			outputFile="${OPTARG}"
	esac
done
if [[ ! -z "${file}" ]] && [[ ! -z "${var}" ]] && [[ ! -z "${outputFile}" ]] 
then
	echo "Proceeding"
	lines=$(cat "${file}" | wc -l )
	line_x="var ${var} = [];"
	echo "${line_x}" > "${outputFile}"
	#VocabClass(iText,iTrans)
	class="VocabClass"
	for ((i=1;i<="${lines}";i++))
	do
		line=$(sed -n "${i}p" "${file}" | sed 's/ /_/g' | sed 's/|/ /g' )
		out_txt="${var}.push(new ${class}("
		for word in $(echo "${line}" )
		do
			word=$(echo "${word}" | sed 's/_/ /g')
			out_txt="${out_txt} '${word}',"
		done
		echo "${out_txt}" | sed 's/,$/));/g' >> "${outputFile}"
	done
else
	usage
fi