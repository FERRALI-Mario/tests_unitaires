#!/bin/bash

output_file="test/data_test.csv"

# Initialiser le fichier de test avec l'en-tête
echo "\"Date\",\"Niveau\",\"Allonge\",\"Assis\",\"SessionID\",\"formattedDate\"" > "$output_file"

# Générer des données fictives pour 11 jours
for day in {1..11}; do
    timestamp=$((1618937885 + (day - 1) * 60 * 60 * 24))
    formatted_date=$(date -d @$timestamp +"%d-%m-%Y")
    
    # Générer des données pour les tests de base sur 3 jours
    if [[ $day -le 3 ]]; then
        # Condition 1: 1 exercice niveau 2 assis et 1 exercice niveau 2 allongé
        echo "\"$timestamp\",\"2\",\"False\",\"True\",\"001\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"False\",\"001\",\"$formatted_date\"" >> "$output_file"

        # Condition 2: 1 exercice niveau 2 assis et 2 exercices niveau 1 allongé
        echo "\"$timestamp\",\"2\",\"False\",\"True\",\"002\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"True\",\"False\",\"002\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"True\",\"False\",\"002\",\"$formatted_date\"" >> "$output_file"

        # Condition 3: 2 exercices niveau 1 assis et 1 exercice niveau 2 allongé
        echo "\"$timestamp\",\"1\",\"False\",\"True\",\"003\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"False\",\"True\",\"003\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"False\",\"003\",\"$formatted_date\"" >> "$output_file"

        # Condition 4: 2 exercices niveau 1 assis et 2 exercices niveau 1 allongé
        echo "\"$timestamp\",\"1\",\"False\",\"True\",\"004\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"False\",\"True\",\"004\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"True\",\"False\",\"004\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"True\",\"False\",\"004\",\"$formatted_date\"" >> "$output_file"

        # Condition 5: 1 exercice niveau 1 assis et aucun exercice allongé
        echo "\"$timestamp\",\"1\",\"False\",\"True\",\"005\",\"$formatted_date\"" >> "$output_file"

        # Condition 6: Aucun exercice assis et 1 exercice niveau 1 allongé
        echo "\"$timestamp\",\"1\",\"True\",\"False\",\"006\",\"$formatted_date\"" >> "$output_file"

        # Condition 7: 1 exercice niveau 2 assis et 1 exercice niveau 1 allongé
        echo "\"$timestamp\",\"2\",\"False\",\"True\",\"007\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"1\",\"True\",\"False\",\"007\",\"$formatted_date\"" >> "$output_file"

        # Condition 8: 1 exercice niveau 1 assis et 1 exercice niveau 2 allongé
        echo "\"$timestamp\",\"1\",\"False\",\"True\",\"008\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"False\",\"008\",\"$formatted_date\"" >> "$output_file"

        # Condition 9: Vérifier la réinitialisation des exercices d'un jour à l'autre
        if [[ $day -eq 1 ]]; then
            echo "\"$timestamp\",\"2\",\"False\",\"True\",\"009\",\"$formatted_date\"" >> "$output_file" # Exercice niveau 2 assis
        elif [[ $day -eq 2 ]]; then
            echo "\"$timestamp\",\"2\",\"True\",\"False\",\"009\",\"$formatted_date\"" >> "$output_file" # Exercice niveau 2 allongé
        fi

        # Condition 10: Vérifier qu'une série ne peut pas être incrémentée deux fois le même jour
        echo "\"$timestamp\",\"2\",\"False\",\"True\",\"010\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"False\",\"010\",\"$formatted_date\"" >> "$output_file"
        # Répéter les exercices pour le même jour
        echo "\"$timestamp\",\"2\",\"False\",\"True\",\"010\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"False\",\"010\",\"$formatted_date\"" >> "$output_file"

        # Générer des données pour les tests du système de vie sur plusieurs jours
        echo "\"$timestamp\",\"2\",\"True\",\"True\",\"011\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"True\",\"012\",\"$formatted_date\"" >> "$output_file"
        echo "\"$timestamp\",\"2\",\"True\",\"True\",\"013\",\"$formatted_date\"" >> "$output_file"
    fi

    # Générer des données pour les tests du système de vie sur plusieurs jours
    case $day in
        4|5)
            # Jour 4/5 : Aucun exercice pour tester la perte de vie (tous)
            ;;
        6)
            # Jour 6
            # 1 exercice niveau 2 assis et 1 exercice niveau 2 allongé pour conserver la série et vie
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"011\",\"$formatted_date\"" >> "$output_file"
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"012\",\"$formatted_date\"" >> "$output_file"
            # Aucun exercice pour tester la perte de vie et de la série (12)
            ;;
        7)
            # Jour 7: 1 exercice niveau 2 assis et 1 exercice niveau 2 allongé pour conserver la série et vie
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"012\",\"$formatted_date\"" >> "$output_file"
            ;;
        8)
            # Jour 8: 1 exercice niveau 2 assis et 1 exercice niveau 2 allongé pour conserver la série et vie
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"012\",\"$formatted_date\"" >> "$output_file"
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"013\",\"$formatted_date\"" >> "$output_file"
            ;;
        9)
            # Jour 9: 1 exercice niveau 2 assis et 1 exercice niveau 2 allongé pour conserver la série et vie
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"012\",\"$formatted_date\"" >> "$output_file"
            ;;
        10)
            # Jour 10: Aucun exercice pour tester la perte de vie
            ;;
        11)
            # Jour 11: 1 exercice niveau 2 assis et 1 exercice niveau 2 allongé pour conserver la série et vie
            echo "\"$timestamp\",\"2\",\"True\",\"True\",\"012\",\"$formatted_date\"" >> "$output_file"
            ;;
    esac
done

echo "Les données de test ont été générées dans le fichier $output_file"
