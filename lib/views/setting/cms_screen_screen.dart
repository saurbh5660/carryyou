import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/app_colors.dart';
import '../../controller/content_controller.dart';

class CmsScreen extends StatefulWidget {
  const CmsScreen({super.key});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}
class _CmsScreenState extends State<CmsScreen> {
  final ContentController controller = Get.put(ContentController());

  String _cleanHtmlContent(String html) {
    if (html.isEmpty) return "";

    // Remove all inline styles that cause large spacing
    String cleanedHtml = html.replaceAll(RegExp(r'style="[^"]*"'), '');

    // Wrap with a div that provides proper styling
    return '''
    <div style="text-align: left; line-height: 1; font-family: 'Poppins', sans-serif;">
      $cleanedHtml
    </div>
    ''';
  }

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
          margin: EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        title: Text(
          Get.arguments?['from'] == 'terms' ? 'Terms & Conditions' : Get.arguments?['from'] == 'privacy' ? 'Privacy Policy' : 'About Us',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:  SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            physics: const ClampingScrollPhysics(),
            child: Text('Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy Lorem Ipsum is simply dummy text Lorem Ipsum is simply dummy text text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing  printing',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.black
              ),)
          /* Html(
              data: _cleanHtmlContent(controller.content.value.content ?? ""),
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1),
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                ),
                "div": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                  lineHeight: const LineHeight(1.4),
                ),
                "p": Style(
                  margin: Margins.only(bottom: 12),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1.4),
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w400,
                ),
                "h1": Style(
                  margin: Margins.only(bottom: 16, top: 8),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(24),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.left,
                ),
                "h2": Style(
                  margin: Margins.only(bottom: 14, top: 8),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                "h3": Style(
                  margin: Margins.only(bottom: 12, top: 8),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                "ul": Style(
                  margin: Margins.only(bottom: 12),
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                ),
                "ol": Style(
                  margin: Margins.only(bottom: 12),
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                ),
                "li": Style(
                  margin: Margins.only(bottom: 4),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1.4),
                  textAlign: TextAlign.left,
                ),
              },
            ),*/
        ),
       /* child: Obx(() {
         *//* if (controller.content.value.content == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }*//*

          return
            SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            physics: const ClampingScrollPhysics(),
            child: Text('Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing Lorem Ipsum is simply dummy text of the printing  printing',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.black
            ),)
           *//* Html(
              data: _cleanHtmlContent(controller.content.value.content ?? ""),
              style: {
                "body": Style(
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1),
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                ),
                "div": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                  lineHeight: const LineHeight(1.4),
                ),
                "p": Style(
                  margin: Margins.only(bottom: 12),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1.4),
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w400,
                ),
                "h1": Style(
                  margin: Margins.only(bottom: 16, top: 8),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(24),
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.left,
                ),
                "h2": Style(
                  margin: Margins.only(bottom: 14, top: 8),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                "h3": Style(
                  margin: Margins.only(bottom: 12, top: 8),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.left,
                ),
                "ul": Style(
                  margin: Margins.only(bottom: 12),
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                ),
                "ol": Style(
                  margin: Margins.only(bottom: 12),
                  padding: HtmlPaddings.zero,
                  textAlign: TextAlign.left,
                ),
                "li": Style(
                  margin: Margins.only(bottom: 4),
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                  lineHeight: const LineHeight(1.4),
                  textAlign: TextAlign.left,
                ),
              },
            ),*//*
          );
        }),*/
      ),
    );
  }
}