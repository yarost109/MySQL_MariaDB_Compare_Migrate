
mysql -uroot -pxxxxxx backboxV3 e "SET FOREIGN_KEY_CHECKS=0;"

mysql -uroot -pxxxxxx backboxV3 -f < /data/dbcompare/tamut/DevOps_86vs87/scripts/commitChanges

mysql -uroot -pxxxxxx backboxV3 e "SET FOREIGN_KEY_CHECKS=1;"
