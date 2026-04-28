import 'package:diet_tracker/models/diet_day.dart';
import 'package:diet_tracker/models/person.dart';
import 'package:diet_tracker/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

String _mealTypeForTime(DateTime now) {
  final minutes = now.hour * 60 + now.minute;

  if (minutes < 10 * 60 + 30) {
    return 'Breakfast';
  }

  if (minutes < 16 * 60) {
    return 'Lunch';
  }

  return 'Dinner';
}

class DietTrackerPage extends StatefulWidget {
  const DietTrackerPage({super.key});

  @override
  State<DietTrackerPage> createState() => _DietTrackerPageState();
}

class _DietTrackerPageState extends State<DietTrackerPage> {
  DateTime selectedDatetime = DateTime.now();
  final Map<String, DietDay> dietManager = <String, DietDay>{};
  final PersonProvider personProvider = Get.find<PersonProvider>();
  Person get currentPerson => personProvider.person.value!;

  String _dayKey(DateTime date) => DateUtils.dateOnly(date).toIso8601String();

  DietDay get currentDietDay {
    final key = _dayKey(selectedDatetime);
    return dietManager.putIfAbsent(
      key,
      () => DietDay(
        glassedOfWater: 0,
        meals: <Meal>[],
        excersices: <Excersice>[],
      ),
    );
  }

  void _setWaterGlasses(int glasses) {
    final key = _dayKey(selectedDatetime);
    final day = currentDietDay;

    dietManager[key] = DietDay(
      glassedOfWater: glasses,
      meals: day.meals,
      excersices: day.excersices,
    );
  }

  Widget _buildMealCard(String mealType) {
    final mealsOfType = currentDietDay.meals
        .where((meal) => meal.name.startsWith('$mealType:'))
        .toList();
    final totalCalories = mealsOfType.fold(0, (sum, meal) => sum + meal.kcal);

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffe3f0e1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(mealType, style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${totalCalories}kcal"),
            ],
          ),
          if (mealsOfType.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not entered yet", style: TextStyle(color: Colors.grey)),
              ],
            )
          else
            ...mealsOfType.map((meal) {
              final mealName = meal.name.replaceFirst('$mealType: ', '');
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$mealName, ${DateFormat("HH:mm").format(DateTime.now())}",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text("${meal.kcal}kcal", style: TextStyle(fontSize: 12)),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildExerciseCard() {
    final totalCalories = currentDietDay.excersices.fold(
      0,
      (sum, exc) => sum + exc.kcal,
    );

    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xffe3f0e1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Exercise", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${totalCalories}kcal"),
            ],
          ),
          if (currentDietDay.excersices.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not entered yet", style: TextStyle(color: Colors.grey)),
              ],
            )
          else
            ...currentDietDay.excersices.map((exercise) {
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${exercise.name}, ${DateFormat("HH:mm").format(DateTime.now())}",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${exercise.kcal}kcal",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            Container(
              height: Get.height * .3,
              decoration: BoxDecoration(
                color: Color(0xffc7e2c3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/Icons/Icon.png", width: 48),
                        Text(
                          "Diet Tracker",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              "${currentDietDay.caloriesEaten}",
                              style: TextStyle(fontSize: 32),
                            ),
                            Text("Eaten"),
                          ],
                        ),
                        Stack(
                          children: [
                            if (currentPerson.calculatedKcal -
                                    currentDietDay.caloriesTotal >
                                0)
                              Positioned.fill(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    Color(0xff00a221),
                                  ),
                                  value:
                                      currentDietDay.caloriesTotal /
                                      currentPerson.calculatedKcal,
                                ),
                              ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 12,
                                  children: [
                                    Text(
                                      "${personProvider.person.value!.calculatedKcal}",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      currentPerson.calculatedKcal -
                                                  currentDietDay.caloriesTotal >
                                              0
                                          ? "KCAL LEFT"
                                          : "KCAL OVER.",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${currentDietDay.caloriesBurned}",
                              style: TextStyle(fontSize: 32),
                            ),
                            Text("Burned"),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDatetime = DateUtils.dateOnly(
                                selectedDatetime.subtract(1.days),
                              );
                            });
                          },
                          icon: Image.asset(
                            "assets/Icons/Chevron left.png",
                            width: 24,
                          ),
                        ),
                        Text(
                          DateFormat("EEEE, MMMM d").format(selectedDatetime),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedDatetime = DateUtils.dateOnly(
                                selectedDatetime.add(1.days),
                              );
                            });
                          },
                          icon: Image.asset(
                            "assets/Icons/Chevron right.png",
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Water"),
                        Text("${currentDietDay.glassedOfWater * .25} l"),
                      ],
                    ),
                    Row(
                      children: List.generate(
                        currentDietDay.glassedOfWater < 8
                            ? 8
                            : currentDietDay.glassedOfWater + 1,
                        (i) {
                          final isFilled = i < currentDietDay.glassedOfWater;

                          return InkWell(
                            key: ValueKey('water-glass-$i'),
                            onTap: () {
                              setState(() {
                                _setWaterGlasses(isFilled ? i : i + 1);
                              });
                            },
                            child: Image.asset(
                              isFilled
                                  ? "assets/Icons/Water full.png"
                                  : "assets/Icons/Water empty.png",
                              height: 32,
                            ),
                          );
                        },
                      ),
                    ),
                    _buildMealCard("Breakfast"),
                    _buildMealCard("Lunch"),
                    _buildMealCard("Dinner"),
                    _buildExerciseCard(),
                    Spacer(),
                    Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Get.bottomSheet(
                                TrackMealSheet(
                                  existingMeals: currentDietDay.meals,
                                  onTrack: (meal) {
                                    setState(() {
                                      currentDietDay.meals.add(meal);
                                    });
                                  },
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xff00a221),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            child: Text("Track Meal"),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Get.bottomSheet(
                                TrackExcerciseSheet(
                                  existingExercises: currentDietDay.excersices,
                                  onTrack: (exc) {
                                    setState(() {
                                      currentDietDay.excersices.add(exc);
                                    });
                                  },
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xff00a221),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            child: Text("Track Exercise"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class TrackExcerciseSheet extends StatefulWidget {
  final List<Excersice> existingExercises;
  final void Function(Excersice) onTrack;
  const TrackExcerciseSheet({
    super.key,
    required this.existingExercises,
    required this.onTrack,
  });

  @override
  State<TrackExcerciseSheet> createState() => _TrackExcerciseSheetState();
}

class _TrackExcerciseSheetState extends State<TrackExcerciseSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _kcalCtrl = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  bool get _isFormValid {
    final name = _nameCtrl.text.trim();
    final kcal = int.tryParse(_kcalCtrl.text.trim());

    return name.isNotEmpty && kcal != null && kcal > 0;
  }

  void _prefillFromLastExercise() {
    if (widget.existingExercises.isEmpty) {
      return;
    }

    final lastExercise = widget.existingExercises.last;
    _nameCtrl.text = lastExercise.name;
    _kcalCtrl.text = lastExercise.kcal.toString();
    _nameCtrl.selection = TextSelection(
      baseOffset: 0,
      extentOffset: lastExercise.name.length,
    );
  }

  @override
  void initState() {
    super.initState();
    _prefillFromLastExercise();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _nameFocusNode.requestFocus();
      if (_nameCtrl.text.isNotEmpty) {
        _nameCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _nameCtrl.text.length,
        );
      }
      setState(() {});
    });
    _nameCtrl.addListener(() {
      if (mounted) setState(() {});
    });
    _kcalCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kcalCtrl.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .33,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Track Exercise",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(labelText: "Name"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _kcalCtrl,
                decoration: InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter calories';
                  if (int.tryParse(v) == null) return 'Enter a number';
                  if (int.parse(v) <= 0) return 'Enter a positive number';
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width * .5,
                    child: TextButton(
                      onPressed: _isFormValid
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final exc = Excersice(
                                  time: DateTime.now(),
                                  kcal: int.parse(_kcalCtrl.text.trim()),
                                  name: _nameCtrl.text.trim(),
                                );
                                widget.onTrack(exc);
                                Get.back();
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xff00a221),
                        ),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      child: Text("Track"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackMealSheet extends StatefulWidget {
  final List<Meal> existingMeals;
  final void Function(Meal) onTrack;
  const TrackMealSheet({
    super.key,
    required this.existingMeals,
    required this.onTrack,
  });

  @override
  State<TrackMealSheet> createState() => _TrackMealSheetState();
}

class _TrackMealSheetState extends State<TrackMealSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _kcalCtrl = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  String _mealType = _mealTypeForTime(DateTime.now());

  bool get _isFormValid {
    final name = _nameCtrl.text.trim();
    final kcal = int.tryParse(_kcalCtrl.text.trim());

    return name.isNotEmpty && kcal != null && kcal > 0;
  }

  void _prefillFromLastMeal() {
    for (final meal in widget.existingMeals.reversed) {
      if (!meal.name.startsWith('$_mealType: ')) {
        continue;
      }

      final mealName = meal.name.replaceFirst('$_mealType: ', '');
      _nameCtrl.text = mealName;
      _kcalCtrl.text = meal.kcal.toString();
      _nameCtrl.selection = TextSelection(
        baseOffset: 0,
        extentOffset: mealName.length,
      );
      break;
    }
  }

  @override
  void initState() {
    super.initState();
    _prefillFromLastMeal();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _nameFocusNode.requestFocus();
      if (_nameCtrl.text.isNotEmpty) {
        _nameCtrl.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _nameCtrl.text.length,
        );
      }
      setState(() {});
    });
    _nameCtrl.addListener(() {
      if (mounted) setState(() {});
    });
    _kcalCtrl.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _kcalCtrl.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * .33,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Track Meal",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.maxFinite,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff00a221), width: 4),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.black),

                        backgroundColor: _mealType == 'Breakfast'
                            ? WidgetStatePropertyAll(Color(0xffc7e2c3))
                            : null,
                      ),
                      onPressed: () => setState(() => _mealType = 'Breakfast'),
                      child: Text("Breakfast"),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.black),
                        backgroundColor: _mealType == 'Lunch'
                            ? WidgetStatePropertyAll(Color(0xffc7e2c3))
                            : null,
                      ),
                      onPressed: () => setState(() => _mealType = 'Lunch'),
                      child: Text("Lunch"),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStatePropertyAll(Colors.black),

                        backgroundColor: _mealType == 'Dinner'
                            ? WidgetStatePropertyAll(Color(0xffc7e2c3))
                            : null,
                      ),
                      onPressed: () => setState(() => _mealType = 'Dinner'),
                      child: Text("Dinner"),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(labelText: "Name"),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _kcalCtrl,
                decoration: InputDecoration(labelText: "Calories"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter calories';
                  if (int.tryParse(v.trim()) == null) return 'Enter a number';
                  if (int.parse(v.trim()) <= 0)
                    return "Enter a positive number";
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width * .5,
                    child: TextButton(
                      onPressed: _isFormValid
                          ? () {
                              if (_formKey.currentState?.validate() ?? false) {
                                final meal = Meal(
                                  time: DateTime.now(),
                                  kcal: int.parse(_kcalCtrl.text.trim()),
                                  name:
                                      '${_mealType.isNotEmpty ? '$_mealType: ' : ''}${_nameCtrl.text.trim()}',
                                );
                                widget.onTrack(meal);
                                Get.back();
                              }
                            }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color(0xff00a221),
                        ),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      child: Text("Track"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
