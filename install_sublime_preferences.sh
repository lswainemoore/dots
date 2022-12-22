# needs some adjusting if you want to work on linux (SUBLIME_DIR AND KEYMAP_FILE)
HOME_DIR=~/
SUBLIME_DIR="Library/Application\ Support/Sublime\ Text\ 3/Packages/User/"
DOTS_DIR=dots/
PREF_FILE=Preferences.sublime-settings
KEYMAP_FILE="Default\ \(OSX\).sublime-keymap"
echo "remove main preferences"
echo "rm $HOME_DIR$SUBLIME_DIR$PREF_FILE"
echo "linking main preferences"
echo "ln -s $HOME_DIR$DOTS_DIR$PREF_FILE $HOME_DIR$SUBLIME_DIR$PREF_FILE"
echo "removing keymap"
echo "rm $HOME_DIR$SUBLIME_DIR$KEYMAP_FILE"
echo "linking keymap"
echo "ln -s $HOME_DIR$DOTS_DIR$KEYMAP_FILE $HOME_DIR$SUBLIME_DIR$KEYMAP_FILE"
