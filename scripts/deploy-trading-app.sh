#!/bin/bash

# Paramètres
JAR_PATH="$1"

# Extraire le nom du dossier du projet à partir du chemin du jar
PROJECT_DIR=$(dirname "$JAR_PATH")

# Extraire le nom du fichier jar sans extension
JAR_FILENAME=$(basename "$JAR_PATH")
JAR_NAME=$(echo "$JAR_FILENAME" | sed -E 's/-[0-9].*//')

# Chemin du fichier java.log
LOG_PATH="$PROJECT_DIR/$JAR_NAME.log"

# Verifier si le jar est déjà en cours d'execution
#if pgrep -f "$JAR_NAME.*\.jar" > /dev/null; then
#       echo "Arret du jar [$JAR_NAME] en cours..."
#       pkill -f "$JAR_NAME"
#       sleep 5
#fi

# Lancer le projet Java
echo "Lancement du jar [$JAR_FILENAME] ..."
nohup java -jar "$JAR_PATH" >> "$LOG_PATH" 2>&1 &

# Attendre le lancement du projet
sleep 5


#echo $(tail -500f $LOG_PATH)
# Vérifier le processus Java
if pgrep -f "$JAR_NAME.*\.jar" > /dev/null; then
        echo "OK, projet lancé"
else
        echo "Erreur au lancement du jar [$JAR_NAME]..."
fi
