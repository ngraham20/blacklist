#!/usr/bin/env bash

function usage() {
cat << EOF
Usage: $0 [OPTIONS]
EOF
}

function header() {
    local title=$1
    local t_len=${#title}
    local size=50
    local pre_space_len=$((($size - $t_len)/2 - 1))
    local pre_space=$(printf "%-${pre_space_len}s" " ")
    local bar=$(printf "%-${size}s" "-")
    echo "${bar// /-}"
    echo "${pre_space// / }$title"
    echo "${bar// /-}"
    echo -e "$(date)\n"
}

function columnize() {
    local name=$1[@]
    local data=("${!name}")
    for value in "${data[@]}"; do
        printf "%-8s\n" "${value}"
    done | column
}
function list_categories() {
    # list blackarch groups
    header "Blackarch Categories"
    local output=$(pacman -Qg | grep blackarch- | awk '{print $1}' | sort | uniq -c)
    columnize output
}

function list_tools_in_category() {
    local category=$1
    local prefix="blackarch-"
    category=${category#"$prefix"}
    header "Blackarch $category Tools"
    local output=$(pacman -Qg | grep $prefix$category | awk '{print $2}' | sort)
    columnize output
}

if [ $# -eq 0 ]; then
    list_categories
    exit 0
fi

while getopts h option; do
    case "${option}"
        in
        h) usage; exit 0;;
    esac
done

list_tools_in_category $1