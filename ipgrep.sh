
ipgrep() {
   perl -MNetAddr::IP -ne '
     BEGIN{$i=new NetAddr::IP(shift) or die;}
     $j=new NetAddr::IP($_) or next; print $_ if $i->within($j);
   ' "${1:?"Usage: $FUNCNAME cidr"}"
}

