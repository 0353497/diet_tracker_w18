import 'package:diet_tracker/models/person.dart';
import 'package:diet_tracker/pages/diet_tracker_page.dart';
import 'package:diet_tracker/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final DateFormat _dobFormat = DateFormat('dd/MM/yyyy');
  Goal? selectedGoal;
  Sex? selectedSex;
  DateTime? selectedDOB;
  int? selectedHeight;
  double? selectedWeight;
  TextEditingController dobController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  bool get isFormValid {
    final height = int.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);

    return selectedGoal != null &&
        selectedSex != null &&
        selectedDOB != null &&
        height != null &&
        height > 0 &&
        weight != null &&
        weight > 0;
  }

  Future<void> _pickDob() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDOB ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate == null) {
      return;
    }

    setState(() {
      selectedDOB = pickedDate;
      dobController.text = _dobFormat.format(pickedDate);
    });
  }

  Person? get calculatedPerson {
    final goal = selectedGoal;
    final sex = selectedSex;
    final dob = selectedDOB;
    final height = selectedHeight;
    final weight = selectedWeight;

    if (goal == null ||
        sex == null ||
        dob == null ||
        height == null ||
        weight == null) {
      return null;
    }

    return Person(
      goal: goal,
      sex: sex,
      dob: dob,
      heightInCm: height,
      weight: weight,
    );
  }

  int get calculatedKcal {
    return calculatedPerson?.calculatedKcal ?? 0;
  }

  final PersonProvider personProvider = Get.find<PersonProvider>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/Icons/Icon.png"),
        ),
        title: Text(
          "Tell us about yourself",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Goal'),
                    Row(
                      spacing: 24,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedGoal = Goal.loseWeight;
                              });
                            },
                            style: ButtonStyle(
                              shape: selectedGoal == Goal.loseWeight
                                  ? WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(32),
                                        side: const BorderSide(
                                          color: Color(0xff00a221),
                                          width: 4,
                                        ),
                                      ),
                                    )
                                  : null,
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffe3f0e1),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                            ),
                            child: Text(
                              "Lose \n Weight",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedGoal = Goal.keepWeight;
                              });
                            },
                            style: ButtonStyle(
                              shape: selectedGoal == Goal.keepWeight
                                  ? WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(32),
                                        side: const BorderSide(
                                          color: Color(0xff00a221),
                                          width: 4,
                                        ),
                                      ),
                                    )
                                  : null,
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffe3f0e1),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                            ),
                            child: Text(
                              "Keep \n Weight",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedGoal = Goal.gainWeight;
                              });
                            },
                            style: ButtonStyle(
                              shape: selectedGoal == Goal.gainWeight
                                  ? WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(32),
                                        side: const BorderSide(
                                          color: Color(0xff00a221),
                                          width: 4,
                                        ),
                                      ),
                                    )
                                  : null,
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffe3f0e1),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                            ),
                            child: Text(
                              "Gain \n Weight",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text('Sex'),
                    Row(
                      spacing: 24,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedSex = Sex.female;
                              });
                            },
                            style: ButtonStyle(
                              shape: selectedSex == Sex.female
                                  ? WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(32),
                                        side: const BorderSide(
                                          color: Color(0xff00a221),
                                          width: 4,
                                        ),
                                      ),
                                    )
                                  : null,
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffe3f0e1),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                            ),
                            child: Text("Female", textAlign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                selectedSex = Sex.male;
                              });
                            },
                            style: ButtonStyle(
                              shape: selectedSex == Sex.male
                                  ? WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(32),
                                        side: const BorderSide(
                                          color: Color(0xff00a221),
                                          width: 4,
                                        ),
                                      ),
                                    )
                                  : null,
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffe3f0e1),
                              ),
                              foregroundColor: WidgetStatePropertyAll(
                                Colors.black,
                              ),
                            ),
                            child: Text("Male", textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text("Date of Birth"),
                    TextFormField(
                      controller: dobController,
                      readOnly: true,
                      showCursor: false,
                      keyboardType: TextInputType.none,
                      onTap: _pickDob,
                      validator: (value) {
                        if (value == null) return "value can not be empty";
                        if (value.isEmpty) return "value can not be empty";

                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "dd/MM/yyyy",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/Icons/Today.png",
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Height"),
                    TextFormField(
                      onChanged: (_) {
                        setState(() {
                          selectedHeight = int.tryParse(heightController.text);
                        });
                      },
                      controller: heightController,
                      validator: (value) {
                        if (value == null) return "value can not be empty";
                        if (value.isEmpty) return "value can not be empty";
                        if (int.tryParse(value) == null) {
                          return "value needs to be an int";
                        }
                        if (int.parse(value).isNegative) {
                          return "value needs to be positive";
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        suffixText: "cm",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/Icons/Height.png",
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text("Weight"),
                    TextFormField(
                      onChanged: (_) {
                        setState(() {
                          selectedWeight = double.tryParse(
                            weightController.text,
                          );
                        });
                      },
                      controller: weightController,
                      validator: (value) {
                        if (value == null) return "value can not be empty";
                        if (value.isEmpty) return "value can not be empty";
                        if (int.tryParse(value) == null) {
                          return "value needs to be an int";
                        }
                        if (int.parse(value).isNegative) {
                          return "value needs to be positive";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixText: "kg",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/Icons/Monitor weight.png",
                            width: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 120,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(0xffe3f0e1),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Calculated Daily Need"),
                      Text(
                        "$calculatedKcal kcal",
                        style: TextStyle(
                          color: Color(0xff00a221),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: Get.width * .66,
                      child: TextButton(
                        onPressed: !isFormValid
                            ? null
                            : () {
                                if (formKey.currentState?.validate() ?? false) {
                                  personProvider.person.value =
                                      calculatedPerson!;
                                  Get.to(() => DietTrackerPage());
                                }
                              },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            !isFormValid
                                ? Color(0xff00a221).withAlpha(130)
                                : Color(0xff00a221),
                          ),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        child: Text("Get Started"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
