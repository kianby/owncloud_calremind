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
    idx = match($1, /summary\:(.*)/)
    print "SUMMARY=\"" substr($1, idx + 9) "\""
    next
}
# startdate field
$1 ~ /^[ ]*startdate\: / {
    match($1, /startdate\: /)
    print "STARTDATE=\"`date -d '" substr($1, RSTART + RLENGTH) "-000' '+%a %e %b %R'`\""
    print "echo \"$SUMMARY - $STARTDATE\""
    next
}
