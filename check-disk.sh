#!/usr/bin/env bash
# check necessary environment  before you run lotus Damon

usage() {
    cat 1>&2 <<EOF
check mount point, make sure you disk is available for the lotus daemon running

USAGE:
    ./check-disk.sh <directory for lotus daemon>
EOF
}

usage