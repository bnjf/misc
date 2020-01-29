
_encode() {
  typeset in="${1:?args}"
  typeset out=""
  typeset huff=(
    1110      101100    01000   11111       # a b c d
    011       00110     111100  0101        # e f g h
    1100      001011001 0010111 10111       # i j k l
    00111     1010      1101    101101      # m n o p
    001011010 1000      1001    000         # q r s t
    01001     001010    111101  001011011   # u v w x
    00100     001011000                     # y z
  )
  typeset -i i=0

  while (( i < ${#in} )); do
    out+="${huff[36#${in:i++:1} - 10]}";
  done

  echo "${out}"
}

_decode() {
  typeset d="${1:?args}"
  typeset out=""

  while [[ "$d" ]]; do
    d="${d/#000/t}"        d="${d/#011/e}"        d="${d/#0101/h}"       \
    d="${d/#1000/r}"       d="${d/#1001/s}"       d="${d/#1010/n}"       \
    d="${d/#1100/i}"       d="${d/#1101/o}"       d="${d/#1110/a}"       \
    d="${d/#00100/y}"      d="${d/#00110/f}"      d="${d/#00111/m}"      \
    d="${d/#01000/c}"      d="${d/#01001/u}"      d="${d/#10111/l}"      \
    d="${d/#11111/d}"      d="${d/#001010/v}"     d="${d/#101100/b}"     \
    d="${d/#101101/p}"     d="${d/#111100/g}"     d="${d/#111101/w}"     \
    d="${d/#0010111/k}"    d="${d/#001011000/z}"  d="${d/#001011001/j}"  \
    d="${d/#001011010/q}"  d="${d/#001011011/x}"

    out+="${d:0:1}"
    d="${d/#?/}"
  done

  echo "${out}"
}

