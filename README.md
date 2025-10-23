# Maintenez et documentez un système de stockage des données sécurisé et performant

## Contexte

* Entreprise : **DataSoluTech**
    * Fournisseur de services informatiques pour les entreprises
    * Aide les entreprises à trouver des solutions pour gérer leurs données éfficacement

* Stagiaire Data Engineer

* Context:
Migration de données médicales d’un dataset CSV vers MongoDB dans un environnement Dockerisé.


## 1. Automatisation de l'import des données dans MongoDb:
Automatiser l’importation des données pour améliorer la scalabilité et la performance du système de stockage.
Pour cela un script bash migrate_to_mongo.sh est fourni.

Ce projet automatise la migration d’un jeu de données CSV (`patients.csv`) vers une base de données MongoDB hébergée dans un conteneur Docker.


### Fonctionnement

1. **Docker Compose** lance MongoDB dans un conteneur.
2. Le script **migrate_to_mongo.sh** :
   - attend que MongoDB démarre ;
   - utilise `mongoimport` pour insérer les données du CSV dans la collection `patients`.

### Schéma de la base de données

**Base :** `medical_data`  
**Collection :** `patients`


Champ	            Type	      Description
_id	                ObjectId	  Identifiant unique MongoDB
Name	            string	      Nom complet du patient
Age	                int	          Âge du patient
Gender	            string	      Sexe du patient
Blood Type	        string	      Groupe sanguin
Medical Condition	string	      Diagnostic principal
Date of Admission	date	      Date d’admission
Doctor	            string	      Médecin responsable
Hospital	        string	      Établissement hospitalier
Insurance Provider	string	      Assurance maladie
Billing Amount	    float	      Montant facturé
Room Number	        int	          Numéro de chambre
Admission Type	    string	      Type d’admission (ex: Urgent)
Discharge Date	    date	      Date de sortie
Medication	        string	      Médicament prescrit
Test Results	    string	      Résultat des tests


### Authentification et rôles

- **Utilisateur admin**
  - Nom : `admin`
  - Mot de passe : `admin123`
  - Rôle : `root`


### Architecture
docker-compose.yml
migrate_to_mongo.sh
data/patients.csv
mongo_data/

### Sécurité
1. Authentification MongoDB activée (MONGO_INITDB_ROOT_USERNAME, MONGO_INITDB_ROOT_PASSWORD)

2. Pas d’exposition d’accès direct hors du réseau local

3. Volumes persistants pour éviter la perte de données

### Commandes principales
./migrate_to_mongo.sh


### Résultat
55 500 documents importés avec succès dans la collection patients de la base medical_data.

### Vérifications
docker exec -it mongo_server mongosh -u admin -p admin123
use medical_data
db.patients.countDocuments() 
db.patients.findOne()

