# Carnet de Dépenses - Application Mobile Flutter

Ce projet est une application mobile de gestion de finances personnelles développée avec **Flutter & Dart**. Elle permet aux utilisateurs de suivre leurs dépenses quotidiennes de manière fluide, réactive.

---

## Objectifs du Projet

L’objectif principal de cette application est d'offrir un outil d'accompagnement budgétaire complet.

Les objectifs spécifiques incluent :
* **Performance et réactivité** : Offrir une interface utilisateur (UI) fluide sans latence lors des calculs financiers.
* **Persistance et intégrité des données** : Garantir que les données ne soient pas perdues après la fermeture de l'application ou le redémarrage de l'appareil.
* **Sécurité et confidentialité** : Assurer une isolation stricte des données financières dans un contexte multi-utilisateurs.

---

## Choix d'Architecture

L'application suit une architecture modulaire et découplée pour garantir la maintenabilité du code :

### 1. Gestion des Données (Modèles)
* **Modélisation stricte** : Utilisation de classes de données dédiées (`User` et `Expense`) pour structurer les entités.
* **Sérialisation/Désérialisation JSON** : Implémentation des méthodes `toJson()` et `fromJson()` pour formater proprement les données avant le stockage ou après la lecture.

### 2. Couche de Service (Stockage & Persistance)
* **Technologie** : Utilisation du package `localstorage 6.0.0` combiné avec la bibliothèque native `dart:convert`.
* **Stratégie d'Isolation Multi-Utilisateurs** : Pour éviter que les dépenses d'un utilisateur ne soient visibles par un autre sur le même appareil, le système génère des clés de stockage dynamiques basées sur l'identifiant unique de session (l'e-mail de l'utilisateur actif) : `expenses_$email`.

### 3. Gestion de l'État (State Management) & UI
* **Réactivité locale** : Utilisation de l'état natif de Flutter (`setState`) pour une mise à jour instantanée des données à l'écran.
* **StatefulBuilder** : Intégration dans le formulaire modal de saisie pour reconstruire dynamiquement les listes déroulantes de catégories sans recharger toute la page principale.
* **Optimisation du Layout** : Combinaison de `Column` et `ListView` pour les affichage visuels (*Overflow*) et fluidifier général.

---

## Fonctionnalités Implémentées

### 1. Authentification Dynamique
* Formulaire d'accès sécurisé par une validation via Expression Régulière (Regex) pour garantir le format de l'e-mail côté client.
* Connexion dynamique interrogeant l'API publique de test JSONPlaceholder (`/users?email=...`).
* *Note de test* : L'API étant en lecture seule, l'accès se fait via les e-mails officiels de leur base de données (ex: `Sincere@april.biz`).

### 2. Gestion Globale des Dépenses (Cycle CRUD)
* **Ajout** : Formulaire interactif en bas d'écran (*Modal Bottom Sheet*) permettant de saisir l'intitulé, le montant et une catégorie spécifique.
* **Suppression intuitive** : Fonctionnalité **Swipe-to-delete** grâce au widget `Dismissible`. La suppression est basée sur un identifiant unique (timestamp), évitant ainsi les collisions d'index lors du filtrage.
* **Gestion des modifications** : Dans le périmètre de ce MVP, les erreurs de saisie sont gérées efficacement par le cycle suppression-réapplication (l'utilisateur supprime d'un geste l'élément erroné et le ré-enregistre).

### 3. Statistiques & Filtrage Temporel en Temps Réel
* **Filtrage à trois niveaux** : Possibilité de segmenter la vue des dépenses en un clic : *Aujourd'hui*, *Ce mois*, ou *Tous*.
* **Indicateurs visuels d'allocation** : Calcul automatique et affichage du poids de chaque catégorie (Nourriture, Loyer, Transport, Électricité, Eau, Divertissement, etc.) via des barres de progression personnalisées (`LinearProgressIndicator`).
* **Précision financière** : Affichage des montants et des pourcentages avec une précision à une décimale (`toStringAsFixed(2)`) pour une transparence budgétaire maximale.

---

## Perspectives d'Évolution (Ce que j'aurais aimé ajouter)

J'aurais souhaité enrichir l'application avec les fonctionnalités suivantes :
1.  **Formulaire de Modification Dédié (Edit Mode)** : Intégrer un bouton d'édition sur chaque carte pour ouvrir un formulaire pré-rempli et modifier directement une dépense sans passer par le cycle de suppression.
2.  **Sélecteur de Période Personnalisé (Date Range Picker)** : Permettre à l'utilisateur de définir lui-même une plage de dates personnalisée (ex: du 12 au 25 du mois) pour analyser un moment précis de sa consommation.
3.  **Graphiques Circulaires (Pie Charts)** : Remplacer ou compléter les barres de progression par un graphique en camembert interactif pour une visualisation macroscopique encore plus moderne.
4.  **Backend de Production Réel** : Connecter l'application à une véritable base de données (ex: Firebase ou un serveur Node.js/PostgreSQL personnalisé) pour permettre une inscription réelle avec son propre e-mail et une synchronisation cloud.
5.  **Photo de ticket de dépense** : Permettre à l'utilisateur de sauvegarder le ticket de l'achat/dépense.