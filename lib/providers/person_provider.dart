import 'package:diet_tracker/models/person.dart';
import 'package:get/get.dart';

class PersonProvider extends GetxController {
  final Rx<Person?> person = Rx(null);
}
