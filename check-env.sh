#!/usr/bin/env bash
# check necessary environment  before you run lotus Damon
# This script is written according to the requirements of this web page
# link: https://docs.filecoin.io/get-started/lotus/installation/#running-in-the-cloud

#You can change this value by your choice. counted by Gb
recommendedLotusSpace=1024

#usage
function usage() {
  cat 1>&2 <<EOF
check mount point.
make sure you disk is available for the lotus daemon running.
Where do you store chain data.
just follow the directory to the script.

USAGE:
    ./check-disk.sh         <directory for lotus daemon>
EOF
}

#
function checkDisk() {
  # check drive type
  disk=$(df -Th "$1" | sed -n '2p' | awk '{print $1}' | sed 's/.$//')
  echo "Check if you are using solid state drive"
  isHdd=$(cat /sys/block/"${disk##*/}"/queue/rotational)
  if [ "${isHdd}" -eq 1 ]; then
    echo -e "\\033[31m you are using hdd which not suitable for the lotus daemon \033[0m"
  else
    echo "looks normal. you are using solid state drive"
  fi

  # check available space
  availableSpace=$(df -Th "$1" | awk '{print$5}' | sed -n '2p' | sed 's/.$//')
  if [ "$availableSpace" -lt "$recommendedLotusSpace" ]; then
    echo -e "\\033[31m Disk space is too small, it is recommended to use more than 1TB partition \033[0m"
  else
    echo "You have about ${availableSpace} gigabytes of space"
  fi

  # check write/read speed. need todo

}

function checkRam() {
  mem=$(free -g | awk '{print$2}' | sed -n 2p)
  if [ "${mem}" -lt 30 ]; then
    echo -e "\\033[31m The available memory space is not enough. It needs at least 32GB \033[0m"
  fi
}

function checkProcessor() {
  if grep sha_ni /proc/cpuinfo; then
    echo "cpu support sha extension"
  else
    echo -e "\033[33m cpu do not support sha extension \033[0m" # yellow font
  fi
  cpuCoreNum=$(grep -c processor /proc/cpuinfo)
  if [ "$cpuCoreNum" -lt 8 ]; then
    echo -e "\\033[31m It is recommended to run lotus daemon on a host with more than 8 cores \033[0m"
    echo -e "\\033[31m you only have $cpuCoreNum cores \033[0m"
  fi

}

function checkNetwork() {
  # need todo
  sleep 1
}

#print help info if args number not equal 1
if [ "$#" -ne 1 ]; then
  usage
  exit 2
else
  checkDisk $1
  checkRam
  checkNetwork
  checkProcessor
fi
