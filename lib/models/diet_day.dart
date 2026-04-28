class DietDay {
  final int glassedOfWater;
  final List<Meal> meals;
  final List<Excersice> excersices;
  int get caloriesEaten => meals.fold(0, (sum, meal) => sum + meal.kcal);
  int get caloriesBurned =>
      excersices.fold(0, (sum, excersice) => sum + excersice.kcal);

  int get caloriesTotal => caloriesEaten - caloriesBurned;
  DietDay({
    required this.glassedOfWater,
    required this.meals,
    required this.excersices,
  });
}

class Meal {
  final DateTime time;
  final int kcal;
  final String name;

  Meal({required this.time, required this.kcal, required this.name});
}

class Excersice {
  final DateTime time;
  final int kcal;
  final String name;

  Excersice({required this.time, required this.kcal, required this.name});
}
