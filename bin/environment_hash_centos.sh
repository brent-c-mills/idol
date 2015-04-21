#!/bin/bash

set -e
completion() {
    echo "environment_hash_centos.sh has completed for idol "${IDOL_NAME} | tee -a ${CURRENT_LOG};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_environment_hash() {
    rm -f /tmp/environment_hash.txt && touch /tmp/environment_hash.txt;

    for i in "${ENV_COMPONENT[@]}"
    do
        sudo cat ${i} >> /tmp/environment_hash.txt;
        echo "" >> /tmp/environment_hash.txt;
        echo "" >> /tmp/environment_hash.txt;
    done

	local hashgolden=($(md5sum /tmp/environment_hash.txt));
    rm -f /tmp/environment_hash.txt;
	echo $hashgolden;
}

generate_environment_hash_bats() {
    echo "@test \"ENVIRONMENT CHECK - "${IDOL_NAME}" Environment HASH\" {" >> ${OUTPUT_BATS};
    echo "ENV_COMPONENT=( "${ENV_COMPONENT[@]}" )" >> ${OUTPUT_BATS};
    echo "for i in \"\${ENV_COMPONENT[@]}\"" >> ${OUTPUT_BATS};
    echo "do" >> ${OUTPUT_BATS};
    echo "sudo cat \${i} >> /tmp/environment_hash.txt" >> ${OUTPUT_BATS};
    echo "echo \"\" >> /tmp/environment_hash.txt" >> ${OUTPUT_BATS};
    echo "echo \"\" >> /tmp/environment_hash.txt" >> ${OUTPUT_BATS};
    echo "done" >> ${OUTPUT_BATS};
    echo "HASHCHECK=(\$(md5sum /tmp/environment_hash.txt))" >> ${OUTPUT_BATS};
    echo "[ \$HASHCHECK = ${HASHGOLDEN} ]" >> ${OUTPUT_BATS};
    echo "}" >> ${OUTPUT_BATS};
    echo " " >> ${OUTPUT_BATS};
}

handoff() {
    echo "environment_hash_centos.sh has been kicked off by idol_create.sh..." | tee -a ${CURRENT_LOG};
    echo "environment_hash_centos.sh is initiating hashed environment BATS creation..." | tee -a ${CURRENT_LOG};
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
##     INPUT AND VARIABLES     ##
#################################
HASH_BATS=$1;
IDOL_NAME=$2;
CURRENT_LOG=$3;

OUTPUT_BATS=${HASH_BATS}/environment_hash.bats;

ENV_COMPONENT=( "/etc/crontab" "/etc/shells" "/etc/fstab" "/etc/mtab" "/etc/rpc" "/etc/sestatus.conf" "/etc/nsswitch.conf" "/etc/profile" "/etc/protocols" "/etc/hosts.allow" "/etc/hosts.deny" "/etc/inittab" "/etc/yum.conf" "/etc/ssh/ssh_config" "/etc/sysconfig/authconfig" "/etc/sysconfig/grub" "/etc/yum.repos.d"/* );
    #Need to add back "/var/spool/cron"/* .  This wasn't working in the above array.

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##   GENERATE HASH AND BATS    ##
#################################
initialize_bats;
HASHGOLDEN=$(generate_environment_hash);
generate_environment_hash_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
