#!/bin/bash
count=0

trap call_SIGHUP SIGHUP
trap call_EXIT SIGINT SIGTERM SIGQUIT EXIT

call_SIGHUP() {
  count=0
  exec 3>&-
  exec 4<&-
  [[ -e "${filename}" ]] && mv "${filename}" "${filename}.$(date +%Y-%m-%d_%H:%M:%S)" 
  exec 3>"${filename}"
  exec 4<"${filename}"
  return 0
}

call_EXIT() {
  exec 3>&- &>/dev/null
  exec 4<&- &>/dev/null
  exit 0
}

[[ "${1}" != "" ]] && {
  filename="${1}"
} || {
  filename="log.log"
}

[[ -e "${filename}" ]] && { echo "$filename already exists." ; mv "${filename}" "${filename}.$(date +%Y-%m-%d_%H:%M:%S)";}

exec 3>"${filename}"
exec 4<"${filename}"

while true
do {
  echo ${count} >&3
  read -u 4 line
  echo ${line}
  ((count++))
  sleep 1
} done
