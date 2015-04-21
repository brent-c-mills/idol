#!/bin/bash

set -e

completion() {
  echo "environment_full_darwin.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
  echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
  exit 0;
}

generate_environment_full_bats() {

  ENV_COMPONENT=( "/etc/shells" "/etc/hosts" "/etc/hosts.equiv" "/etc/paths" );
  
   for i in ${ENV_COMPONENT[@]}; do
    while read -r LINE || [[ -n $LINE ]]; do
      IFS=' ' read -a array <<< ${LINE};

      if [[ ${array[0]} ]] && [[ ! ${array[0]} =~ \# ]] && [[ ! ${LINE} =~ \[ ]] && [[ ! ${LINE} =~ \` ]] && [[ ! ${LINE} =~ 'UUID' ]]; then
        echo "@test \"ENVIRONMENT CHECK - "${array[0]}" Environment FULL\" {" >> ${OUTPUT_BATS};
        echo "grep '""${LINE}""' "${i} >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};
      fi;
    done < ${i};
  done;

}

handoff() {
  echo "environment_full_darwin.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
  echo "environment_full_darwin.sh is initiating full environment BATS creation..." | tee -a ${CURRENT_LOG};
  echo "idol name.................."${IDOL_NAME} | tee -a ${CURRENT_LOG};
  echo "" | tee -a ${CURRENT_LOG};
}

initialize_bats() {
  echo "#!/usr/bin/env bats" >> ${OUTPUT_BATS};
  echo "" >> ${OUTPUT_BATS};
  echo "load test_helper" >> ${OUTPUT_BATS};
  echo "fixtures bats" >> ${OUTPUT_BATS};
  echo "" >> ${OUTPUT_BATS};
}

#################################
##   INPUT AND VARIABLES   ##
#################################
HASH_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${HASH_BATS}/environment_full.bats;

#################################
##   ACKNOWLEDGE HANDOFF   ##
#################################
handoff;

#################################
##     CREATE BATS     ##
#################################
initialize_bats;
generate_environment_full_bats;

#################################
##   ACKNOWLEDGE COMPLETION  ##
#################################
completion;
