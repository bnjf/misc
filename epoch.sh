#!/bin/ksh

# vim:set ts=2 sts=2 sw=2 et ai fdm:marker:

# see "Algorithm 199" for more info

toepoch() {
  local -i Y=10#${1:?} m=10#${2:?} d=10#${3:?} H=10#${4:?} M=10#${5:?} S=10#${6:?}

  if ((m > 2)); then
    let m-=3
  else
    let m+=9
    let --Y
  fi

  local -i c='Y / 100'
  local -i ya='Y - 100 * c'

  local -i j='
    (146097 * c)  / 4 +
    (1461 * ya)   / 4 +
    (153 * m + 2) / 5 +
    d'
  local -i result='((j - 719469) * 86400) + (H * 3600) + (M * 60) + S'

  echo $result
}

fromepoch() {
  local -i s="${1:?missing epoch}"
  local -i j y m d

  let j="s / 86400 + 719469"
  let s="s % 86400"

  let y="(4 * j - 1) / 146097"
  let j="4 * j - 1 - 146097 * y"
  let d="j / 4"
  let j="(4 * d + 3) / 1461"
  let d="4 * d + 3 - 1461 * j"
  let d="(d + 4) / 4"
  let m="(5 * d - 3) / 153"
  let d="5 * d - 3 - 153 * m"
  let d="(d + 5) / 5"
  let y="100 * y + j"
  if ((m < 10)); then
    let m+=3
  else
    let m-=9
    let ++y
  fi

  printf '%.4d-%.2d-%.2d %.2d:%.2d:%.2d\n' $y $m $d $((s/3600)) $(((s/60)%60)) $((s%60))
}

