#!/bin/bash

# Variables initiales
max_vies=2
seconds_in_a_day=$((60 * 60 * 24))

# Fichier d'entrée et de sortie
input_file=${1:-"Enregistrement.csv"}
output_file="Resultat.csv"

# Compter le nombre total de lignes à traiter
total_lines=$(($(wc -l < "$input_file") - 1))

# Initialiser le fichier de sortie avec l'en-tête mis à jour
echo "\"Date\",\"Niveau\",\"Allonge\",\"Assis\",\"SessionID\",\"formattedDate\",\"Serie\"" > "$output_file"

# Fonction pour afficher la barre de chargement
show_progress() {
    local current_step=$1
    local total_steps=$2
    local progress=$(($current_step * 100 / $total_steps))
    local filled_length=$((current_step * 50 / $total_steps))
    local arrow=">"

    # Créer la flèche de progression
    for ((i = 0; i < filled_length; i++)); do
        arrow="=${arrow}"
    done

    # Afficher la barre de chargement
    printf "\rChargement du script [%-50s] %d%%" "${arrow}" "${progress}"
}

# Déclaration d'un tableau associatif pour les utilisateurs
declare -A users

# Fonction pour initialiser les variables pour chaque utilisateur
initialize_user() {
    local uuid=$1
    users[$uuid,vies]=$max_vies
    users[$uuid,serie]=0
    users[$uuid,consecutive_days]=0
    users[$uuid,last_timestamp]=0
    users[$uuid,done_assis_n1]=0
    users[$uuid,done_allonge_n1]=0
    users[$uuid,done_assis_n2]=0
    users[$uuid,done_allonge_n2]=0
    users[$uuid,increment_done]=0
}

# Lire le fichier CSV ligne par ligne en ignorant l'en-tête
current_line=0
tail -n +2 "$input_file" | while IFS=',' read -r timestamp niveau assis allonge uuid date
do
    # Nettoyer les champs
    timestamp=${timestamp//\"/}
    niveau=${niveau//\"/}
    assis=${assis//\"/}
    allonge=${allonge//\"/}
    uuid=${uuid//\"/}
    date=${date//\"/}

    # Initialiser les variables pour chaque utilisateur si elles n'existent pas
    [[ -z "${users[$uuid,vies]}" ]] && initialize_user "$uuid"

    # Vérifier si un nouveau jour a commencé
    if ((timestamp / seconds_in_a_day > users[$uuid,last_timestamp] / seconds_in_a_day)); then
        users[$uuid,increment_done]=0
        users[$uuid,done_assis_n1]=0
        users[$uuid,done_allonge_n1]=0
        users[$uuid,done_assis_n2]=0
        users[$uuid,done_allonge_n2]=0
    fi

    # Mettre à jour les indicateurs d'exercice
    [[ "$assis" == "True" && "$niveau" == "1" ]] && ((users[$uuid,done_assis_n1]++))
    [[ "$assis" == "True" && "$niveau" == "2" ]] && users[$uuid,done_assis_n2]=1
    [[ "$allonge" == "True" && "$niveau" == "1" ]] && ((users[$uuid,done_allonge_n1]++))
    [[ "$allonge" == "True" && "$niveau" == "2" ]] && users[$uuid,done_allonge_n2]=1

    # Vérifier si les conditions pour incrémenter la série sont remplies
    if [[ ${users[$uuid,increment_done]} -eq 0 && 
          ((${users[$uuid,done_assis_n2]} -ge 1 && ${users[$uuid,done_allonge_n2]} -ge 1) || 
           (${users[$uuid,done_assis_n2]} -ge 1 && ${users[$uuid,done_allonge_n1]} -ge 2) || 
           (${users[$uuid,done_assis_n1]} -ge 2 && ${users[$uuid,done_allonge_n2]} -ge 1) || 
           (${users[$uuid,done_assis_n1]} -ge 2 && ${users[$uuid,done_allonge_n1]} -ge 2)) ]]; then
        ((users[$uuid,consecutive_days]++))
        ((users[$uuid,consecutive_days] % 5 == 0 && users[$uuid,vies] < max_vies)) && ((users[$uuid,vies]++))
        ((users[$uuid,serie]++))
        users[$uuid,increment_done]=1
    elif [[ ${users[$uuid,increment_done]} -eq 0 ]]; then
        users[$uuid,consecutive_days]=0
    fi

    # Mettre à jour le dernier timestamp de pratique pour l'utilisateur
    users[$uuid,last_timestamp]=$timestamp

    # Enregistrer les résultats avec la série calculée en ajoutant des guillemets
    echo "\"$timestamp\",\"$niveau\",\"$allonge\",\"$assis\",\"$uuid\",\"$date\",\"${users[$uuid,serie]}\"" >> "$output_file"

    # Mettre à jour la barre de progression
    ((current_line++))
    show_progress $current_line $total_lines

done

# Nouvelle ligne à la fin du chargement
echo ""
echo "Traitement terminé. Fichier mis à jour enregistré dans $output_file"
echo -e "\n"
