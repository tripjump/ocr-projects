#!/bin/bash
set -e

# === Configuration ===
CONTAINER_NAME="mongo_server"
DATA_FILE="./data/patients.csv"
DB_NAME="medical_data"
COLLECTION_NAME="patients"
MONGO_USER="admin"
MONGO_PASS="admin123"

echo "🚀 Démarrage du conteneur MongoDB..."
docker compose up -d

# Attente du démarrage complet de MongoDB
echo "⏳ Attente du démarrage de MongoDB..."
sleep 10

# Vérifie que le dataset existe
if [ ! -f "$DATA_FILE" ]; then
  echo "❌ Fichier introuvable : $DATA_FILE"
  exit 1
fi

# Importation du dataset CSV dans MongoDB
echo "📦 Importation des données dans MongoDB..."
docker exec -i $CONTAINER_NAME mongoimport \
  --username $MONGO_USER \
  --password $MONGO_PASS \
  --authenticationDatabase admin \
  --db $DB_NAME \
  --collection $COLLECTION_NAME \
  --type csv \
  --headerline \
  --drop \
  --file /data/patients.csv

echo "✅ Migration terminée avec succès !"
