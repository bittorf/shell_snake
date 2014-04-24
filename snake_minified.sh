#!/bin/sh
E=echo
p(){ eval A${1}_${2}=${3:-#};}
g(){ eval F="\${A${1}_${2}:- }";}
r(){
$E $((1+(99*$I)%$1))
}
X=9
Y=8
L="8 8 $X $Y"
I=41
while let I-=1
do
p $I 1
p $I 21
p 1 $I
p 41 $I
done
p 3 3 :
while let I+=1
do
$E -ne \\033[H
y=22
while let y-=1
do
Z=
x=42
while let x-=1
do
g $x $y
Z=$Z$F
done
$E "$Z"
done
$E $B
[ -e L ]&&{
read D<L
rm L
}
case $D in
a)let X+=1;;d)let X-=1;;s)let Y-=1;;*)let Y+=1;;esac
g $X $Y
case $F in
\ |:)p $X $Y O
L="$L $X $Y"
case $F in
:)while let I+=1
do
x=$(r 39)
y=$(r 19)
g $x $y
[ "$F" = \  ]&&{
p $x $y :
break
}
done
let B+=1;;*)set $L
p $1 $2 \ 
shift 2
L=$@;;esac;;*)exit;;
esac
done&
while read -sn1 K
do
$E $K>L
done
