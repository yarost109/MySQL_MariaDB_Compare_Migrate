#!/bin/bash
while true; do
cd /data/dbcompare/csv-to-html-table/data
rm -rf diff.csv
rm -rf /data/dbcompare/csv-to-html-table/data/87.sql
sshpass -p'xxxxxx' ssh -o StrictHostKeyChecking=no 172.31.255.86 'rm -rf /tmp/86.sql'
mysql -uroot -pxxxxxx backboxV3 -e "SELECT SESSION_ID,COMMAND FROM SESSIONCOMMANDS INTO OUTFILE '/data/dbcompare/csv-to-html-table/data/87.sql' FIELDS TERMINATED BY ',';"
mysql -h172.31.255.86 -uroot -pxxxxxx backboxV3 -e "SELECT SESSION_ID,COMMAND FROM SESSIONCOMMANDS INTO OUTFILE '/tmp/86.sql' FIELDS TERMINATED BY ',';"
sshpass -p'xxxxxx' scp -o StrictHostKeyChecking=no 172.31.255.86:/tmp/86.sql .
sed -i 's/,//2g' 86.sql
sed -i 's/,//2g' 87.sql
diff -y <(sort 86.sql) <(sort 87.sql) --width=400 --suppress-common-lines | sed -e 's/</,NA,NA/g' -e 's/>/NA,NA,/g' -e 's/|/,/g' >> diff.csv
cat diff.csv | grep -v OperationT | while read LINE; do SESSIONID=$(echo $LINE | cut -d',' -f1); TYPE=$(mysql -h172.31.255.86 -uroot -pxxxxxx backboxV3 -ss -e "call SP__SESSION_INFO($SESSIONID);" | awk '{print $2}'); NAME=$(mysql -h172.31.255.86 -uroot -pxxxxxx backboxV3 -ss -e "call SP__SESSION_INFO($SESSIONID);" | awk '{ print substr($0, index($0,$3)) }' | sed 's/[!@#\$%^&*<>"\/()|]//g'); CHANGE=$(echo $LINE | cut -d',' -f2); C87=$(echo $LINE | rev | cut -d',' -f1 | rev); echo $TYPE\($SESSIONID\),$NAME,$CHANGE,$C87; done > tempcsv; echo 'OperationType,Name,86,87' > /data/dbcompare/csv-to-html-table/data/diff.csv; cat tempcsv >> diff.csv
sleep 10
done
