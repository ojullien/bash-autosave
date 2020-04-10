## -----------------------------------------------------------------------------
## Linux Scripts.
## AutoSave app configuration file.
##
## @package ojullien\bash\app\autosave
## @license MIT <https://github.com/ojullien/bash-autosave/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/autosave/config.sh' file is not configured !!!"
String::error "The 'app/autosave/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## App Directories
## -----------------------------------------------------------------------------
readonly m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER="<user>" # you may want to update this line !

## -----------------------------------------------------------------------------
## App Directories
## -----------------------------------------------------------------------------

# Directory holds data to proceed
readonly m_AUTOSAVE_DIR_CACHE="/home/${m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER}/out/autosave/cache"
# Directory holds data to transfert
readonly m_AUTOSAVE_DIR_UPLOAD="/home/${m_AUTOSAVE_UPLOAD_DIRECTORY_OWNER}/out/autosave/upload"

## -----------------------------------------------------------------------------
## Files
## -----------------------------------------------------------------------------
readonly m_LOGWATCH_FILE="${m_AUTOSAVE_DIR_CACHE}/${m_DATE}/logwatch-${m_DATE}.txt"
readonly m_FTPERR_FILE="${m_AUTOSAVE_DIR_CACHE}/${m_DATE}/ftp-${m_DATE}.err"

## -----------------------------------------------------------------------------
## Ftp
## -----------------------------------------------------------------------------
readonly m_FTP_SRV="<server.domain.net>" # you may want to update this line !
readonly m_FTP_USR="<user>" # you may want to update this line !
readonly m_FTP_PWD="<***>" # you may want to update this line !

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
AutoSave::trace() {
    String::separateLine
    String::notice "App configuration: AutoSave"
    FileSystem::checkDir "\tCache directory:\t${m_AUTOSAVE_DIR_CACHE}" "${m_AUTOSAVE_DIR_CACHE}"
    FileSystem::checkDir "\tUpload directory:\t${m_AUTOSAVE_DIR_UPLOAD}" "${m_AUTOSAVE_DIR_UPLOAD}"
    FileSystem::checkFile "\tLogwatch file:\t\t${m_LOGWATCH_FILE}" "${m_LOGWATCH_FILE}"
    FileSystem::checkFile "\tFTP err file:\t\t${m_FTPERR_FILE}" "${m_FTPERR_FILE}"
    return 0
}
