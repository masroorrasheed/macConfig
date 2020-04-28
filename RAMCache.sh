#!/bin/bash

# Size at the end is * 2048 where 2048 = 1 MB, so 1572864 = 768 MB,8388608 = 4GB and in this code I make it 4GB

diskutil erasevolume HFS+ 'RAM' `hdiutil attach -nomount ram://8388608`

export CACHEDIR="/Volumes/RAM"

# Safari Cache
/bin/rm -rvf ~/Library/Caches/com.apple.Safari
/bin/mkdir -pv $CACHEDIR/Apple/Safari
/bin/ln -v -s $CACHEDIR/Apple/Safari ~/Library/Caches/com.apple.Safari

