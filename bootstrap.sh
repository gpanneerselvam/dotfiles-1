#!/usr/bin/env bash
curdir=$(dirname $0)
home=~

if [ "$curdir" == "." ]
	then
		curdir=$PWD
	else
		curdir="$PWD/$curdir"
fi

echo $home
echo $curdir

# Add depencies first
# source $curdir/install-deps.sh

case "`uname -s`" in
  MINGW*)
    cmdslash="//"
    ;;

  CYGW*)
    cmdslash="/"
    ;;

  *)
    echo "This script should only be run under MSYS or Cygwin."
    exit 1
    ;;
esac

mklink=`bash "$curdir/testmklink.sh"`

if [ -z "$mklink" ]; then
	echo "Won't be able to make symbolic links"
	exit 1
fi

# Convert to windows style slashing
wpath() # posix
{
  # TODO: Use cygpath under Cygwin.  
  cmd ${cmdslash}c echo "$1" | sed 's/\//\\/g'
}

symlink() # target, link
{
  target=$1
  link=$2
  
  if [ -d "$target" ]; then
    # cmd ${cmdslash}c rd "`wpath $link`" > /dev/null 2>&1
    $mklink ${cmdslash}d "`wpath $link`" "`wpath $target`"
    # echo ${cmdslash}d "`wpath $link`" "`wpath $target`"
  else
    # cmd ${cmdslash}c del "`wpath $link`" > /dev/null 2>&1
    $mklink "`wpath $link`" "`wpath $target`"
    # echo "`wpath $link`" "`wpath $target`"
  fi
}

for file in `ls $curdir -A --ignore="*.md" --ignore="*.txt" --ignore="*.sh" --ignore=".git*"`
do
	if ! [ -e ~/$file ]
		then
		symlink "$curdir/$file" "$home/$file"
		# cmd link
	fi
done
unset link
unset file

source ~/.bash_profile
