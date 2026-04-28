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

  int get ageInYears {
    final today = DateTime.now();
    var age = today.year - dob.year;
    final hasHadBirthdayThisYear =
        today.month > dob.month ||
        (today.month == dob.month && today.day >= dob.day);

    if (!hasHadBirthdayThisYear) {
      age -= 1;
    }

    return age;
  }

  int get calculatedKcal {
    if (goal == Goal.gainWeight) return (dailyNeed * 1.1).toInt();
    if (goal == Goal.loseWeight) return (dailyNeed * .9).toInt();
    return dailyNeed;
  }

  int get dailyNeed {
    final calories = sex == Sex.female
        ? 9.563 * weight + 1.850 * heightInCm - 4.676 * ageInYears + 655.1
        : 13.752 * weight + 5.003 * heightInCm - 6.755 * ageInYears + 66.5;

    return calories.round();
  }
}
