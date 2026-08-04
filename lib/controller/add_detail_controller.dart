import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddDetailController extends GetxController {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  RxList<String> genderList = RxList();
  RxString selectedGender = "".obs;

  @override
  void onInit() {
    super.onInit();
    genderList.clear();
    genderList.add('Male');
    genderList.add('Female');
    genderList.add('Other');
  }
}
