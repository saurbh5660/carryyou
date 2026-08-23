import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/app_colors.dart';
import '../../../common/apputills.dart';

enum LegalDocType { terms, privacy }

class LegalDocSection {
  final String title;
  final String content;

  const LegalDocSection({required this.title, required this.content});
}

class LegalDocModal extends StatelessWidget {
  final LegalDocType docType;

  const LegalDocModal({super.key, required this.docType});

  static void show(BuildContext context, {required LegalDocType docType}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => LegalDocModal(docType: docType),
    );
  }

  String get _documentTitle {
    switch (docType) {
      case LegalDocType.terms:
        return 'Rider Terms of Service';
      case LegalDocType.privacy:
        return 'Privacy Policy';
    }
  }

  String get _versionInfo => 'Version 1.0 · Effective [date]';

  List<LegalDocSection> get _sections {
    switch (docType) {
      case LegalDocType.terms:
        return const [
          LegalDocSection(
            title: '1. The CarryU Platform',
            content:
                'CarryU is a technology platform that connects riders with independent drivers. CarryU does not provide transportation services ...',
          ),
          LegalDocSection(
            title: '2. Eligibility',
            content:
                'You must be at least 18 years old and able to form a binding contract to create a Rider account ...',
          ),
          LegalDocSection(
            title: '3. Fares, Fees and Payment',
            content:
                'Fares are shown before you confirm a request. You authorize CarryU to charge your selected payment method ...',
          ),
          LegalDocSection(
            title: '4. Rider Conduct',
            content:
                'You agree to wear a seat belt, not to interfere with the driver\'s operation of the vehicle, and to comply with applicable law ...',
          ),
          LegalDocSection(
            title: '5. Dispute Resolution; Arbitration',
            content:
                'Any dispute, claim or controversy arising out of or relating to these Terms will be settled by binding arbitration ...',
          ),
        ];
      case LegalDocType.privacy:
        return const [
          LegalDocSection(
            title: '1. Information We Collect',
            content:
                'Account details you provide (name, email, mobile number, birthdate), payment information handled by our payment processor, and trip information generated when you use the platform ...',
          ),
          LegalDocSection(
            title: '2. Location Information',
            content:
                'We collect precise location from your device while you use the app to match you with drivers, show your ride\'s progress, and support safety features ...',
          ),
          LegalDocSection(
            title: '3. How We Share Information',
            content:
                'With your driver to complete a trip; with service providers; and as required by law ...',
          ),
          LegalDocSection(
            title: '4. Your California Privacy Rights (CCPA/CPRA)',
            content:
                'You have the right to know, delete, and correct personal information, and to opt out of sale or sharing ...',
          ),
        ];
    }
  }

  Future<void> _handleDownloadPdf() async {
    const String samplePdfUrl =
        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
    final Uri url = Uri.parse(samplePdfUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Utils.showSuccessToast(message: 'Download PDF requested for $_documentTitle');
      }
    } catch (e) {
      Utils.showSuccessToast(message: 'Download PDF requested for $_documentTitle');
    }
  }

  void _handleEmailToMe() {
    Utils.showSuccessToast(
        message: 'A copy of $_documentTitle has been sent to your email.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Top Header Bar
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 18, bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.close, color: Colors.black, size: 22),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Document Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _documentTitle,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColor.blackColor,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Document Sections
                  ..._sections.map(
                    (section) => Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.title,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColor.blackColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            section.content,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Sticky Bottom Action Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleDownloadPdf,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Download PDF',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleEmailToMe,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Email to me',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
