#!/bin/bash

# Configuration
CSV_FILE="./data/patients.csv"
DOCKER_CONTAINER="mongo_server"
MONGO_USER="admin"
MONGO_PASS="admin123"
MONGO_DB="medical_data"
MONGO_COLLECTION="patients"

echo "Checking MongoDB upload consistency..."
echo

# Count CSV lines (excluding header)
csv_count=$(tail -n +2 "$CSV_FILE" | wc -l)
echo "CSV rows (excluding header): $csv_count"

# Count MongoDB documents (suppress 'switched to db' line)
mongo_count=$(docker exec -i "$DOCKER_CONTAINER" \
    mongosh --quiet -u "$MONGO_USER" -p "$MONGO_PASS" \
    --eval "db.getSiblingDB('$MONGO_DB').$MONGO_COLLECTION.countDocuments()" \
    | tr -d '\r' | grep -Eo '^[0-9]+$')

echo "MongoDB documents in '$MONGO_COLLECTION': $mongo_count"

# Show one document (without the 'switched to db' line)
echo
echo "Example document from MongoDB:"
docker exec -i "$DOCKER_CONTAINER" \
    mongosh --quiet -u "$MONGO_USER" -p "$MONGO_PASS" \
    --eval "printjson(db.getSiblingDB('$MONGO_DB').$MONGO_COLLECTION.findOne())"

# Compare counts
echo
if [ -n "$mongo_count" ] && [ "$csv_count" -eq "$mongo_count" ]; then
    echo "✅ Data upload looks correct (counts match)"
else
    echo "⚠️ Counts do not match — please verify the upload"
fi
