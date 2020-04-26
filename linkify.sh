#/bin/bash

# this should be run from its local directory
# so it links the files to the appropriate places

pwd=$(pwd)
check_and_link () {
  # this is a lie. it doesn't actually check rn
  ln -sfFv $pwd/$1 ~/$1
}

check_and_link ".aliases"
check_and_link ".vimrc"

destination="/usr/local/bin/"
check_and_link_tool () {
  if [ -w $destination ]; then
    ln -sFv $pwd/tools/$1 $destination$2
  else
    echo "(using sudo)"
    sudo ln -sFv $pwd/tools/$1 $destination$2
  fi
}

check_and_link_tool "ack-v3.3.1" "ack"
