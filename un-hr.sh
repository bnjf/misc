#!/bin/ksh

# vim:ts=2 sts=2 sw=2 et ai fdm=marker:

set -eu

unhr() {
  typeset -i num
  typeset -l suf

  typeset -i m_k m_m m_g m_t
  let 'm_k=1024' 'm_m=m_k*1024' 'm_g=m_m*1024' 'm_t=m_g*1024'

  # guard it in a subshell
  (num="${1%%[kmgtKMGT]*}") || return 1
  num="${1%%[kmgtKMGT]*}"
  suf="${1#$num}"

  # strip b
  case "$suf" in
  [kmgt]b)  suf="${suf%b}" ;;
  esac

  case "$suf" in
  [kmgt])
    echo $(( num * m_$suf )) ;;
  '')
    echo "$num"  ;;
  *)
    echo "bogus suffix" >&2
    return 1 ;;
  esac

  return 0
}

set -- 55 55k 55kb 55m 55mb 55g 55gb 55t 55tb a55 a55k 55a 55ka 55K \
  55KB 55M 55MB 55G 55GB 55T 55TB A55 A55K 55A 55KA

while (( $# )); do
  echo "$1: $(unhr "$1" 2>/dev/null || echo '(nil)')"
  shift
done

