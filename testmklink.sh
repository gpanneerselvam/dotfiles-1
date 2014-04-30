#!/bin/sh
#
# Check for the mklink cmd.exe command (Windows Vista/7+).
# Echoes the command to create a symbolic link using mklink if successful.
# Assumes it is executing under MSYS (MINGW32) or Cygwin.
# Taken from https://github.com/igetgames/dotfiles/blob/master/testmklink.sh
#set -x

case "`uname -s`" in
  MINGW*)
    fslash="//"
    winpwd="pwd -W"
    ;;

  CYGW*)
    fslash="/"
    winpwd="cygpath -wa ."
    ;;

  Linux*)
    exit 2
    ;;

  *)
    echo "This script should only be run under Linux, MSYS or Cygwin."
    exit 1
    ;;
esac


mklink="cmd ${fslash}c mklink"
mklink_success="symbolic link created"


TMP1="tmp1"
TMP2="tmp2"

# Create a temporary directory and try to make a link to it.
tmpt=`mkdir $TMP1` || exit 1
tmpl=`mkdir $TMP2`

if [ $? -ne 0 ]; then    
    rm -rf "$TMP1"
    exit 1
fi

watmpt=$(cd "$TMP1" && $winpwd | sed 's/\//\\/g')
watmpl=$(cd "$TMP2" && $winpwd | sed 's/\//\\/g')

rm -rf "$TMP2"

success=$($mklink ${fslash}d "$watmpl" "$watmpt" 2>/dev/null | grep "$mklink_success")

if [ -z "$success" ]; then    
    rm -rf "$TMP1"
    exit 1
fi

rm -rf "$TMP2" "$TMP1"

echo $mklink
exit 0
