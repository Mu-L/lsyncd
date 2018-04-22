##
# signames.sh from Lsyncd -- the Live (Mirror) Syncing Demon
#
# Creates a .lua file for all signal names understood by the kill command
# on the system Lsyncd is being compiled for.
#
# License: GPLv2 (see COPYING) or any later version
# Authors: Axel Kittenberger <axkibe@gmail.com>
#
KILL=/bin/kill

if [ "$#" -ne 1 ];
then
	echo >&2 "$0 needs excatly one argument -- the lua file to create"
	exit 1
fi

echo "-- This file is autogenerated by $0 querying `$KILL --version`" > $1
echo "siglist =" >> $1
echo "{" >> $1

n=1
while name=`kill -l $n 2>/dev/null`;
do
	if [[ $name ]]
	then
		echo -e "\t[ $n ] = '$name'," >> $1
	fi
	n=$(( n + 1 ))
done

echo "}" >> $1