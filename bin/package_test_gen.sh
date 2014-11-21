#!/bin/bash

OUTPUT_DIR=~/bats_test_dir
OUTPUT_BATS=$OUTPUT_DIR/package.bats
FAIL_LIST=$OUTPUT_DIR/failed

PROCESSED=0
SUCCESS=0
FAIL=0

#Initialize output directories and files
mkdir -p $OUTPUT_DIR
rm -f FAIL_LIST
rm -f $OUTPUT_BATS

touch $OUTPUT_BATS
touch $FAIL_LIST


#Initialize .bats file

echo "#!/usr/bin/env bats" >> $OUTPUT_BATS
echo "" >> $OUTPUT_BATS
echo "load test_helper" >> $OUTPUT_BATS
echo "fixtures bats" >> $OUTPUT_BATS
echo "" >> $OUTPUT_BATS

while IFS=, read -r package; do

        PACKAGE=$package

        echo "@test \"SOFTWARE CHECK - "${PACKAGE}"\" {" >> $OUTPUT_BATS
        echo "rpm -qa | grep \""${PACKAGE}"\"" >> $OUTPUT_BATS
        echo "[ \$? -eq 0 ]" >> $OUTPUT_BATS
        echo "}" >> $OUTPUT_BATS
        echo " " >> $OUTPUT_BATS

        SUCCESS=$[SUCCESS + 1]
        PROCESSED=$[PROCESSED + 1]

done < $1

echo " ";
echo " ";
echo "  PROCESSED               SUCCESSFUL              FAILED";
echo "  "$PROCESSED"                    "$SUCCESS"                      "$FAIL" ";
echo " ";
echo " ";
echo "FAILED PACKAGES...";
cat $FAIL_LIST;
exit;

