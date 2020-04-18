#/bin/bash

pwd=$(pwd)
check_and_link () {
  # this is a lie. it doesn't actually check rn
  ln -sFv $pwd/$1 ~/$1
}

check_and_link ".aliases"
check_and_link ".vimrc"
