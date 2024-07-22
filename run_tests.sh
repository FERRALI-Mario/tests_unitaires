#!/bin/bash

# Générer les données de test
./test/data_test.sh

# Exécuter le script principal avec le fichier de test comme argument
./script.sh test/data_test.csv

# Lire le fichier de sortie
output_file="Resultat.csv"
failed_tests=0

# Codes de couleur
green='\033[0;32m'
red='\033[0;31m'
no_color='\033[0m'

# Fonction pour vérifier les résultats
check_result() {
    local expected_series=$1
    local user=$2
    local day=$3
    local actual_series=$(grep "\"$user\",\"$day\"" "$output_file" | tail -n1 | awk -F, '{print $7}' | tr -d '"')
    if [[ "$actual_series" -ne "$expected_series" ]]; then
        return 1
    else
        return 0
    fi
}

# Fonction pour exécuter un test complet pour plusieurs jours
run_test() {
    local test_name=$1
    local user=$2
    shift 2
    local expected_series_days=("$@")

    local day_offset=0
    for expected_series in "${expected_series_days[@]}"; do
        local timestamp=$((1618937885 + day_offset * 60 * 60 * 24))
        local formatted_date=$(date -d @$timestamp +"%d-%m-%Y")

        check_result $expected_series $user $formatted_date
        if [[ $? -ne 0 ]]; then
            echo -e "[${red}KO${no_color}] Test : $test_name - Échec au jour $formatted_date"
            ((failed_tests++))
            return
        fi
        ((day_offset++))
    done

    echo -e "[${green}OK${no_color}] Test : $test_name"
}

# Exécuter les tests
echo -e "Exécution des tests...\n"
echo -e "PARTIE 1: Vérification des séries de base\n"
run_test "Augmentation de la série : un exercice niveau 2 assis et un exercice niveau 2 allongé" "001" 1 2 3
run_test "Augmentation de la série : un exercice niveau 2 assis et deux exercices niveau 1 allongé" "002" 1 2 3
run_test "Augmentation de la série : deux exercices niveau 1 assis et un exercice niveau 2 allongé" "003" 1 2 3
run_test "Augmentation de la série : deux exercices niveau 1 assis et deux exercices niveau 1 allongé" "004" 1 2 3
run_test "Perte de la série : un exercice niveau 1 assis et aucun exercice allongé" "005" 0 0 0
run_test "Perte de la série : aucun exercice assis et un exercice niveau 1 allongé" "006" 0 0 0
run_test "Perte de la série : un exercice niveau 2 assis et un exercice niveau 1 allongé" "007" 0 0 0
run_test "Perte de la série : un exercice niveau 1 assis et un exercice niveau 2 allongé" "008" 0 0 0
run_test "Vérification : qu'une série ne peut pas être incrémentée deux fois le même jour" "009" 1 2 3

echo -e "\nPARTIE 2: Vérification du système de vie sur plusieurs jours\n"
run_test "Augmentation de la série : faire deux jours sans participation ou participation partielle" "010" 1 2 3 0 0 4
run_test "Augmentation de la série : perte de trois vies à plusieurs jours d'intervales" "011" 1 2 3 0 0 4 5 6 7 0 8
run_test "Perte de série : faire plus de 3 jours sans exercice" "012" 1 2 3 0 0 0 1

# Résumé des tests
if [[ $failed_tests -eq 0 ]]; then
    echo -e "\nTous les tests sont réussis\n"
elif [[ $failed_tests -eq 1 ]]; then
    echo -e "\n$failed_tests test a échoué\n"
else
    echo -e "\n$failed_tests tests ont échoué\n"
fi