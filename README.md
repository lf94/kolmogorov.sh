```sh
#!/bin/sh
#
# Measure the informational (Kolmogorov) complexity of a system.
#
# Usage: ./kolmogorov.sh path search-pattern delete-pattern
#
# `path' is the path to start finding files from.
# `search-pattern` is defined by what the `find -name` program takes.
# 

stdout=$(for i in $(find "$1" -name "$2" | uniq);
do
  gz=$(mktemp)
  #tar -czf "$gz" "$i"
  gzip --keep --quiet --stdout "$i" > "$gz"
  ls -l "$gz" | awk '{ printf "%s ", $5 }'
  printf "%s\n" "$i" | sed 's/.gz$//'
  rm "$gz"
done)

echo "$stdout" | sort -h | uniq
```
