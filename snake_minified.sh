#!/bin/sh
E=echo
S=$(set)
S=${#S}
T=1
p(){ eval A${1}_${2}='$3';}
g(){ eval F="\"\${A${1}_${2}:- }\"";}
s(){
$E -ne \\033[H
x=42
y=22
while let y-=1
do
Z=
while let x-=1
do
g $x $y
Z=$Z$F
done
x=42
$E "$Z"
done
$E $B
}
r(){
S=$(($S*$S*($T+$B+$I)))
while [ ${#S} -gt 5 ]
do
S=$(($S/256))
done
$E $((($S%$1)+1))
}
d(){
while :
do
x=$(r 39)
y=$(r 19)
g $x $y
[ "$F" = \  ]&&{
p $x $y :
return
}
done
}
X=9
Y=8
L=9,9\ $X,$Y
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
let I+=1
s
[ -e L ]&&{
read D<L
rm L
}
case $D in
a)let X+=1;;
d)let X-=1;;
w)let Y+=1;;
s)let Y-=1;;
esac
g $X $Y
if [ "$F" = \  -o "$F" = : ]
then
p $X $Y O
L="$L $X,$Y"
if [ "$F" = : ]
then
d
let B+=1
else
set $L
p ${1%,*} ${1#*,} \ 
shift
L="$@"
fi
else
exit
fi
done&
while :
do
read -sn1 K
$E $K>L
done
