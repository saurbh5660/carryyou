import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../controller/faq_controller.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});
  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqController controller = Get.put(FaqController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.white,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColor.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => Get.back(),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
          ),
        ),
        title: Text(
          "Help & FAQ's",
          style: GoogleFonts.workSans(
            fontWeight: FontWeight.w700,
            color: AppColor.blackColor,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child:
          ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              // final item = controller.data[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        /* item.expanded =
                            !item.expanded;*/
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        // color: item.expanded?
                        color: Colors.white,
                        // : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.grey.shade300,

                          // color: item.expanded
                          //     ? Colors.blue
                          //     : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            // item.question ?? "",
                            '1.',
                            style: TextStyle(
                              fontFamily:
                              GoogleFonts.poppins().fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: Text(
                              // item.question ?? "",
                              'What is Lorem Ipsum?',
                              style: TextStyle(
                                fontFamily:
                                GoogleFonts.poppins().fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            // item.expanded
                            //     ? Icons.keyboard_arrow_up
                            //     : Icons.keyboard_arrow_right,
                            color: Colors.black,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expandable answer
                  // if (item.expanded)
                  //   Container(
                  //     width: double.infinity,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 20, vertical: 12),
                  //     margin: const EdgeInsets.only(bottom: 16),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade100,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Text(
                  //       item.answers ?? "",
                  //       style: TextStyle(
                  //         fontFamily: GoogleFonts.poppins().fontFamily,
                  //         fontSize: 13,
                  //         height: 1.5,
                  //         color: Colors.black87,
                  //       ),
                  //     ),
                  //   ),
                ],
              );
            },
          )
         /* Obx(() {
              return
                ListView.builder(
                itemCount: 15,
                itemBuilder: (context, index) {
                  // final item = controller.data[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                           *//* item.expanded =
                            !item.expanded;*//*
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            // color: item.expanded?
                            color: Colors.white,
                                // : Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: Colors.grey.shade300,

                              // color: item.expanded
                              //     ? Colors.blue
                              //     : Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                // item.question ?? "",
                                '1',
                                style: TextStyle(
                                  fontFamily:
                                  GoogleFonts.poppins().fontFamily,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 4,),
                              Expanded(
                                child: Text(
                                  // item.question ?? "",
                                  'What is Lorem Ipsum?',
                                  style: TextStyle(
                                    fontFamily:
                                    GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.blueColor
                                ),
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  // item.expanded
                                  //     ? Icons.keyboard_arrow_up
                                  //     : Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Expandable answer
                      // if (item.expanded)
                      //   Container(
                      //     width: double.infinity,
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 20, vertical: 12),
                      //     margin: const EdgeInsets.only(bottom: 16),
                      //     decoration: BoxDecoration(
                      //       color: Colors.grey.shade100,
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //     child: Text(
                      //       item.answers ?? "",
                      //       style: TextStyle(
                      //         fontFamily: GoogleFonts.poppins().fontFamily,
                      //         fontSize: 13,
                      //         height: 1.5,
                      //         color: Colors.black87,
                      //       ),
                      //     ),
                      //   ),
                    ],
                  );
                },
              );
            }
          ),*/
        ),
      ),
    );
  }
}
