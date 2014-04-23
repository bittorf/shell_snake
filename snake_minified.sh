#!/bin/sh
E=echo
p(){ eval A${1}_${2}=${3:-#};}
g(){ eval F="\${A${1}_${2}:- }";}
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
$E $((1+(99*$I)%$1))
}
d(){
while let I+=1
do
x=$(r 39)
y=$(r 19)
g $x $y
[ "$F" = \  ]&&{
p $x $y :
break
}
done
}
X=9
Y=8
L=8,8\ $X,$Y
I=41
while let I-=1
do
p $I 1
p $I 21
p 1 $I
p 41 $I
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
a)let X+=1;;d)let X-=1;;s)let Y-=1;;*)let Y+=1;;esac
g $X $Y
case $F in
\ |:)p $X $Y O
L="$L $X,$Y"
case $F in
:)d
let B+=1;;*)set $L
p ${1%,*} ${1#*,} \ 
shift
L=$@;;esac;;*)exit;;
esac
done&
while :
do
read -sn1 K
$E $K>L
done
