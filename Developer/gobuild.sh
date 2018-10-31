#!/bin/bash
# Go Binary Builder
file="$1"
dir=$(pwd)
out=`basename $1 .go`

# Check the number of args passed
if [ "$#" -gt "1" ]; then
    echo "ONLY ONE ARGUMENT PERMITTED!"
    exit 1
fi

# Check that a real file was passed
if [ ! -f "$file" ]; then
    echo "INVALID FILE PATH"
else
    # Build the binary
    go build -ldflags "-s -w" -o "$dir"/"$out" "$file" 

    # Compress the binary
    upx --brute -q "$out"
fi
