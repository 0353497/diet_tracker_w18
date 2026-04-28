import 'dart:math';

import 'package:diet_tracker/models/diet_day.dart';
import 'package:diet_tracker/models/person.dart';
import 'package:diet_tracker/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
                            CircularProgressIndicator(
                              value:
                                  currentDietDay.caloriesTotal /
                                  currentPerson.calculatedKcal,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "${personProvider.person.value!.calculatedKcal}",
                                    style: TextStyle(fontSize: 32),
                                  ),
                                  Text("KCAL LEFT"),
                                ],
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Water"),
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
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffe3f0e1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Breakfast"), Text("0kcal")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not entered yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffe3f0e1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Lunch"), Text("0kcal")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not entered yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffe3f0e1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Dinner"), Text("0kcal")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not entered yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xffe3f0e1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Exercise"), Text("0kcal")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Not entered yet",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
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
          ],
        );
      }),
    );
  }
}
