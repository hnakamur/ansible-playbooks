#!/bin/sh

secret_file=/root/.mysql_secret
tmp_my_cnf=/root/.tmp.my.cnf
my_cnf=/root/.my.cnf

# hide from groups and others
umask 0077

# create $tmp_my_cnf with password specified with the last word in $secret_file
awk '
/^# The random password set for the root user/ {
  printf("[client]\n")
  printf("password=%s\n", $NF)
  printf("connect-expired-password\n")
}' $secret_file > $tmp_my_cnf

# We must use here documents so as that password cannot be seen in ps results.
# Do not echo password like:
# echo "SET PASSWORD FOR root@localhost=PASSWORD('${new_password}');" | mysql -uroot
#
# NOTE: You must pass --default-file before -u to mysql.
awk -F = '
/^password=/ {
  printf("SET PASSWORD FOR root@localhost=PASSWORD('\'%s\'');", $2)
}' $my_cnf | mysql --defaults-file=$tmp_my_cnf -uroot

rm $tmp_my_cnf
