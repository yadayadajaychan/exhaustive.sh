#!/usr/bin/env bash

# exhaustive.sh creates an exhaustive list of all possible input values
# Copyright (C) 2024 Ethan Cheng
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

declare -a SIZE
declare -a NAME
declare -a MAX
declare -a VAL
CASES=1
N=0
for var in $@
do
	size=$(echo "$var" | grep -o -E '^[0-9]+')
	if [ -z $size ]
	then
		echo size required for \'$var\' >&2
		exit 1
	fi
	SIZE+=("$size")

	name=${var#$size}
	if [ -z $name ]
	then
		echo name required for \'$var\' >&2
		exit 1
	fi
	NAME+=("$name")

	max=$((2**size))
	MAX+=($max)

	VAL+=(0)

	CASES=$((CASES*max))
	N=$((N+1))
done

#echo ${SIZE[*]}
#echo ${NAME[*]}
#echo ${MAX[*]}
#echo ${VAL[*]}
#echo $CASES
#echo $N
count=0
n=$((N-1))

while [ $count -lt $CASES ]
do
	for i in $(seq 0 $n)
	do
		echo -n "${NAME[$i]}=${SIZE[$i]}'d${VAL[$i]}; "
	done
	echo \#10\;

	#echo ${VAL[*]}

	VAL[$n]=$((${VAL[$n]} + 1))
	for i in $(seq $n -1 0)
	do
		if [ ${VAL[$i]} -lt ${MAX[$i]} ]
		then
			break
		fi

		VAL[$i]=0
		VAL[$((i-1))]=$((${VAL[$((i-1))]} + 1))
	done

	count=$((count+1))
done
