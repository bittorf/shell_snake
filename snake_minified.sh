#!/bin/sh
alias J=do T=let E=echo D=done W=while\ let
p(){ eval A$1x$2=${3:-#};}
g(){ eval F="\${A$1x$2:- }";}
r(){ E $((1+(99*$I)%$1));}
X=9 Y=8 L="8 8 $X $Y" I=41
W I-=1
J
p $I 1
p $I 21
p 1 $I
p 41 $I
D
p 3 3 :
>L
W I+=1
J
E -ne \\033[H
y=22
W y-=1
J
Z= x=42
W x-=1
J
g $x $y
Z=$Z$F
D
E "$Z"
D
E $B
. ./L
case $D in
a)T X+=1;;d)T X-=1;;s)T Y-=1;;*)T Y+=1;;esac
g $X $Y
case $F in
\ |:)p $X $Y O
L="$L $X $Y"
case $F in
:)W I+=1
J
x=$(r 39)
y=$(r 19)
g $x $y
[ "$F" = \  ]&&{
p $x $y :
break
}
D
T B+=1;;*)set $L
p $1 $2 \ 
shift 2
L=$@;;esac;;*).;;
esac
D&
while read -sn1 K
J
E D=$K>L
D
