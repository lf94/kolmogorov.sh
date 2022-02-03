```sh
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

#
# Example output:
# 57 src/routes/individuals/index.ts
# 75 src/routes/index.ts
# 76 src/routes/support/index.ts
# 97 src/routes/all/index.ts
# 97 src/text/index.ts
# 119 src/server/uploader.ts
# 121 src/routes/individuals/advanced/index.ts
# 132 src/errors/index.ts
# 169 src/routes/individuals/prefix.ts
# 209 src/utils.ts
# 242 src/routes/types.ts
# 274 src/routes/all/overview.ts
# 345 src/routes/pug/index.ts
# 797 src/migrations/index.ts
# 995 src/migrations/1-create-base.ts
# 1041 src/routes/all/kyc-broker.ts
# 1216 src/server/oauth2/index.ts
# ...
#
# As we see the most complex file is oauth2/index.ts.
# This allows us to quickly see where the complex parts of the system are,
# indepedent of the line count.
#
```
