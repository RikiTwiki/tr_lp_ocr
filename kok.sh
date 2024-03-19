#!/bin/bash

# Function to check if a directory exists
check_dir() {
    if [ ! -d "$1" ]; then
        return 0
    else
        return 1
    fi
}

# Initialize variables
output_dir=''
csv_file=''
input_dir=''

# Function to display usage instructions
usage() {
    echo ""
    echo " Usage:"
    echo ""
    echo "   bash $0 -i input/dir -o output/dir -c csv_file.csv [-h]"
    echo ""
    echo "   -i   Input dir path (containing images of license plates ready for OCR)"
    echo "   -o   Output dir path"
    echo "   -c   Output CSV file path"
    echo "   -h   Print this help information"
    echo ""
    exit 1
}

# Parse command-line options
while getopts 'i:o:c:h' OPTION; do
    case $OPTION in
        i) input_dir=$OPTARG;;
        o) output_dir=$OPTARG;;
        c) csv_file=$OPTARG;;
        h) usage;;
        ?) usage;;
    esac
done

# Validate input
if [ -z "$input_dir" ]; then echo "Input dir not set."; usage; fi
if [ -z "$output_dir" ]; then echo "Output dir not set."; usage; fi
if [ -z "$csv_file" ]; then echo "CSV file not set."; usage; fi

# Check if input directory exists
check_dir $input_dir
retval=$?
if [ $retval -eq 0 ]; then
    echo "Input directory ($input_dir) does not exist"
    exit 1
fi

# Check if output directory exists, if not, create it
check_dir $output_dir
retval=$?
if [ $retval -eq 0 ]; then
    mkdir -p $output_dir
fi

# Execute OCR on license plates
# Ensure your OCR script is correctly set up to handle the images in $input_dir and save results in $output_dir
python license-plate-ocr.py $input_dir $output_dir

# Generate outputs (optional, depends on your specific requirements)
# Adjust the script below as necessary to handle your OCR output
python gen-outputs.py $input_dir $output_dir > $csv_file

# You may need to adjust the cleanup part based on your output files
# Cleanup intermediate files if any are created
# Example: rm $output_dir/*_intermediate_files

echo "Processing complete."