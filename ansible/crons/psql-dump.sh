# cat psql-ai-dev-backup.sh
# 54 0 * * * /home/user/cron/psql-backup.sh  # Run at 0:54 AM
#!/bin/bash
# TODO use k8s cron (Rancher) or inside VM (master node?); use S3 sync or something like this.
# Configuration
DB_HOST="192.168.1.225"
DB_USER="postgres"
export PGPASSWORD=""
BACKUP_DIR="/mnt/vm-storage/backups/psql"
EXCLUDE_DB="postgres|template0|template1|test_db" # DBs to skip
TIMESTAMP=$(date +%Y%m%d_%H%M)

mkdir -p "$BACKUP_DIR"

# 1. Cleanup: Remove files older than 30 days
find "$BACKUP_DIR" -name "*.dump" -type f -mtime +30 -delete
echo "Old backups cleaned."

# 2. Backup: Loop through all databases
# Get all non-template database names
DATABASES=$(psql -h "$DB_HOST" -U "$DB_USER" -At -c "SELECT datname FROM pg_database WHERE datistemplate = false;")

for DB in $DATABASES; do
    # Skip if the database is in the exclusion list
    if [[ "$DB" =~ ^($EXCLUDE_DB)$ ]]; then
        echo "Skipping $DB..."
        continue
    fi

    echo "Backing up $DB..."
    # -Fc: Custom format (compressed, flexible for pg_restore)
    # .dump already compressed (no need for zip)
    pg_dump -h "$DB_HOST" -U "$DB_USER" -Fc "$DB" > "$BACKUP_DIR/${DB}_${TIMESTAMP}.dump"
done

unset PGPASSWORD
echo "Backups saved to $BACKUP_DIR"
