#!/bin/sh
# Pre-commit hook for git which removes trailing whitespace, converts tabs to spaces, and enforces a max line length.

if git-rev-parse --verify HEAD >/dev/null 2>&1 ; then
   against=HEAD
else
   # Initial commit: diff against an empty tree object
   against=4b825dc642cb6eb9a060e54bf8d69288fbee4904
fi

files_with_whitespace=`git diff-index --check --cached $against | # Find all changed files
                       sed '/^[+-]/d' |                           # Remove lines which start with + or - 
                       sed -E 's/:[0-9]+:.*//' |                  # Remove end of lines which contains numbers, etc.
                       sed '/Generated/d' |                       # Ignore generated files
                       sed '/Libraries/d' |                       # Ignore libraries
                       sed '/\.[mh]\$/!d' |                       # Only process .m and .h files
                       uniq`                                      # Remove duplicate files

# Change field separator to newline so that for correctly iterates over lines
IFS=$'\n'

# Find files with trailing whitespace
for FILE in $files_with_whitespace ; do
    echo "Fixing whitespace in $FILE" >&2
    # Replace tabs with four spaces
    sed -i "" $'s/\t/    /g' "$FILE"
    # Strip trailing whitespace
    sed -i '' -E 's/[[:space:]]*$//' "$FILE"
    git add "$FILE"
done

# Detect too long lines in .m and .h files:
changed_source_files=`git diff-index --cached $against --numstat |
                      cut -f3 |
                      egrep '\.[hm]$'`

if [[ -n "$changed_source_files" ]]; then
    found_offenses=''

    for file in $changed_source_files ; do
        too_long=`git diff-index --cached -p $against -- "$file" |
                  egrep '^\+.{117,}' |
                  sed -E 's/^\+//'`
        
        if [[ -n "$too_long" ]]; then
            found_offenses=YES
            printf "\n$file:\n%s\n" "$too_long" >&2
        fi
    done

    if [[ -n $found_offenses ]]; then
        echo "\nAborting commit because you added lines longer than 116 chars." >&2
        exit 1
    fi
fi
