import 'package:carry_you_user/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

class MyBankAccountsScreen extends StatefulWidget {
  const MyBankAccountsScreen({super.key});

  @override
  State<MyBankAccountsScreen> createState() => _MyBankAccountsScreenState();
}

class _MyBankAccountsScreenState extends State<MyBankAccountsScreen> {
  // Data list for bank accounts
  final List<Map<String, String>> bankAccounts = [
    {
      "name": "Bank of America",
      "acc": "**** **** 9081",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Bank_of_America_logo.svg/2560px-Bank_of_America_logo.svg.png"
    },
    {
      "name": "Wells Fargo",
      "acc": "**** **** 9081",
      "logo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/20/Bank_of_America_logo.svg/2560px-Bank_of_America_logo.svg.png"

    },
  ];

  String selectedBank = "Wells Fargo";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Bank Accounts",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              "Default Payment Method",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 15),

            // --- Dynamic Bank List ---
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300), // Limits height for scrollable list
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bankAccounts.length,
                itemBuilder: (context, index) {
                  final bank = bankAccounts[index];
                  return _buildBankCard(
                    logoUrl: bank['logo']!,
                    bankName: bank['name']!,
                    accountNumber: bank['acc']!,
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // --- Add New Bank Button ---
            DottedBorder(
              color: Colors.grey.shade400,
              strokeWidth: 1,
              dashPattern: const [6, 3],
              borderType: BorderType.RRect,
              radius: const Radius.circular(15),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.addNewBankScreen);
                  },
                  child: Text(
                    "+ Add New Bank",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // --- Withdrawal Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Withdrawal Now",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildBankCard({
    required String logoUrl,
    required String bankName,
    required String accountNumber,
  }) {
    bool isSelected = selectedBank == bankName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedBank = bankName;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.black.withOpacity(0.1) : Colors.grey.shade100,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bank Logo
              Image.network(logoUrl, width: 80, height: 40, fit: BoxFit.contain),
              const SizedBox(width: 15),
              // Bank Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      accountNumber,
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Selection Radio
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey.shade400,
                          width: isSelected ? 7 : 2, // Thicker border simulates "filled" state
                        ),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.delete,
                        color: Colors.red.shade400,
                        size: 25,
                      ),
                    ),
                  ],

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}