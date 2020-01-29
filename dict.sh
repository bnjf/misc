
# integers aren't bitstrings, leading zeroes aren't special.  hack is to prefix
# everything with a 1.
_encode_letters() {
    sed '
/[^a-z]/d
s/$/#a1110b101100c01000d11111e011f00110g111100h0101i1100j001011001k0010111/
s/$/l10111m00111n1010o1101p101101q001011010r1000s1001t000u01001v001010/
s/$/w111101x001011011y00100z001011000/
:a
s/\([a-z]\)\(.*\)\(#.*\1\([01]\{1,\}\).*\)/\4\2\3/g
t a
s/#.*//
# hack hack hack
s/^/1/
'
}

# accompanying decoder
_decode_letters() {
    sed '
s/^/1//
:a
s/^\([^01]*\)000/\1t/;ta
s/^\([^01]*\)00100/\1y/;ta
s/^\([^01]*\)001010/\1v/;ta
s/^\([^01]*\)001011000/\1z/;ta
s/^\([^01]*\)001011001/\1j/;ta
s/^\([^01]*\)001011010/\1q/;ta
s/^\([^01]*\)001011011/\1x/;ta
s/^\([^01]*\)0010111/\1k/;ta
s/^\([^01]*\)00110/\1f/;ta
s/^\([^01]*\)00111/\1m/;ta
s/^\([^01]*\)01000/\1c/;ta
s/^\([^01]*\)01001/\1u/;ta
s/^\([^01]*\)0101/\1h/;ta
s/^\([^01]*\)011/\1e/;ta
s/^\([^01]*\)1000/\1r/;ta
s/^\([^01]*\)1001/\1s/;ta
s/^\([^01]*\)1010/\1n/;ta
s/^\([^01]*\)101100/\1b/;ta
s/^\([^01]*\)101101/\1p/;ta
s/^\([^01]*\)10111/\1l/;ta
s/^\([^01]*\)1100/\1i/;ta
s/^\([^01]*\)1101/\1o/;ta
s/^\([^01]*\)1110/\1a/;ta
s/^\([^01]*\)111100/\1g/;ta
s/^\([^01]*\)111101/\1w/;ta
s/^\([^01]*\)11111/\1d/;ta
'
}

dict_init() {
    unset _DICT
    export _DICT
}

dict_put() {
    local k="$1"; shift
    local c="$(echo "$k" | _encode_letters)"
    local -i h="$(( 2#$c ))"
    (( h > 0 )) || { echo "dict_put: bogus key [$k]" >&2; return 1; }
    _DICT[$h]="$k:$@"
}

dict_get() {
    local k="$1"
    local c="$(echo "$k" | _encode_letters)"
    local -i h="$(( 2#$c ))"
    [ "${_DICT[$h]:-}" ] || {
        echo "dict_get: no such key [$k]" >&2
        return 1
    }
    echo "${_DICT[$h]#*:}"
}

dict_keys() {
    local K
    for K in "${_DICT[@]}"; do
        echo ${K%%:*}
    done
}

