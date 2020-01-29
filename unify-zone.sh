#!/bin/bash

set -eu

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

get_package_names() {
  pkginfo | awk '{print $2}' #| grep '^SUNW'
}
get_package_names_in_zone() {
  zlogin "${1:?missing arg}" 'pkginfo | awk '\''{print $2}'\'' #| grep '\''^SUNW'\'''
}

[[ $(zonename) == "global" ]] || { echo "zonename isn't global" >&2; exit 1; }

target_zone="${1:?Usage: $0 target-zone}"
tmp_dir="$(mktemp -d)"
[[ "$tmp_dir" ]] || { echo "problem with mktemp" >&2; exit 1; }
cd "$tmp_dir"

get_package_names_in_zone "$target_zone" | xargs touch
mkdir .ok
get_package_names | xargs -i mv {} .ok

# dangling packages remaining
to_remove=$(
for pkg in *
do
  # grab deps
  zlogin "$target_zone" '
    nawk -v pkg='"$pkg"' '\''
$1 == "P" { print pkg, $2 }
$1 == "R" { print $2, pkg }'\'' /var/sadm/pkg/'"$pkg"'/install/depend || echo '"$pkg"' '"$pkg"''
done | tsort)

zlogin "$target_zone" 'sed "s/^action=.*/action=nocheck/" /var/sadm/install/admin/default > /var/sadm/install/admin/default.nocheck'
for pkg in $to_remove
do
  if [[ -f "$pkg" ]]
  then
    echo "=== removing $pkg from $target_zone"
    if zlogin "$target_zone" "pkgrm -a /var/sadm/install/admin/default.nocheck -n '$pkg'"
    then
      echo "=== removed $pkg from $target_zone"
    else
      echo "=== failed to remove $pkg from $target_zone"
    fi
  fi
done

