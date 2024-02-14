#!/bin/bash

# Vérifier s'il n'y a pas déjà un projet Java en cours
if pgrep -f "java .*\.jar" > /dev/null; then
        echo "Arret du projet java en cours..."
        pkill -f "java .*\.jar"
fi

# Lancer le JAR fourni en arguments en arriere-plan
if [ $# -eq 0 ]; then
        echo "Erreur : Aucun jar fourni..."
        exit 1
fi

# Chemin absolu vers le JAR
JAR_PATH="$1"

# Extraction du répertoire
JAR_DIR=$(dirname "$JAR_PATH")

# Construire le chemin du fichier
LOG_FILE="$JAR_DIR/java.log"

# Lancement du jar et redirection des logs
nohup java -jar "$JAR_PATH" >> "$LOG_FILE" 2>&1 &

# Attendre quelques instants pour laisser le processus se lancer
sleep 5

# Vérifier si le processus Java est en cours d'exécution
if pgrep -f "java .*\.jar" > /dev/null; then
        echo "OK"
else
        echo "Erreur au lancement du projet jar..."
fi
