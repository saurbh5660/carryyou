import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'app_colors.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class Utils {

  static Widget searchWidget({
    double? elevation,
    Color? color,
    TextEditingController? controller,
    ShapeBorder? shape,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    EdgeInsetsGeometry? margin,
    bool? readOnly,
    bool? enabled,
    void Function()? onTap,
  }) {
    return Card(
      elevation: elevation,
      color: color ?? Colors.white,
      margin: margin,
      shape: shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly ?? false,
        onTap: onTap,
        enabled: enabled,
        cursorColor: Colors.black,
        style: const TextStyle(fontSize: 15, color: Colors.black),
        decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              size: 25,
            ),
            hintText: "Search...",
            hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15)),
      ),
    );
  }

  static Future<String> selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.greenColor,
              onSurface: AppColor.greenColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                backgroundColor:
                    WidgetStateColor.resolveWith((states) => AppColor.white),
                foregroundColor:
                    WidgetStateColor.resolveWith((states) => AppColor.blackColor),
                overlayColor:
                    WidgetStateColor.resolveWith((states) => AppColor.blackColor),
              ),
            ),
          ),
          child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!),
        );
      },
    );
    if (pickedTime != null) {
      return pickedTime.format(Get.context!).toString();
    }
    return "";
  }

  static PasswordStrength checkPasswordStrength(String password) {
    // Your regex for password strength checking
    RegExp passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()])[A-Za-z\d!@#$%^&*()]{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      return PasswordStrength.Weak;
    }

    if (password.length >= 12) {
      return PasswordStrength.Strong;
    } else if (password.length >= 8) {
      return PasswordStrength.Medium;
    } else {
      return PasswordStrength.Weak;
    }
  }

  static Color passwordStrengthColor(PasswordStrength passwordStrength) {
    Color color;
    switch (passwordStrength) {
      case PasswordStrength.Weak:
        color = Colors.red;
        break;
      case PasswordStrength.Medium:
        color = Colors.orange;
        break;
      case PasswordStrength.Strong:
        color = Colors.green;
      case PasswordStrength.Empty:
        color = Colors.transparent;
    }
    return color;
  }

  static String evaluatePasswordStrength(String password) {
    // Implement your logic to evaluate password strength
    // You can use regular expressions and other criteria
    // to classify the password as strong, medium, or weak.
    if (password.length >= 8) {
      return 'Strong';
    } else if (password.length >= 6) {
      return 'Medium';
    } else {
      return 'Weak';
    }
  }

  static Color getColorBasedOnStrength(String passwordStrength) {
    // Set color based on password strength
    switch (passwordStrength) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Weak':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static bool emailValidation(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  static bool validateUsername(String username) {
    // Implement your logic to validate the username using regular expressions
    // You can define specific rules such as minimum and maximum length,
    // allowed characters, etc.
    // For example, the following rule enforces alphanumeric usernames with
    // a length between 3 and 20 characters:
    RegExp regex = RegExp(r'^[a-zA-Z0-9]{3,20}$');
    return regex.hasMatch(username);
  }

  static List<int> generateYearList() {
    List<int> years = [];
    /*for (int i = DateTime.now().year - 10; i < DateTime.now().year; i++) {
      years.add(1);
    }*/
    years.add(DateTime.now().year);
    for (int i = DateTime.now().year + 1; i <= DateTime.now().year + 50; i++) {
      years.add(i);
    }
    return years;
  }

  static List<Map<String, String>> generateMonthsList() {
    List<Map<String, String>> months = [
      {'1': 'Jan'},
      {'2': 'Feb'},
      {'3': 'Mar'},
      {'4': 'Apr'},
      {'5': 'May'},
      {'6': 'Jun'},
      {'7': 'Jul'},
      {'8': 'Aug'},
      {'9': 'Sep'},
      {'10': 'Oct'},
      {'11': 'Nov'},
      {'12': 'Dec'},
    ];
    return months;
  }

  static void showLoading() {
    Get.context?.loaderOverlay.show();
  }
  static void hideLoading() {
    Get.context?.loaderOverlay.hide();
  }
  static void showSuccessToast({String? message}) {
    if (message == null) {
      return;
    }
    Get.closeAllSnackbars();
    Get.snackbar(
      "CarryYou Driver",
      message,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      icon: const Icon(
        Icons.notifications,
        color: Colors.white,
        size: 30,
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      backgroundColor: AppColor.yellowColor,
      borderRadius: 5,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      titleText: const Text(
        "CarryYou Driver",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      duration: const Duration(milliseconds: 1800),
      animationDuration: const Duration(milliseconds: 600),
      messageText: Text(
        message,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  static void showErrorToast({String? message}) {
    if (message == null) {
      return;
    }
    Get.closeAllSnackbars();
    Get.snackbar(
      "CarryYou Driver",
      message,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      icon: const Icon(
        Icons.notifications,
        color: Colors.white,
        size: 30,
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      backgroundColor: AppColor.redColor,
      borderRadius: 5,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.white,
      titleText: const Text(
        "CarryYou Driver",
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      duration: const Duration(milliseconds: 1800),
      animationDuration: const Duration(milliseconds: 600),
      messageText: Text(
        message,
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }

  /// Hide the soft keyboard.
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
  static bool compareTwoDates(DateTime startDate, DateTime endDate) {
    debugPrint("startDate====> $startDate   $endDate");
    return startDate.isAfter(endDate);
  }

  static bool dateTimeFormatCheck(String date) {
    try {
      DateTime convertedTime = DateTime.parse(date);
      debugPrint("converted Time : $convertedTime");
      return true;
    } on FormatException catch (e) {
      debugPrint("converted Time error : $e");
      return false;
    }
  }

  static String generateRouteId() {
    final now = DateTime.now();
    return "${now.year}"
        "${now.month.toString().padLeft(2, '0')}"
        "${now.day.toString().padLeft(2, '0')}"
        "${now.hour.toString().padLeft(2, '0')}"
        "${now.minute.toString().padLeft(2, '0')}"
        "${now.second.toString().padLeft(2, '0')}"
        "${now.millisecond.toString().padLeft(3, '0')}";
  }



  static StringColorPair orderStatus(String status) {
    switch (status) {
      case "0":
        return StringColorPair('pending', Colors.orange);
      case "1":
        return StringColorPair('accepted', Colors.blue);
      case "2":
        return StringColorPair('rejected', Colors.red);
      case "3":
        return StringColorPair('delivered', Colors.green);
      case "4":
        return StringColorPair('cancelled', Colors.red);
      case "5":
        return StringColorPair('ongoing', Colors.orange);

      default:
        return StringColorPair('', Colors.grey);
    }
  }

  static StringColorPair orderDriverStatus(String status) {
    switch (status) {
      case "0":
        return StringColorPair('pending', Colors.orange);
      case "1":
        return StringColorPair('accepted', Colors.blue);
      case "2":
        return StringColorPair('rejected', Colors.red);
      case "3":
        return StringColorPair('completed', Colors.green);
      case "4":
        return StringColorPair('cancelled', Colors.red);
      case "5":
        return StringColorPair('ongoing', Colors.orange);

      default:
        return StringColorPair('', Colors.grey);
    }
  }

  static String getTimeAgo(String dateTimeString) {
    DateTime pastTime = DateTime.parse(dateTimeString).toLocal();
    DateTime now = DateTime.now();
    Duration difference = now.difference(pastTime);

    if (difference.inSeconds < 60) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hr ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} week ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} month ago";
    } else {
      return "${(difference.inDays / 365).floor()} year ago";
    }
  }

  static String formatCount(int? count) {
    try {
      if (count == null || count < 0)
        return "0"; // Handle null or negative values

      if (count < 1000) {
        return count.toString(); // Show exact number
      } else if (count < 1000000) {
        return "${(count / 1000).toStringAsFixed(count % 1000 == 0 ? 0 : 1)}K";
      } else {
        return "${(count / 1000000).toStringAsFixed(count % 1000000 == 0 ? 0 : 1)}M";
      }
    } catch (e) {
      return "0";
    }
  }

  static bool isSubscriptionExpired(String? subscriptionEndDate) {
    if (subscriptionEndDate == null ||
        subscriptionEndDate.isEmpty ||
        subscriptionEndDate.toLowerCase() == 'null') {
      return true;
    }
    try {
      DateTime endDate = DateTime.parse(subscriptionEndDate);
      return DateTime.now().isAfter(endDate);
    } catch (e) {
      return true;
    }
  }

  static String calculateArrivalTime(String? minutesStr) {
    try {
      // 1. Handle null or empty strings immediately
      if (minutesStr == null || minutesStr.isEmpty) {
        return DateFormat('h:mma').format(DateTime.now()).toLowerCase();
      }

      // 2. Parse string to double first (in case it's "15.5") then to int
      // This is safer than int.tryParse for API data
      int minutes = double.parse(minutesStr).round();

      // 3. Add duration to current time
      DateTime arrivalDateTime = DateTime.now().add(Duration(minutes: minutes));

      // 4. Return formatted string
      return DateFormat('h:mma').format(arrivalDateTime).toLowerCase();
    } catch (e) {
      // If anything fails, log the error and return the current time as a fallback
      debugPrint("Error calculating arrival time: $e");
      return DateFormat('h:mma').format(DateTime.now()).toLowerCase();
    }
  }

 static String formatPrice(dynamic price) {
    if (price == null) return "\$0";

    if (price is String) {
      // If it's already a string with currency symbol
      if (price.startsWith('\$')) return price;
      // If it's a number string, add decimal places if needed
      if (double.tryParse(price) != null) {
        return "\$${double.parse(price).toStringAsFixed(2)}";
      }
      return "\$$price";
    } else if (price is num) {
      // Format number to 2 decimal places
      return "\$${price.toStringAsFixed(2)}";
    }
    return "\$0";
  }

  static String formatToTime(String dateStr) {
    try {
      DateTime dateTime = DateTime.parse(dateStr);
      return DateFormat("hh:mm a").format(dateTime.toLocal());
    } catch (e) {
      return "Invalid date";
    }
  }

 static String formatDate(String dateTimeString) {
    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }

  }

  static String convertTo12HourFormat(String time24) {
    try {
      DateTime dateTime = DateFormat("HH:mm:ss").parse(time24);
      String formattedTime = DateFormat("hh:mm a").format(dateTime);

      return formattedTime;
    } catch (e) {
      print("Error converting time: $e");
      return time24;
    }
  }

  static String dateTimeFormatter(
      {required String dateTime, required String format, required bool time}) {
    try {
      DateTime currentDateTime = DateTime.now();
      if (dateTimeFormatCheck(dateTime) && format.isNotEmpty) {
        String convertTime = DateFormat(format)
            .format(DateTime.parse(dateTime).toUtc().toLocal());
        return convertTime;
      } else if (format.isEmpty && time) {
        String date = DateFormat('yyyy-MM-dd').format(currentDateTime);
        String convertDate = DateTime.parse("$date $dateTime").toString();
        return convertDate;
      } else if (format.isEmpty) {
        String time = DateFormat('HH:mm:ss').format(currentDateTime);
        String convertDate = DateTime.parse("$dateTime $time").toString();
        return convertDate;
      } else if (time) {
        String date = DateFormat('yyyy-MM-dd').format(currentDateTime);
        String convertTime = DateFormat(format)
            .format(DateTime.parse("$date $dateTime").toUtc().toLocal());
        return convertTime;
      } else {
        String time = DateFormat('HH:mm:ss').format(currentDateTime);
        String convertDate = DateFormat(format)
            .format(DateTime.parse("$dateTime $time").toUtc().toLocal());
        return convertDate;
      }
    } on FormatException catch (e) {
      debugPrint("$e");

      var endDate = compareTwoDates(DateTime.now(), DateTime.parse(format));
      debugPrint("endDate $endDate");
      return endDate.toString();
    }
  }
  static bool isImage(String? fileName) {
    if (fileName == null || fileName.isEmpty) return false;
    final lower = fileName.toLowerCase();
    return lower.endsWith(".jpg") ||
        lower.endsWith(".jpeg") ||
        lower.endsWith(".png") ||
        lower.endsWith(".gif") ||
        lower.endsWith(".webp");
  }

  static String getFileNameFromUrl(String url) {
    try {
      return url.split('/').last;
    } catch (e) {
      print("Error extracting file name: $e");
      return "";
    }
  }

  static String formatDate1(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("d MMMM, yyyy").format(date);
    } catch (e) {
      print("Error formatting date: $e");
      return "";
    }
  }

 static String calculateAge(String birthDateString) {
    try {
      DateTime birthDate = DateTime.parse(birthDateString);
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age < 0 ? "0" : age.toString();
    } catch (e) {
      print("Error calculating age: $e");
      return "0"; // return 0 or any default value if something goes wrong
    }
  }

 /* static Future<void> openUrlInBrowser(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $urlString';
    }
  }
*/
}



class StringColorPair {
  final String stringValue;
  final Color colorValue;

  StringColorPair(this.stringValue, this.colorValue);
}

void printPrettyJson(dynamic data) {
  const encoder = JsonEncoder.withIndent('  ');
  final prettyString = encoder.convert(data);
  debugPrint(prettyString);
}

enum PasswordStrength {
  Empty,
  Weak,
  Medium,
  Strong,
}
