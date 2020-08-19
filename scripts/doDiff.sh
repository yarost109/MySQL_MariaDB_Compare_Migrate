cd /data/dbcompare/tamut/DevOps_86vs87
DIR=$RANDOM

mkdir -p $DIR
cd $DIR

mysqldump -uroot -pxxxxxx backboxV3 SESSIONS SESSIONCOMMANDS OPTIONS VERSIONS VENDORS PRODUCTS INTELLICHECKS_SIGNATURES TASKS OPTIONS_FOR_INTELLICHECKS_SIGNATURES > bb86.sql

mysql -uroot -pxxxxxx -e "DROP DATABASE bb86;"
mysql -uroot -pxxxxxx -e "CREATE DATABASE bb86;"
mysql -uroot -pxxxxxx bb86 -f < bb86.sql

mysqldbcompare --server1=root:xxxxxx@172.31.255.86:3306 --server2=root:xxxxxx@172.31.255.87:3306 backboxV3:bb86 --run-all-tests --changes-for=server2 --skip-checksum-table --skip-object-compare --skip-row-count --skip-diff --skip-table-options --difftype=sql | grep -v '^#' > commitChanges

echo 'ID}Type}Name' > /data/dbcompare/tamut/DevOps_86vs87/data/diff.csv
cat commitChanges | grep 'INSERT INTO `bb86`.`SESSIONCOMMANDS`' | grep -oh 'VALUES(.*' | cut -d',' -f2 | grep -oP "(?<=').*?(?=')" | sort | uniq | while read LINE; do mysql -h172.31.255.86 -uroot -pxxxxxx backboxV3 -ss -e "call SP__SESSION_INFO($LINE);"; done | sed 's/[!@#\$,%^&*<>"\/()|]//g' | awk '{print $1"} "$2" } "substr($0, index($0,$3))}' | sort | uniq | grep -v 'NULL' >> /data/dbcompare/tamut/DevOps_86vs87/data/diff.csv

cat commitChanges > /data/dbcompare/tamut/DevOps_86vs87/scripts/commitChanges

cat /data/dbcompare/tamut/DevOps_86vs87/data/diff.csv | grep -v '^ID' | cut -d'}' -f1 | while read SESSION; do mysql -uroot -pxxxxxx backboxV3 -ss -e "SELECT * FROM SESSIONCOMMANDS where SESSION_ID=$SESSION ORDER BY QUEUE;" | awk '{ print substr($0, index($0,$2)) }' > $SESSION-87.txt; mysql -h172.31.255.86 -uroot -pxxxxxx backboxV3 -ss -e "SELECT * FROM SESSIONCOMMANDS where SESSION_ID=$SESSION ORDER BY QUEUE;" | awk '{ print substr($0, index($0,$2)) }' > $SESSION-86.txt; diff -u $SESSION-87.txt $SESSION-86.txt | diff2html -s side -i stdin -o stdout | sed '/Diff to/d' > ../$SESSION.html; done
