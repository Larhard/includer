#!/bin/sh

basedir=$(dirname $(readlink -e "$0"))

function on_exit
{
	rm -rf "$in" "$out"
}

trap on_exit EXIT

function help
{
	echo "usage: $0 [OPTION]... [FILE]"
	echo
	echo "  -c, --clean           remove unresolved includes"
	echo "  -h, --help            help"
	echo "  -n, --repeat          number of recursive includes"
}

rep=1
infile="-"
clean=false

while [[ $# > 0 ]]
do
	key="$1"
	shift

	case "$key" in
		-c|--clean)
			clean=true
		;;
		-h|--help)
			help
			exit
		;;
		-n|--repeat)
			rep=$1
			shift
		;;
		*)
			infile="$key"
		;;
	esac
done

in=$(mktemp)
out=$(mktemp)

if (( rep <= 0 ))
then
	cat "$infile" > "$out"
else
	"$0" --repeat $(( rep - 1 )) "$infile" > "$in"
	"$basedir/scripts/include_1.sed" "$in" | "$basedir/scripts/include_2.sed" | sed -f - "$in" > "$out"
fi

if $clean
then
	cat "$out" > "$in"
	"$basedir/scripts/clean.sed" "$in" > "$out"
fi

cat "$out"
