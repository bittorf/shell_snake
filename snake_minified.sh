#!/bin/sh
p(){ eval A${1}_${2}='$3'; }
g(){ eval echo -n "\"\${A${1}_${2}:- }\""; }
s(){
x=0
y=0
echo -ne \\033[H
while [ $y -lt 21 ]
do
y=$(($y+1))
while [ $x -lt 41 ]
do
x=$((x+1))
g $x $y
done
x=0
echo
done
echo $B
}
add_head()
{
	p $X $Y O
	LIST_SNAKE="$LIST_SNAKE $X,$Y"
}
remove_tail()
{
	set -- $LIST_SNAKE
	local x="${1%,*}"
	local y="${1#*,}"		# 8,3 -> 8 + 3
	p $x $y ' '
	shift
	LIST_SNAKE="$@"
}
random_int()
{
	local max="$1"
	local line
	local seed="$( dd if=/dev/urandom bs=2 count=1 2>&- | hexdump | if read line; then echo 0x${line#* }; fi )"
	echo $(( ($seed % $max) + 1 ))
}
drop_new_food()
{
	local field x y

	while true; do {
		x="$( random_int 39 )"
		y="$( random_int 19 )"
		field="$(g $x $y)"

		[ "$field" = ' ' ] && {
			p $x $y :
			return 0
		}
	} done
}

loop_get_userkey()
{
	local key
	while true; do {
		read -s -n1 key
		case "$key" in
			a) DIRECTION='left' ;;
			w) DIRECTION='up' ;;
			s) DIRECTION='down' ;;
			d) DIRECTION='right' ;;
		esac
		echo >"LAST_KEY" "$DIRECTION"
	} done
}

X=9
Y=8
LIST_SNAKE="9,9 $X,$Y"
B=0

for I in $(seq 2 40)
do
p $I 1 -
p $I 21 -
done
for I in $(seq 2 20)
do
p 1 $I +
p 41 $I +
done

drop_new_food

while true; do {
s

	[ -e "LAST_KEY" ] && {
		read DIRECTION <"LAST_KEY"
		rm "LAST_KEY"
	}

	case "$DIRECTION" in
		right) X=$(( $X + 1 )) ;;
		left)  X=$(( $X - 1 )) ;;
		down)  Y=$(( $Y + 1 )) ;;
		up|*)  Y=$(( $Y - 1 )) ;;
	esac

	NEXT_FIELD="$(g $X $Y)"
	if [ "$NEXT_FIELD" = ' ' -o "$NEXT_FIELD" = : ]; then
		add_head

		if [ "$NEXT_FIELD" = : ]; then
			drop_new_food
			B=$(($B+1))
		else
			remove_tail
		fi
	else
		echo "you are dead"
		exit 0
	fi
} done &
loop_get_userkey
