#!/bin/bash

/bin/tar -czP /var/rails/karate2/db/production.sqlite3 |/usr/bin/ssh freeshells 'cat > ~/karate/`/bin/date +%F`_db_backup.tar.gz'

