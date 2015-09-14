#!bin/sh

usage () {
    echo "Usage: `basename $0` dbuser dbpwd dbschema calid kind email"
    echo "  dbuser: mysql db user"
    echo "  dbpwd: mysql db password"
    echo "  dbschema: mysql db schema"
    echo "  calid: owncloud calendar id"
    echo "  kind: 'weekly' or 'daily'"
    echo "  email: dest email"
    exit 0
}

if [ "$#" -lt 6 ]; then
    usage
fi

DBUSER=$1
DBPASSWD=$2
DBSCHEMA=$3
CALID=$4
KIND=$5
EMAIL=$6

if [ "$KIND" = "weekly" ]; then
    query="SELECT summary,startdate FROM oc_clndr_objects WHERE calendarid = $CALID AND startdate BETWEEN DATE(CURDATE()) AND DATE_SUB( CURDATE(), INTERVAL 6 DAY ) ORDER by startdate \G"
    mysql -u$DBUSER -p$DBPASSWD $DBSCHEMA -Bse "$query" >tmp_weekly.txt
    awk -f calweekly.awk tmp_weekly.txt >tmp_weekly.sh
    /bin/sh tmp_weekly.sh >tmp_weekly.mail
    mail -s "Planning hebdomadaire" $EMAIL <tmp_weekly.mail
else
    query="SELECT startdate,summary,calendardata FROM oc_clndr_objects WHERE calendarid = $CALID AND DATE(startdate) = DATE(NOW()) ORDER by startdate \G" 
    mysql -u$DBUSER -p$DBPASSWD $DBSCHEMA -Bse "$query" >tmp_daily.txt
    awk -f caldaily.awk tmp_daily.txt >tmp_daily.sh
    /bin/sh tmp_daily.sh $EMAIL
fi
