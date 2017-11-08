#!/bin/sh

# $1 : ci resource name
# $2 : project resource name

#pmd_cmd="-Xmx512m -jar /pmd-bin-4.2.6/lib/pmd-4.2.6.jar $2/ xml $RULE_PATH"
pmd_cmd="-Xmx512m -jar /pmd-bin-$VERSION/lib/pmd-$VERSION.jar $2/ xml $RULE_PATH"
pmd_err_word='<violation'
pmd_report_file='pmd_report.xml'
pmd_no_ruleset='Ruleset not found'

echo "RULE_PATH=$RULE_PATH=VERSION=$VERSION=pmd_cmd=$pmd_cmd="
echo "env...."
env

java $pmd_cmd | tee $pmd_report_file
cnt="$(grep -c $pmd_err_word $pmd_report_file)"
err_word_cnt=`grep -n "$pmd_no_ruleset" $pmd_report_file | wc -l`

if [ $err_word_cnt -gt 0 ]; then
	echo "$pmd_no_ruleset"
	exit 1
fi

if [ $cnt -gt 0 ]; then
	echo "pmd violation $cnt deteded"
        exit 1
else
        echo "pmd check success"
        exit 0
fi
