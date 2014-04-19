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
r(){ echo $((($(dd if=/dev/urandom bs=2 count=1 2>&-|hexdump|if read L;then echo 0x${L#* };fi) % $1)+1)); }
d(){
while :
do
x=$(r 39)
y=$(r 19)
[ "$(g $x $y)" = ' ' ] && {
p $x $y :
return 0
}
done
}
loop_get_userkey()
{
	local key
	while true; do {
		read -s -n1 key
		case "$key" in
			a) DIRECTION='l' ;;
			w) DIRECTION='u' ;;
			s) DIRECTION='d' ;;
			d) DIRECTION='r' ;;
		esac
		echo >L "$DIRECTION"
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
d
while :
do
s
[ -e L ] && {
read D <L
rm L
}
case $D in
r)X=$(($X+1));;
l)X=$(($X-1));;
d)Y=$(($Y+1));;
*)Y=$(($Y-1));;
esac
N="$(g $X $Y)"
if [ "$N" = \  -o "$N" = : ]
then
p $X $Y O
LIST_SNAKE="$LIST_SNAKE $X,$Y"
if [ "$N" = : ]
then
d
B=$(($B+1))
else
set -- $LIST_SNAKE
p ${1%,*} ${1#*,} ' '
shift
LIST_SNAKE="$@"
fi
else
exit 0
fi
done &
loop_get_userkey
