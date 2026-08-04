import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/db_helper.dart';
import '../../generated/assets.dart';
import '../../notification/notification_service.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  /// Drives the left-to-right "writing" reveal of the CarryU wordmark.
  late final AnimationController _writeController;
  late final Animation<double> _reveal;

  /// Blinking typing cursor that sweeps along with the reveal.
  late final AnimationController _cursorController;

  // Display size of the logo. The wordmark artwork is ~3.7:1, so we keep
  // that aspect ratio to avoid distortion (and so the reveal lines up with
  // the letters).
  static const double _logoWidth = 280;
  static const double _logoHeight = 76;
  static const Color _accent = Color(0xFF20C9BC);

  @override
  void initState() {
    super.initState();

    _writeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _reveal = CurvedAnimation(
      parent: _writeController,
      curve: Curves.easeInOut,
    );

    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _writeController.forward();

    Future.delayed(const Duration(seconds: 2), () async {
      final isLoggedIn = DbHelper().getIsLoggedIn();
      if (!isLoggedIn) {
        Get.offAllNamed(AppRoutes.onboardingView);
        return;
      }
      bool handled = await NotificationService().checkInitialMessage();
      if (!handled) {
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    });
  }

  @override
  void dispose() {
    _writeController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: true,
        child: Center(
          child: SizedBox(
            width: _logoWidth,
            height: _logoHeight,
            child: AnimatedBuilder(
              animation: Listenable.merge([_writeController, _cursorController]),
              builder: (context, _) {
                final fraction = _reveal.value;
                // The cursor stays visible while writing and fades out once
                // the whole word has been revealed.
                final cursorOpacity =
                fraction >= 1.0 ? 0.0 : _cursorController.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Progressive left-to-right reveal of the wordmark.
                    ClipRect(
                      clipper: _RevealClipper(fraction),
                      child: Image.asset(
                        Assets.icons.splashLogo.path,
                        width: _logoWidth,
                        height: _logoHeight,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Typing cursor sweeping along the reveal edge.
                    Positioned(
                      left: (_logoWidth * fraction) - 2,
                      top: 6,
                      bottom: 6,
                      child: Opacity(
                        opacity: cursorOpacity,
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            color: _accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Clips its child to a left-aligned rectangle whose width grows with
/// [fraction] (0 → fully hidden, 1 → fully visible), producing the
/// "writing" reveal.
class _RevealClipper extends CustomClipper<Rect> {
  final double fraction;

  _RevealClipper(this.fraction);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(covariant _RevealClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}
