import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/apputills.dart';
import '../../controller/content_controller.dart';

class CmsScreen extends StatefulWidget {
  const CmsScreen({super.key});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {
  final ContentController controller = Get.put(ContentController());

  Future<void> _handleDownloadPdf(String? fallbackPdfUrl) async {
    final String typeStr = Get.arguments?['type']?.toString() ??
        (Get.arguments?['from'] == 'privacy' ? 'privacy_policy' : 'driver_terms');

    final String? apiPdfUrl = await controller.fetchDownloadPdfUrl(typeStr);
    final String targetUrl = (apiPdfUrl != null && apiPdfUrl.isNotEmpty)
        ? apiPdfUrl
        : (fallbackPdfUrl ??
            "http://15.206.216.86:4005/documents/${controller.getDownloadType(typeStr) == 2 ? 'privacy_policy_v1.0' : 'terms_conditions_v1.0'}.pdf");

    final Uri url = Uri.parse(targetUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Utils.showSuccessToast(message: "Download PDF requested.");
      }
    } catch (e) {
      Utils.showSuccessToast(message: "Download PDF requested.");
    }
  }

  Widget _buildContentWidget(String htmlContent) {
    final String decoded = htmlContent
        .replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'&amp;', caseSensitive: false), '&')
        .replaceAll(RegExp(r'&lt;', caseSensitive: false), '<')
        .replaceAll(RegExp(r'&gt;', caseSensitive: false), '>')
        .replaceAll(RegExp(r'&quot;', caseSensitive: false), '"')
        .replaceAll(RegExp(r'&#39;', caseSensitive: false), "'");

    final List<String> paragraphs = decoded
        .split(RegExp(r'</p>|<br\s*/?>\s*<br\s*/?>', caseSensitive: false))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      final String cleanText = decoded.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      return Text(
        cleanText,
        style: GoogleFonts.inter(fontSize: 14, height: 1.55, color: Colors.grey.shade800),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((p) {
        final Match? boldMatch = RegExp(r'<b[^>]*>(.*?)</b>', caseSensitive: false).firstMatch(p);
        String? title;
        String body = p.replaceAll(RegExp(r'<[^>]*>'), '').trim();

        if (boldMatch != null) {
          title = boldMatch.group(1)?.replaceAll(RegExp(r'<[^>]*>'), '').trim();
          if (title != null && title.isNotEmpty && body.startsWith(title)) {
            body = body.substring(title.length).trim();
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null && title.isNotEmpty) ...[
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
              ],
              if (body.isNotEmpty)
                Text(
                  body,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade800,
                    height: 1.55,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getScreenTitle() {
    final String type = Get.arguments?['type']?.toString() ??
        (Get.arguments?['from'] == 'privacy' ? 'privacy_policy' : 'driver_terms');
    if (type == 'privacy_policy' || type == 'privacy' || type == '2') {
      return 'Privacy Policy';
    } else if (type == 'about_us' || type == '1') {
      return 'About Us';
    } else {
      return 'Rider Terms of Service';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFAFAFA),
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFAFAFA),
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 22),
                onPressed: () => Get.back(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Text(
                  'Close',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          final data = controller.cmsData.value;
          if (data == null) {
            return Center(
              child: Text(
                'No content available.',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey),
              ),
            );
          }

          final String headingTitle = (data.title != null && data.title!.isNotEmpty)
              ? data.title!
              : _getScreenTitle();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Document Title & Version Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headingTitle,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version ${data.getFormattedVersion()} · Effective ${data.getFormattedEffectiveDate()}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Document Card Container
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      child: _buildContentWidget(data.contentHtml ?? ''),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Bottom Sticky Action Bar with "Download PDF" button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleDownloadPdf(data.pdfUrl),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_downward,
                            size: 18,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Download PDF',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}