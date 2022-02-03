#!/bin/sh
#
# Measure the informational (Kolmogorov) complexity of a system.
#
# Usage: ./kolmogorov.sh path search-pattern exclude-path
#
# It will output a list of bytes-path pairs, The more bytes, the higher the
# complexity. This is based on the principle that if a file cannot be compressed
# any further, then the information contained is one long unique string, which 
# cannot be broken down any further / represented as something smaller. This
# is its Kolmogorov complexity.
#
# Example: kolmogorov.sh src/ '*.ts' './node_modules'
# Will search in src/ for TypeScript files, and ignore node_modules directory.
#
# `path' is the path to start finding files from.
# `search-pattern` is defined by what the `find -name` program takes.
# `exclude-path` is also defined by what `find -path` program takes.
# 

stdout=$(for i in $(find "$1" -path "$3" -prune -o -name "$2" -print | uniq);
do
  gz=$(mktemp)
  #tar -czf "$gz" "$i"
  gzip --keep --quiet --stdout "$i" > "$gz"
  ls -l "$gz" | awk '{ printf "%s ", $5 }'
  printf "%s\n" "$i" | sed 's/.gz$//'
  rm "$gz"
done)

echo "$stdout" | sort -h | uniq

