
tmp=~/var/state/index
rm -f $tmp
for i in $(vcsh list); do
    vcsh $i ls-files $HOME -z |
    GIT_INDEX_FILE=$tmp xargs -0 git update-index --add
done
GIT_INDEX_FILE=$tmp git ls-files -o
