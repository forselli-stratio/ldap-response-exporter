#!/bin/bash

function login_vault(){
  source /kms_utils.sh
  
  # Try logging in using dynamic authentication if vault token not defined.
  if [[ -z "$VAULT_TOKEN" ]]; then
      INFO "login using dynamic authentication with role_id: ${VAULT_ROLE_ID}"
      if ! login; then
          ERROR "login using dynamic authentication failed!"
          exit 1
      fi
  fi
}

# Configure Logging
function configure_logging(){
  #Import CentralizedLogging4bash functions
  source /b-log.sh
  
  #Set b-log level & set output to stdout
  export DOCKER_LOG_LEVEL=${DOCKER_LOG_LEVEL:-"INFO"}
  export LOGGING_TYPE=${LOGGING_TYPE:-"Centralized"}
  eval "LOG_LEVEL_${DOCKER_LOG_LEVEL}"
  B_LOG --stdout true
  
  case "$LOGGING_TYPE" in
   "CentralizedJSON")
      INFO "Applying Centralized Logging format with messages as JSON"
    ;;
   "Centralized")
      # Define template and recalculate LOG_LEVELS.
      # IMHO, this steps SHOULD be done by b-log.sh itself, maybe adding a new function to change template.
      B_LOG_DEFAULT_TEMPLATE="@1@ @2@ - 0 ${BASH_SOURCE[0]} @3@:@4@ @5@"
      LOG_LEVELS=(
          ${LOG_LEVEL_FATAL}  "FATAL"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_ERROR}  "ERROR"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_WARN}   "WARN"   "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_NOTICE} "NOTICE" "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_INFO}   "INFO"   "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_DEBUG}  "DEBUG"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_TRACE}  "TRACE"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
      )
      INFO "Applying Centralized Logging format"
    ;;
   "Development")
      # Define template and recalculate LOG_LEVELS.
      # IMHO, this steps SHOULD be done by b-log.sh itself, maybe adding a new function to change template.
      B_LOG_DEFAULT_TEMPLATE="@2@ | @1@ | ${BASH_SOURCE[0]}:@3@:@4@ | @5@"
      LOG_LEVELS=(
          ${LOG_LEVEL_FATAL}  "FATAL"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_ERROR}  "ERROR"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_WARN}   "WARN"   "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_NOTICE} "NOTICE" "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_INFO}   "INFO"   "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_DEBUG}  "DEBUG"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
          ${LOG_LEVEL_TRACE}  "TRACE"  "${B_LOG_DEFAULT_TEMPLATE}" "" ""
      )
      B_LOG_TS_FORMAT="%d-%m-%Y %H:%M:%S,%3N"
      WARN "Applying Development Logging format. USE IT AT YOUR OWN RISK OUTSIDE DEVELOPMENT PURPOSES!"
    ;;
   *)
      WARN "Invalid Logging Type: [${LOGGING_TYPE}]"
      INFO "Available types are: 'Centralized', 'CentralizedJSON' and 'Development' (last one, only for development purposes)"
      WARN "Applying Default format: Centralized Logging format with messages as JSON"
      export LOGGING_TYPE="CentralizedJSON"
    ;;
  esac
  
  INFO "Setting logging level to [${DOCKER_LOG_LEVEL}]"
}

export VAULT_HOSTS=$VAULT_HOST
export VAULT_PORT="${VAULT_PORT:-8200}" 

configure_logging

if [[ ! $VAULT_HOST ]]; then
  ERROR "Variable VAULT_HOST not provided!"
  exit 1
fi

login_vault



/usr/bin/python2.7 /ldap-response-exporter.py




getPass userland $SERVICE_ID keystore pass
#me descargo la password, tiene que estar en una carpeta dentro de /userland/passwords, en plan /userland/passwords/ldap-response-exporter/password{pass=XXXX}  
SERVICE_ID=${SERVICE_ID//[.-]/_}
TMP=${SERVICE_ID^^}_KEYSTORE_PASS
ROOT_PASS=${!TMP}
#hasta aqui, gestiono la password                                                    
echo "export ROOT_PASS=\"$(echo $ROOT_PASS)\"" >> /root/.bashrc  
bash