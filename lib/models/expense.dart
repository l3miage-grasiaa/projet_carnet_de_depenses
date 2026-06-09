class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category; // ex: transport, repas, courses, etc

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  // Convertir l'objet Expense en une carte JSON pour l'enregistrer sur le disque dur
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "amount": amount,
      "date": date.toIso8601String(), // Convertit la date en texte au format ISO.
      "category": category,
    };
  }

  // Réassembler le texte JSON du disque dur en objets Expense actifs
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(), // Empêcher les plantages lors des conversions de nombres
      date: DateTime.parse(json['date'] as String),
      category: json['category'] as String,
    );
  }
}