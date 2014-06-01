#! /bin/zsh -f

url=$1
proto=${url//:*/}
data=${${url//*:\/\//}%/}
data=${data//\%20/}
data=${data//\$HOME/$HOME}
/usr/bin/uxterm -ut -T $data -fg Snow -bd GoldenRod -bg Black -e "$proto $data"
