enum Goal { loseWeight, keepWeight, gainWeight }

enum Sex { female, male }

class Person {
  final Goal goal;
  final Sex sex;
  final DateTime dob;
  final int heightInCm;
  final double weight;

  Person({
    required this.goal,
    required this.sex,
    required this.dob,
    required this.heightInCm,
    required this.weight,
  });
}
