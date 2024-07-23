# Test de Script Bash pour Calculer des Séries d'Exercices

## Description

Ce projet contient un script Bash pour traiter un fichier CSV d'exercices et calculer des séries pour chaque utilisateur. Il inclut également des scripts de génération de données de test et de tests unitaires pour vérifier le bon fonctionnement du script principal.

Lien du github : *https://github.com/FERRALI-Mario/tests_unitaires*

## Contenu

- `script.sh` : Le script principal qui lit les données du fichier CSV, traite les exercices et calcule les séries.
- `generate_test_data.sh` : Un script pour générer des données fictives de test.
- `run_tests.sh` : Un script pour exécuter les tests unitaires et vérifier les résultats.
- `Enregistrement.csv` : Un fichier CSV à traiter.

## Prérequis

Assurez-vous d'avoir les éléments suivants installés sur votre système :

- Bash
- Les commandes Unix standard (`date`, `grep`, `awk`)

## Instructions

### 1. Rendre les scripts exécutables

Ouvrez un terminal et rendez les scripts exécutables en exécutant les commandes suivantes :

```bash
chmod +x script.sh
chmod +x test/data_test.sh
chmod +x run_tests.sh
```

### 2. Exécuter le script principal

Exécutez le script principal `script.sh` avec le fichier de test généré comme argument :

```bash
./script.sh Enregistrement.csv
```

### Résultats du script

Le script crée un fichier `Resultat.csv` où les résultats des séries calculées sont enregistrés.

### 3. Exécuter les tests unitaires

Exécutez le script de test unitaire `run_tests.sh` pour vérifier les résultats :

```bash
./run_tests.sh
```

### Résultats des tests

Le script de test unitaire affichera les résultats des tests comme suit :

- `[OK]` en vert pour les tests réussis
- `[KO]` en rouge pour les tests échoués, avec des détails sur le jour d'échec

Un résumé des tests sera affiché à la fin, indiquant si tous les tests sont réussis ou combien ont échoué.

---

En suivant ces instructions, vous pourrez générer des données de test, exécuter le script principal et vérifier les résultats à l'aide des tests unitaires.

---

### Contributeur

[FERRALI Mario](https://www.linkedin.com/in/mario-ferrali-60a6251a1/)
