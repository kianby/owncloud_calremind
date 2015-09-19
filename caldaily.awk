BEGIN {
    FS="\n"
    OFS=""
    ORS="\n"
    print "#!/bin/sh"
    print " "
}
# blank lines
/^$/ { next }
# record header
$1 ~ /^\*\*\*\*/ {
    next
}
# summary field
$1 ~ /^[ ]*summary\:/ {
    gsub(/\r/,"");
    idx = match($1, /summary\:(.*)/)
    print "SUMMARY=\"" substr($1, idx + 9) "\""
    next
}
# startdate field
$1 ~ /^[ ]*startdate\: / {
    match($1, /startdate\: /)
    print "STARTDATE=\"`date -d '" substr($1, RSTART + RLENGTH) "-000' '+%a %e %b %R'`\""
    next
}
# vcalendar start tag
$1 ~ /^[ ]*calendardata\: / {
    gsub(/\r/,"");
    match($1, /calendardata\: /)
    print "echo \"" substr($1, RSTART + RLENGTH) "\" >event.ics"
    next
}
# vcalendar end tag
$1 ~ /^END\:VCALENDAR/ {
    gsub(/\r/,"");
    print "echo \"" $1 "\" >>event.ics"
    print "mpack -s \"$SUMMARY - $STARTDATE\" event.ics $1"
    print ""
    next
}
# vcalendar body
{
    gsub(/\r/,"");
    print "echo \"" $0 "\" >> event.ics"
}
