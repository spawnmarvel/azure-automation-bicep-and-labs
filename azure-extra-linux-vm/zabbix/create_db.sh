#!/bin/bash
echo 'Creating database'
# https://qirolab.com/snippets/91745c6b-e4b0-4c7f-846f-c00347bdc7d0
dbname='zabbix'
if [ -f /root/.my.cnf ]; then
 sudo mysql -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8mb4 collate utf8mb4_bin */;"
 echo "Database successfully created!"

else
 echo "Please enter root user MySQL password!"
 echo "Note: password will be hidden when typing"
 read -s rootpasswd
 echo "Creating new MySQL database..."
 sudo mysql -uroot -p${rootpasswd} -e "CREATE DATABASE ${dbname} /*\!40100 DEFAULT CHARACTER SET utf8mb4 collate utf8mb4_bin */;"
 echo "Database successfully created!"
fi

# mysql show character set like '%utf8%
# mysql use zabbix;
# mysql show variables like "character_set_database";
# mysql SELECT SCHEMA_NAME 'database', default_character_set_name 'charset', DEFAULT_COLLATION_NAME 'collation' FROM information_schema.SCHEMATA;