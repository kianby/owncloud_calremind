BEGIN {
    FS="\n";
    OFS="";
    ORS="\n";
    print "#!/bin/sh";
    print "#";
}
# blank lines
/^$/ {
    next;
}
# record header
$1 ~ /^\*\*\*\*/ {
    next;
}
# summary field
$1 ~ /^[ ]*summary\:/ {
    gsub(/\r/,"");
    idx = match($1, /summary\:(.*)/);
    print "SUMMARY=\"" substr($1, idx + 9) "\"";
    next;
}
# startdate field
$1 ~ /^[ ]*startdate\: / {
    match($1, /startdate\: /);
    print "STARTDATE=\"`date -d '" substr($1, RSTART + RLENGTH) "-000' '+%a %e %b %R'`\"";
    next;
}
# vcalendar start tag
$1 ~ /^[ ]*calendardata\: / {
    gsub(/\r/,"");
    match($1, /calendardata\: /);
    print "ICS=$(mktemp --suffix=.ics)";
    print "cat > \"${ICS}\" <<EOF";
    print substr($1, RSTART + RLENGTH);
    next;
}
# vcalendar end tag
$1 ~ /^END\:VCALENDAR/ {
    gsub(/\r/,"");
    print $1;
    print "EOF";
    print "mpack -s \"$SUMMARY - $STARTDATE\" \"${ICS}\" $1";
    print "#";
    next;
}
# vcalendar body
{
    gsub(/\r/,"");
    print $0;
}
