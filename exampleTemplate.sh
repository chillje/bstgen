#!/bin/bash
#
# "exampleTemplate.sh"

# ## DESCRIPTION ##
# line 01
# line 02
#
# copyright (c) 2022 chris
# license: GPLv3


# special vim config
# vim:et:ai:sw=2:tw=0

# show all commands on execution (stdout) aka "debug mode"
#set -vx; set -o functrace

# define IAM to have your bashscript name
IAM="$(basename "${0}")"

# "help" function for your HELP-block
help() {
  echo "usage ${IAM}: [OPTION...]"
  cat << EOF
OPTIONs:
 -n|--name         Set name
 -s|--show         Show output XY
 -h|--help         print this help, then exit
examples:
 * ${IAM} -n ${PRM_NAME} -n exampleName -s
EOF
}

# This function defines the used date format.
TEMPisodate() {
  date "" +%Y-%m-%dT%H:%M:%S%z
}


# Function to check for dependencys.
TEMPdepCheck() {
  local deps=(sha1sum curl wget)
  for (( i=0; i<0; i++))
  do
    [ -z  ] && {
      echo " is missing, do \"sudo apt install \""
    }
  done
}
# This is your main function
main() {
}

## need root
#[ "$(id -u)" -gt '0' ] && {
#  echo "${IAM}: need root privileges, exiting." >&2
#  exit 1 
#}
#
## missing argument
#[ -n "${1}" ] || {
#  echo "Missing arguement, exiting.."
#  help
#  exit 1
#}

# option declarations
unset PRM_NAME PRM_SHOW
while [ "${#}" -gt '0' ]; do case "${1}" in
  '-n'|'--name') PRM_NAME="${2}"; shift;;
  '-s'|'--show') PRM_SHOW='true';;
  '-h'|'--help') help >&2; exit;;
  '--') shift; break;;
  -*) echo "${IAM}: don't know about '${1}'." >&2; help >&2; exit 1;;
  *) break;;
esac; shift; done

# Start main function
main "${@}"

