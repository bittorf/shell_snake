#!/bin/sh

array_put()
{
	local x="$1"
	local y="$2"
	local char="$3"

	eval ARRAY_${x}_${y}='$char'
}

array_get()
{
	local x="$1"
	local y="$2"

	eval echo -n "\"\${ARRAY_${x}_${y}:- }\""
}

draw_border()
{
	local i

	for i in $( seq 2 $(( $PLAYFIELD_MAX_X - 1 )) ); do {
		array_put "$i"                '1' "—"
		array_put "$i" "$PLAYFIELD_MAX_Y" "—"
	} done

	for i in $( seq 2 $(( $PLAYFIELD_MAX_Y - 1 )) ); do {
		array_put                "1" "$i" "|"
		array_put "$PLAYFIELD_MAX_X" "$i" "|"
	} done
}

redraw_screen()
{
	local x=0
	local y=0

	echo -ne '\033[H'	# home position (0,0)

	while [ $y -lt $PLAYFIELD_MAX_Y ]; do {
		y=$(( $y + 1 ))
		while [ $x -lt $PLAYFIELD_MAX_X ]; do {
			x=$(( x + 1 ))
			array_get "$x" "$y"
		} done
		x=0
		echo
	} done

	echo "Points: $BONUS"
}

add_head()
{
	array_put "$X" "$Y" "$SNAKE"
	LIST_SNAKE="$LIST_SNAKE $X,$Y"
}

remove_tail()
{
	set -- $LIST_SNAKE
	local x="${1%,*}"
	local y="${1#*,}"		# 8,3 -> 8 + 3
	array_put "$x" "$y" ' '

	# shift list and loose last element = tail
	shift
	LIST_SNAKE="$@"
}

random_int()
{
	local max="$1"

	# a portable PRNG:
	# the initial seed is the size of our environment vars
	# on each iteration, we add user-entropy (e.g. pressed keys/moved fields)

	if [ -z "$SEED" ]; then
		SEED=$(set)
		SEED=${#SEED}
		ENTROPY=1
	else
		SEED=$(( $SEED * $SEED * $ENTROPY ))
	fi

	# greater then $FFFF?
	while [ ${#SEED} -gt 5 ]; do {
		SEED=$(( $SEED / 256 ))
	} done

        echo "$(( ($SEED % $max) + 1 ))"
}

drop_new_food()
{
	local field x y

	while true; do {
		x="$( random_int $(( $PLAYFIELD_MAX_X - 2 )) )"
		y="$( random_int $(( $PLAYFIELD_MAX_Y - 2 )) )"
		field="$( array_get "$x" "$y" )"

		[ "$field" = ' ' ] && {
			array_put "$x" "$y" "$FOOD"
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

		# TODO: dont write to file but use global var
		echo >"LAST_KEY" "$DIRECTION"
	} done
}

PLAYFIELD_MAX_X=41
PLAYFIELD_MAX_Y=21
X=9
Y=8
LIST_SNAKE="9,9 $X,$Y"

FOOD=':'
SNAKE='O'
BONUS=0

ENTROPY=1
I=0

draw_border
drop_new_food

while true; do {
	let I+=1
	redraw_screen

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

	# collision?
	NEXT_FIELD="$( array_get "$X" "$Y" )"
	if [ "$NEXT_FIELD" = ' ' -o "$NEXT_FIELD" = "$FOOD" ]; then
		add_head

		if [ "$NEXT_FIELD" = "$FOOD" ]; then
			BONUS=$(( $BONUS + 1 ))
			ENTROPY=$(( $ENTROPY + $BONUS + $I ))
			drop_new_food
		else
			remove_tail
		fi
	else
		echo "you are dead"
		exit 0
	fi
} done &

loop_get_userkey
