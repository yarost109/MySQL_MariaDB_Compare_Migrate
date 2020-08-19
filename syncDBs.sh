#!/bin/bash
cd /data/dbcompare/csv-to-html-table/data
rm -rf diff.csv
rm -rf /data/dbcompare/csv-to-html-table/data/86full.sql

mysqldump -uroot -pxxxxxx backboxV3 > 87beforeSync_`date +"%x-%T" | sed -e 's/-/_/g' -e 's/\//-/g' -e 's/:/-/g'`.sql
mysqldump -h172.31.255.86 -uroot -pxxxxxx backboxV3 > 86full.sql
mysql -uroot -pxxxxxx backboxV3 -f < 86full.sql
