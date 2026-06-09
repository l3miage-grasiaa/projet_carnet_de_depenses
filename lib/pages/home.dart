import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/expense.dart';
import '../services/storage.dart';
import 'login.dart';
import 'profile.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final _storage = StorageService();
  List<Expense> _expenses = [];
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Ouvre les données enregistrées lors de la première ouverture de l'application.
  }

  void _loadInitialData() {
    setState(() {
      _currentUser = _storage.getUser();

      // Si un utilisateur est connecté, récupérer ses données. Sinon, vider la liste.
      if (_currentUser != null) {
        // L'API jsonplaceholder utilisant le nom d'utilisateur comme identifiant unique,
        // nous pouvons utiliser _currentUser!.lastName ou _currentUser!.email comme identifiant clé
        _expenses = _storage.getExpenses(_currentUser!.email);
      } else {
        _expenses = [];
      }
    });
  }

  // Fonction permettant de calculer le total des dépenses cumulées
  double get _totalSpending {
    return _expenses.fold(0, (sum, item) => sum + item.amount);
  }

  // Fonction permettant d'afficher un formulaire de saisie modal depuis le bas de l'écran (Feuille inférieure)
  void _openAddExpenseModal() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    final List<String> categories = ['Nourriture', 'Transport', 'Courses', 'Divertissement', 'Santé', 'Loyer', 'Factures', 'Autres'];
    String selectedCategory = 'Nourriture'; // catégory par défaut

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Empêcher la fermeture du formulaire par le clavier HP
      builder: (ctx) {
        // Utilisation de StatefulBuilder pour que les modifications apportées aux listes déroulantes à l'intérieur d'une fenêtre modale redémarrent immédiatement l'interface utilisateur de cette fenêtre.
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, // Empêcher la fermeture de la disposition des goulots d'étranglement sur le clavier
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Ajouter une nouvelle dépense",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: "Intitulé des dépenses"),
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Somme (€)"),
                    ),
                    const SizedBox(height: 16),

                    // --- DROPDOWN CHOIX DE CATEGORIE  ---
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories.map((String cat) {
                        return DropdownMenuItem<String>(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        // Modifier l'état interne de la feuille modale
                        setModalState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Categorie",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Bouton Enregistrer et exécuter
                    ElevatedButton(
                      onPressed: () {
                        final enteredTitle = titleController.text.trim();
                        final enteredAmount = double.tryParse(amountController.text) ?? 0.0;

                        if (enteredTitle.isEmpty || enteredAmount <= 0) return;

                        final newExpense = Expense(
                          id: DateTime.now().toString(),
                          title: enteredTitle,
                          amount: enteredAmount,
                          date: DateTime.now(), // Identifiant unique utilisant un horodatage aléatoire
                          category: selectedCategory, // Enregistre la catégorie sélectionnée par l'utilisateur
                        );

                        setState(() {
                          _expenses.add(newExpense);

                          // Indiquez l'adresse e-mail de l'utilisateur actif actuel comme clé d'isolation des données
                          _storage.saveExpenses(_currentUser!.email, _expenses);
                        });

                        Navigator.of(ctx).pop(); // Fermer la feuille modale
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
                      child: const Text("Enregistrer les notes"),
                    ),
                  ],
                ),
              );
            }
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Nourriture' :
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Courses':
        return Icons.shopping_bag;
      case 'Divertissement':
        return Icons.local_movies;
      case 'Santé':
        return Icons.medical_services;
      case 'Loyer':
        return Icons.home_work;
      case 'Factures electricite':
        return Icons.electric_bolt;
      case 'Factures eau':
        return Icons.water_drop;
      default:
        return Icons.monetization_on;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Nourriture':
        return Colors.orange;
      case 'Transport':
        return Colors.blue;
      case 'Courses':
        return Colors.purple;
      case 'Divertissement':
        return Colors.green;
      case 'Santé':
        return Colors.red;
      case 'Loyer':
        return Colors.brown;
      case 'Factures electricite':
        return Colors.amber;
      case 'Factures eau':
        return Colors.lightBlue;
      default:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carnet de Dépenses"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 35),
            onPressed: () async {
              if (_currentUser != null) {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(user: _currentUser!),
                ));
                _loadInitialData(); // Resynchronisation si l'utilisateur appuie sur le bouton de déconnexion sur la page de profil
              } else {
                final result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));
                if (result != null && result is User) {
                  _storage.saveUser(result);
                  _loadInitialData();
                }
              }
            },
          ),
        ],
      ),

      // BOUTON PLUS POUR AJOUTER DES DÉPENSES
      floatingActionButton: _currentUser == null ? null : FloatingActionButton(
        onPressed: _openAddExpenseModal,
        child: const Icon(Icons.add),
      ),

      body: _currentUser == null
          ? const Center(child: Text("Veuillez vous connecter d'abord pour enregistrer vos dépenses."))
          : Column(
        children: [
          // --- RÉCAPITULATIF DES FONDS TOTAL DE LA CARTE ---
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.deepPurple[50],
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Dépenses totales : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(
                    "${_totalSpending.toStringAsFixed(2)} €",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ),

          // --- LISTE DE NOTES ---
          Expanded(
            child: _expenses.isEmpty
                ? const Center(child: Text("Aucune dépense n'est enregistrée pour le moment. Cliquez sur le bouton +"))
                : ListView.builder(
              itemCount: _expenses.length,
              itemBuilder: (ctx, index) {
                final item = _expenses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    // Utilisation d'icônes et de couleurs dynamiques en fonction des catégories de dépenses
                    leading: CircleAvatar(
                      backgroundColor: _getCategoryColor(item.category).withValues(alpha: 0.2),
                      child: Icon(_getCategoryIcon(item.category), color: _getCategoryColor(item.category)),
                    ),
                    title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    // Affiche les sous-titres sous forme de date et de catégorie
                    subtitle: Text("${item.date.day}/${item.date.month}/${item.date.year} • ${item.category}"),
                    trailing: Text(
                      "- ${item.amount.toStringAsFixed(2)} €",
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}