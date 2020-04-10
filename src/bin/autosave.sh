#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Simple tool for saving system logs and web logs into a timestamped bz2
## archive and sending it to a ftp server.
##
## @package ojullien\bash\bin
## @license MIT <https://github.com/ojullien/bash-autosave/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/src/bin
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/../sys/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources & configuration
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/runasroot.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/ftp.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/service.sh"
Config::load "manageservices"
Config::load "clean"
# shellcheck source=/dev/null
. "${m_DIR_APP}/clean/app.sh"
Config::load "autosave"
# shellcheck source=/dev/null
. "${m_DIR_APP}/autosave/app.sh"

## -----------------------------------------------------------------------------
## Help
## -----------------------------------------------------------------------------
((m_OPTION_SHOWHELP)) && Option::showHelp && exit 0

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
Constant::trace
ManageServices::trace
Clean::trace
AutoSave::trace

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Creates directories
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::removeDirectory "${m_AUTOSAVE_DIR_CACHE}"
FileSystem::createDirectory "${m_AUTOSAVE_DIR_CACHE}/${m_DATE}"
FileSystem::createDirectory "${m_AUTOSAVE_DIR_UPLOAD}"
Console::waitUser

## -----------------------------------------------------------------------------
## Disable & stop services
## -----------------------------------------------------------------------------
String::separateLine
Service::disableServices ${m_SERVICES_DISABLE}
String::separateLine
Service::stopServices ${m_SERVICES_STOP}
Console::waitUser

## -----------------------------------------------------------------------------
## Logwatch
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
AutoSave::watchLog "${m_LOGWATCH_FILE}"
Console::waitUser

## -----------------------------------------------------------------------------
## System: save
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::compressFile "${m_AUTOSAVE_DIR_CACHE}/${m_DATE}/log-${m_DATE}" "/var/log"
Console::waitUser

## -----------------------------------------------------------------------------
## System: clean and delete logs
## -----------------------------------------------------------------------------
String::separateLine
Clean::main
Console::waitUser

## -----------------------------------------------------------------------------
## Start services
## -----------------------------------------------------------------------------
String::separateLine
Service::startServices ${m_SERVICES_START}
Console::waitUser

## -----------------------------------------------------------------------------
## Save logs again
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
FileSystem::compressFile "${m_AUTOSAVE_DIR_CACHE}/${m_DATE}/$(uname -n)-start" "/var/log"
Console::waitUser

## -----------------------------------------------------------------------------
## Compressing
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Compressing ..."
cd "${m_AUTOSAVE_DIR_CACHE}" || exit 18
FileSystem::compressFile "${m_AUTOSAVE_DIR_UPLOAD}/${m_DATE}" "${m_DATE}"
cd ~- || exit 18
Console::waitUser

## -----------------------------------------------------------------------------
## Upload
## -----------------------------------------------------------------------------
String::separateLine
declare -i iReturn=1
String::notice "Uploading ..."
if [[ -f "${m_AUTOSAVE_DIR_UPLOAD}/${m_DATE}.tar.bz2" ]]; then
    if ((m_OPTION_LOG)); then
        FTP::verbosePut "${m_FTP_SRV}" "${m_FTP_USR}" "${m_FTP_PWD}" "${m_DATE}.tar.bz2" "." "${m_AUTOSAVE_DIR_UPLOAD}" "${m_FTPERR_FILE}" "${m_LOGFILE}"
        iReturn=$?
    else
        FTP::put "${m_FTP_SRV}" "${m_FTP_USR}" "${m_FTP_PWD}" "${m_DATE}.tar.bz2" "." "${m_AUTOSAVE_DIR_UPLOAD}" "${m_FTPERR_FILE}"
        iReturn=$?
    fi
    String::notice -n "FTP ${m_DATE}.tar.bz2:"
    String::checkReturnValueForTruthiness ${iReturn}
else
    String::error "NOK code: nothing to send or FTP mode is OFF"
    iReturn=0
fi
Console::waitUser

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
m_OPTION_LOG=0
if [[ -f ${m_LOGWATCH_FILE} ]]; then
    FileSystem::copyFile "${m_LOGWATCH_FILE}" "${m_AUTOSAVE_DIR_UPLOAD}"
fi
if [[ -f ${m_FTPERR_FILE} ]]; then
    FileSystem::copyFile "${m_FTPERR_FILE}" "${m_AUTOSAVE_DIR_UPLOAD}"
fi
if [[ -f ${m_LOGFILE} ]]; then
    mv "${m_LOGFILE}" "${m_AUTOSAVE_DIR_UPLOAD}"
fi

String::notice -n "Changing upload directory owner:"
chown -R "${m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER}":"${m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER}" "${m_AUTOSAVE_DIR_UPLOAD}"
iReturn=$?
String::checkReturnValueForTruthiness ${iReturn}

String::notice "Now is: $(date -R)"
exit ${iReturn}
