#/bin/bash

# this should be run from its local directory
# so it links the files to the appropriate places

pwd=$(pwd)
check_and_link () {
  # this is a lie. it doesn't actually check rn
  ln -sFv $pwd/$1 ~/$1
}

check_and_link ".aliases"
check_and_link ".vimrc"

ln -sFv $pwd/tools/ack-v3.3.1 /usr/local/bin/ack
