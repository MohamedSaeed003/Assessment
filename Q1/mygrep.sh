#!/bin/bash

# Function to print usage info
print_usage() {
    echo "Usage: $0 [options] <pattern> <file>"
    echo ""
    echo "Options:"
    echo "  -n      Show line numbers."
    echo "  -v      Invert match (show lines that do NOT match)."
    echo "  --help  Show this help message."
    echo ""
    echo "Example:"
    echo "  $0 -n hello file.txt"
}

# Check if at least 1 argument is given
if [ $# -lt 1 ]; then
    echo "check help by ./mygrep.sh --help"
    exit 1
fi

# Initialize options
show_line_numbers=false
invert_match=false

# Parse options
while [[ "$1" == -* ]]; do
    case "$1" in
        --help)
            print_usage
            exit 0
            ;;
        -*)
            optstring="${1#-}"  # remove leading dash
            for (( i=0; i<${#optstring}; i++ )); do
                char="${optstring:$i:1}"
                case "$char" in
                    n)
                        show_line_numbers=true
                        ;;
                    v)
                        invert_match=true
                        ;;
                    *)
                        echo "Unknown option: -$char"
                        echo "Check help by ./mygrep.sh --help"
                        exit 1
                        ;;
                esac
            done
            ;;
    esac
    shift
done


# After options are processed
pattern=$1
file=$2

# Check if both pattern and file are provided
if [ -z "$pattern" ] || [ -z "$file" ]; then
    echo "Error: Missing pattern or file."
    echo "Check help by ./mygrep.sh --help"
    exit 1
fi

# Check if file exists
if [ ! -f "$file" ]; then
    echo "Error: File not found: $file"
    exit 1
fi

# Read the file line by line
line_number=0
while IFS= read -r line; do
    ((line_number++))

    # Check for match (case-insensitive)
    if echo "$line" | grep -i -q -- "$pattern"; then
        match=true
    else
        match=false
    fi

    # Invert match if requested
    if $invert_match; then
        if $match; then
            match=false
        else
            match=true
        fi
    fi

    # Print if it's a match
    if $match; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"
