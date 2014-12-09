#!/bin/bash

set -e

completion() {
    echo "chef_full_darwin.sh has completed for idol "${IDOL_NAME} | tee -a ${LOG_OUT};
    echo "Bats Tests Generated: "$(grep -c "@test" ${OUTPUT_BATS});
    exit 0;
}

generate_chef_cookbook_bats() {
    while IFS=, read -r cookbook; do

        COOKBOOK=${cookbook};

        echo "Adding chef_full test for cookbook "${COOKBOOK} >> ${LOG_OUT};
        echo "@test \"CHEF CHECK - cookbook "${COOKBOOK}"\" {" >> ${OUTPUT_BATS};
        echo "grep '""${COOKBOOK}""' "${COOKBOOKS} >> ${OUTPUT_BATS};
        echo "[ \$? -eq 0 ]" >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};

    done < /tmp/chef_cookbook_full.txt;
    rm -f /tmp/chef_cookbook_full.txt;
}

generate_chef_recipe_bats() {
    while IFS=, read -r recipe; do

        RECIPE=${recipe};

        echo "Adding chef_full test for recipe "${RECIPE} >> ${LOG_OUT};
        echo "@test \"CHEF CHECK - recipe "${RECIPE}"\" {" >> ${OUTPUT_BATS};
        echo "grep '""${RECIPE}""' "${RECIPES} >> ${OUTPUT_BATS};
        echo "[ \$? -eq 0 ]" >> ${OUTPUT_BATS};
        echo "}" >> ${OUTPUT_BATS};
        echo " " >> ${OUTPUT_BATS};

    done < /tmp/chef_recipe_full.txt;
    rm -f /tmp/chef_recipe_full.txt;
}

generate_chef_cookbook_list() {
    rm -f /tmp/chef_cookbook_full.txt && touch /tmp/chef_cookbook_full.txt;
    knife cookbook list >> /tmp/chef_cookbook_full.txt;
}

generate_chef_recipe_list() {
    rm -f /tmp/chef_recipe_full.txt && touch /tmp/chef_recipe_full.txt;
    knife recipe list >> /tmp/chef_recipe_full.txt;
}

handoff() {
    echo "chef_full_darwin.sh has been kicked off by idol_create.sh..." | tee -a ${LOG_OUT};
    echo "chef_full_darwin.sh is initiating full chef BATS creation..." | tee -a ${LOG_OUT};
    echo "idol name.................."${IDOL_NAME} | tee -a ${LOG_OUT};
    echo "" | tee -a ${LOG_OUT};
}

initialize_bats() {
    echo "#!/usr/bin/env bats" >> ${OUTPUT_BATS};
    echo "" >> ${OUTPUT_BATS};
    echo "load test_helper" >> ${OUTPUT_BATS};
    echo "fixtures bats" >> ${OUTPUT_BATS};
    echo "" >> ${OUTPUT_BATS};
    echo "rm -f "${COOKBOOKS}" && touch "${COOKBOOKS} >> ${OUTPUT_BATS};
    echo "rm -f "${RECIPES}" && touch "${RECIPES} >> ${OUTPUT_BATS};
}

skip() {
    echo "Chef is not installed on this system." | tee -a ${LOG_OUT};
    exit 0;
}

verify_chef() {
    if [[ ! $(chef -v 2> /dev/null) ]]; then
        skip;
    fi
}

#################################
##     INPUT AND VARIABLES     ##
#################################
FULL_BATS=$1;
IDOL_NAME=$2;
LOG_OUT=$3;
COOKBOOKS=/tmp/chef_cookbook.txt
RECIPES=/tmp/chef_recipes.txt

OUTPUT_BATS=${FULL_BATS}/chef_full.bats;

#################################
##     ACKNOWLEDGE HANDOFF     ##
#################################
handoff;

#################################
##  VERIFY CHEF INSTALLATION   ##
#################################
verify_chef;

#################################
##         CREATE BATS         ##
#################################
initialize_bats;
generate_chef_cookbook_list;
generate_chef_cookbook_bats;
generate_chef_recipe_list;
generate_chef_recipe_bats;

#################################
##   ACKNOWLEDGE COMPLETION    ##
#################################
completion;
