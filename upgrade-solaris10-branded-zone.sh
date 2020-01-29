#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o noclobber

cpuname=${1?:"Usage: $0 cpuname"}
cur=$(zfs get -H -o value com.oracle.zones.solaris10:activebe rpool/ROOT)
zfs_snap_name=rpool/ROOT/${cur}@${cpuname}
zfs_clone_name=rpool/ROOT/${cpuname}

declare -a _exit_handlers=()
atexit() {
  _exit_handlers+=("$@")
}
_exit() {
  for (( c = ${#_exit_handlers[@]} - 1; c >= 0; c-- )); do
    eval "${_exit_handlers[c]}" || true
  done
}
trap _exit EXIT

zfs snapshot $zfs_snap_name 
atexit "zfs destroy -f $zfs_snap_name"

zfs clone -o mountpoint=/a -o canmount=noauto $zfs_snap_name $zfs_clone_name
atexit "zfs destroy -f $zfs_clone_name"

zfs mount $zfs_clone_name
atexit "zfs unmount -f $zfs_clone_name"

cd /net/jumpstart/data/jump/patches/cpu/$cpuname
./installpatchset --apply-prereq --s10patchset
./installpatchset -R /a --s10patchset

until zfs unmount $zfs_clone_name; do sleep 1; done

zfs set mountpoint=/ $zfs_clone_name

zfs set com.oracle.zones.solaris10:activebe=$cpuname rpool/ROOT
atexit "zfs set com.oracle.zones.solaris10:activebe=$cur rpool/ROOT"

zfs promote $zfs_clone_name

# ok
trap "" EXIT

