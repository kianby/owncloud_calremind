# owncloud_calremind

**calremind** sends e-mail reminder about incoming calendar events.

Prerequisites:

- Owncloud uses MySQL database
- *awk* and *mpack* are installed

Usage:

- Send a reminder for next 7 days 

    calremind.sh <dbuser> <dbpwd> <db> <cal id> weekly <dest email>

- Send a reminder for today

    calremind.sh <dbuser> <dbpwd> <db> <cal id> daily <dest email>

