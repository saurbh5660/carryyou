import 'package:get/get.dart';

class WalletController extends GetxController {
  var balance = 5240.50.obs;

  // Mock data matching the UI style
  var transactions = <Map<String, dynamic>>[
    {'title': 'Uber Payment', 'date': 'Jan 17, 2:30 PM', 'amount': -45.00, 'type': 'debit'},
    {'title': 'Added to Wallet', 'date': 'Jan 16, 10:15 AM', 'amount': 100.00, 'type': 'credit'},
    {'title': 'Uber Payment', 'date': 'Jan 15, 4:00 PM', 'amount': -12.50, 'type': 'debit'},
  ].obs;
}