#!/bin/sh 

findbugs_cmd="-Xmx512m -jar /findbugs-$VERSION/lib/findbugs.jar -textui "
findbugs_report_file='findbugs_report.html'
findbugs_err_word='Warnings generated: '
findbugs_err_not_found='File not found: '

# findbugs execute
java $findbugs_cmd $1 2>&1 | tee $findbugs_report_file

# keyword find & ...
#echo '..... ls -os '
#ls -os

#echo '..... cat $findbugs_report_file'
#cat $findbugs_report_file 

err_word_cnt=`grep -n "$findbugs_err_word" $findbugs_report_file | wc -l`
bug_cnt=`cat $findbugs_report_file | grep -n "$findbugs_err_word" | awk -F "$findbugs_err_word" '{print $2}'`
line_cnt=`cat $findbugs_report_file | wc -l`

#echo "bug_cnt=$bug_cnt=($findbugs_report_file)line_cnt=$line_cnt"

not_found_cnt=`grep -n "$findbugs_err_not_found" $findbugs_report_file | wc -l`
#echo "not_found_cnt=$not_found_cnt="

if [ $not_found_cnt -gt 0 ]; then
	echo "findbugs check fail"
	exit 1
fi

if [ $err_word_cnt -ne 0 ]; then

	if [ $bug_cnt -gt 0 ]; then
		echo "findbugs warnings $bug_cnt detected"
        	exit 1
	else
	        echo "findbugs check success"
        	exit 0
	fi

else
	echo "findbugs check success"
	exit 0
	
fi
