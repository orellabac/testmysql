#!/bin/bash
# Optional variables for a backup script
MYSQL_USER="newuser"
MYSQL_PASS="password"
DB_HOST="localhost"
BACKUP_DIR=./output;
test -d "$BACKUP_DIR" || mkdir -p "$BACKUP_DIR"
# Get the database list, exclude information_schema
for db in $(mysql -B -s -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -e 'show databases' 2>/dev/null | grep -v information_schema)
do
    #export tables
    DIR="$BACKUP_DIR/$db/table"
    mkdir -p $DIR
    tbl_count=0
    GET_TABLES="SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA='$db' and  TABLE_TYPE LIKE 'BASE TABLE'"
    for t in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_TABLES" 2>/dev/null) 
    do 
        echo "DUMPING TABLE: $db.$t"
        echo "<sc-table> $db.$t </sc-table>" >  $BACKUP_DIR/$db/table/$t.sql
        mysqldump --no-data --skip-add-drop-table -h $DB_HOST -u $MYSQL_USER -p$MYSQL_PASS $db $t 2>/dev/null >> $BACKUP_DIR/$db/table/$t.sql
        tbl_count=$(( tbl_count + 1 ))
    done
    echo "$tbl_count tables dumped from database '$db' into dir=$DIR"
    #export views
    DIR="$BACKUP_DIR/$db/view"
    mkdir -p $DIR
    v_count=0
    GET_VIEW="SELECT TABLE_NAME FROM information_schema.tables WHERE TABLE_SCHEMA='$db' and  TABLE_TYPE LIKE 'VIEW'"
    for v in $(mysql -sN -h $DB_HOST -u $MYSQL_USER --password=$MYSQL_PASS -D $db -e "$GET_VIEW" 2>/dev/null) 
    do 
        echo "DUMPING VIEW: $db.$v"
        echo "<sc-view> $db.$v </sc-view>" >  $BACKUP_DIR/$db/view/$v.sql
        mysqldump --no-data  --skip-add-drop-table -h $DB_HOST -u $MYSQL_USER -p$MYSQL_PASS $db $v 2>/dev/null >> $BACKUP_DIR/$db/view/$v.sql
        v_count=$(( v_count + 1 ))
    done
    echo "$v_count views dumped from database '$db' into dir=$DIR"
done


SELECT routine_definition FROM information_schema.routines where ;