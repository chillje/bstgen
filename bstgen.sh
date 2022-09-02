#!/bin/bash
#
# bstgen.sh
# ## DESCRIPTION ##
# This is a very smal script to creat a new "bash-script.sh"
# template for your new bash script.
# This will hopefully save some time for your new project.
#
# copyright (c) 2022 chris <christoph.hillje@gmail.com>
# license: GPL version 3


# special vim config
# vim:et:ai:sw=2:tw=0

# show all commands on execution (stdout) aka "debug mode"
#set -vx; set -o functrace

# set options
# -e | stop after error
# -u | stop for unbound variables
# -o pipefail | stop if a command not found
#set -eo pipefail

# define IAM to have your bashscript name
IAM="$(basename "${0}")"

# "help" function for your HELP-block
help() {
  echo "usage ${IAM}: [OPTION...]"
  cat <<EOF
OPTIONs:
 -n|--name         Set name for the new script
 -y|--year         Add creation year to header
 -o|--owner        Add owner block to header
 -l|--license      Add license like "GPLv3" to header
 -d|--description  Add description block to header
 -f|--function     Add dummy function
 -h|--help         print this help, then exit
examples:
 * ${IAM} -n new-bashscript.sh -o chris
EOF
}

description() {
  [ -e "${PRM_NAME}" ] && {
    cat <<EOF >> "${PRM_NAME}"
# ## DESCRIPTION ##
# line 01
# line 02
#
EOF
}
}

ownerBlock() {
  [ -e "${PRM_NAME}" ] && {
    echo "# copyright (c) ${PRM_YEAR} ${PRM_OWNER}" >> "${PRM_NAME}"
  }
}

licenseBlock() {
  [ -e "${PRM_NAME}" ] && {
    echo "# license: ${PRM_LICENSE}" >> "${PRM_NAME}"
  }
}

dummyFunction() {
  [ -e "${PRM_NAME}" ] && {
    cat <<EOF >> "${PRM_NAME}"
# This function defines the used date format.
TEMPisodate() {
  date "${@}" +%Y-%m-%dT%H:%M:%S%z
}


# Function to check for dependencys.
TEMPdepCheck() {
  local deps=(sha1sum curl wget)
  for (( i=0; i<${#deps[@]}; i++))
  do
    [ -z $(command -v ${deps[$i]}) ] && {
      echo "${deps[$i]} is missing, do \"sudo apt install ${deps[$i]}\""
    }
  done
}
EOF
}
}


# This is your main function
main() {

  # if "PRM_NAME" not set, define default bash script name
  [ -z "${PRM_NAME}" ] && PRM_NAME="someNewScript.sh"

  # exit if file already exists
  [ -e "${PRM_NAME}" ] && { 
    echo "File ${PRM_NAME} already exists, exiting.."
    exit 1
  }

  # header of the new script file
  cat <<EOFA >> "${PRM_NAME}"
#!/bin/bash
#
# "${PRM_NAME}"

EOFA

  # add description
  [ -n "${PRM_DESCRIPTION}" ] && description

  # add ownerBlock
  [ -n "${PRM_OWNER}" ] && ownerBlock

  # add licenseBlock
  [ -n "${PRM_LICENSE}" ] && licenseBlock

  # special lines and help function of the new script file
  # this EOF will print the VAR instead of the values of VARs
  cat <<'EOFB' >> "${PRM_NAME}"


# special vim config
# vim:et:ai:sw=2:tw=0

# show all commands on execution (stdout) aka "debug mode"
#set -vx; set -o functrace

# set options
# -e | stop after error
# -u | stop for unbound variables
# -o pipefail | stop if a command not found
#set -eo pipefail

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

EOFB

  # add dummyFunction
  [ -n "${PRM_FUNCTION}" ] && dummyFunction


  # end block for the new script with optional "need root"
  # and "missing argument" validation
  cat <<'EOFC' >> "${PRM_NAME}"
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

EOFC

  [ -e "${PRM_NAME}" ] && {
    echo "New template for bash script "${PRM_NAME}" created."
  } || {
    echo "Something went wrong, exiting.."
    exit 1
  }
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
unset PRM_NAME PRM_YEAR PRM_OWNER PRM_LICENSE PRM_DESCRIPTION PRM_FUNCTION
while [ "${#}" -gt '0' ]; do case "${1}" in
  '-n'|'--name') PRM_NAME="${2}"; shift;;
  '-y'|'--year') PRM_YEAR="${2}"; shift;;
  '-o'|'--owner') PRM_OWNER="${2}"; shift;;
  '-l'|'--license') PRM_LICENSE="${2}"; shift;;
  '-d'|'--description') PRM_DESCRIPTION='true';;
  '-f'|'--function') PRM_FUNCTION='true';;
  '-h'|'--help') help >&2; exit;;
  '--') shift; break;;
  -*) echo "${IAM}: don't know about '${1}'." >&2; help >&2; exit 1;;
  *) break;;
esac; shift; done

# Start main function (if an parameter is given)
main "${@}"

