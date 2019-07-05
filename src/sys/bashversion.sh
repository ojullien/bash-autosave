## -----------------------------------------------------------------------------
## Linux Scripts.
## Bash version
##
## @package ojullien\Shell\sys
## @license MIT <https://github.com/ojullien/Shell/blob/master/LICENSE>
## -----------------------------------------------------------------------------

if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo -e "${COLORRED}At least Bash version 4 is needed!${COLORRESET}" >&2
    exit 4
fi
