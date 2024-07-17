#!/bin/bash

# Générer les données de test
./generate_test_data.sh

# Exécuter le script principal avec le fichier de test comme argument
./script.sh TestEnregistrement.csv

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

# Fonction pour exécuter un test complet pour 3 jours
run_test() {
    local test_name=$1
    local user=$2
    local expected_series_day1=$3
    local expected_series_day2=$4
    local expected_series_day3=$5

    local timestamp_day1=$((1618937885))
    local timestamp_day2=$((1618937885 + 60 * 60 * 24))
    local timestamp_day3=$((1618937885 + 2 * 60 * 60 * 24))
    local formatted_date1=$(date -d @$timestamp_day1 +"%d-%m-%Y")
    local formatted_date2=$(date -d @$timestamp_day2 +"%d-%m-%Y")
    local formatted_date3=$(date -d @$timestamp_day3 +"%d-%m-%Y")

    check_result $expected_series_day1 $user $formatted_date1
    local result_day1=$?
    check_result $expected_series_day2 $user $formatted_date2
    local result_day2=$?
    check_result $expected_series_day3 $user $formatted_date3
    local result_day3=$?

    if [[ $result_day1 -eq 0 && $result_day2 -eq 0 && $result_day3 -eq 0 ]]; then
        echo -e "[${green}OK${no_color}] Test : $test_name"
    else
        echo -e "[${red}KO${no_color}] Test : $test_name"
        [[ $result_day1 -ne 0 ]] && echo "   Échec au jour $formatted_date1"
        [[ $result_day2 -ne 0 ]] && echo "   Échec au jour $formatted_date2"
        [[ $result_day3 -ne 0 ]] && echo "   Échec au jour $formatted_date3"
        ((failed_tests++))
    fi
}

# Exécuter les 5 tests
run_test "1 exercice niveau 2 assis et 1 exercice niveau 2 allongé" "001" 1 2 3
run_test "1 exercice niveau 2 assis et 2 exercices niveau 1 allongé" "002" 1 2 3
run_test "2 exercices niveau 1 assis et 1 exercice niveau 2 allongé" "003" 1 2 3
run_test "2 exercices niveau 1 assis et 2 exercices niveau 1 allongé" "004" 1 2 3
run_test "Vérifier qu'une série ne peut pas être incrémentée deux fois le même jour" "005" 1 2 3

# Résumé des tests
if [[ $failed_tests -eq 0 ]]; then
    echo -e "\nTous les tests sont réussis"
else
    echo -e "\n$failed_tests tests ont échoué"
fi
