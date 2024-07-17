#!/bin/bash

output_file="TestEnregistrement.csv"

# Initialiser le fichier de test avec l'en-tête
echo "\"Date\",\"Niveau\",\"Allonge\",\"Assis\",\"SessionID\",\"formattedDate\"" > "$output_file"

# Générer des données fictives pour 3 jours
for day in {1..3}; do
    timestamp=$((1618937885 + (day - 1) * 60 * 60 * 24))
    formatted_date=$(date -d @$timestamp +"%d-%m-%Y")
    
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

    # Condition 5: Vérifier qu'une série ne peut pas être incrémentée deux fois le même jour
    echo "\"$timestamp\",\"2\",\"False\",\"True\",\"005\",\"$formatted_date\"" >> "$output_file"
    echo "\"$timestamp\",\"2\",\"True\",\"False\",\"005\",\"$formatted_date\"" >> "$output_file"
    # Répéter les exercices pour le même jour
    echo "\"$timestamp\",\"2\",\"False\",\"True\",\"005\",\"$formatted_date\"" >> "$output_file"
    echo "\"$timestamp\",\"2\",\"True\",\"False\",\"005\",\"$formatted_date\"" >> "$output_file"
done

echo "Les données de test ont été générées dans le fichier $output_file"
