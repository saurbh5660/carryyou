import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_colors.dart';

enum AppTextStyle { title, medium, regular, small }

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? underlineColor;
  final AppTextStyle? style;
  final bool? underline;
  final bool? strikeThrough;
  final double? textSize;
  final bool? capitalise;
  final int? maxLines;
  final TextAlign? textAlign;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final double? lineHeight;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? decorationThickness;
  final TextOverflow? overflow;
  final List<Shadow>? shadows;
  final bool? softWrap;
  final VoidCallback? onPressed; // Add onPressed parameter

  const AppText({
    super.key,
    required this.text,
    this.color,
    this.style,
    this.maxLines,
    this.textAlign,
    this.underline,
    this.textSize,
    this.fontFamily,
    this.fontWeight,
    this.lineHeight,
    this.fontStyle,
    this.underlineColor,
    this.strikeThrough,
    this.capitalise,
    this.letterSpacing,
    this.shadows,
    this.overflow,
    this.decorationThickness,
    this.softWrap,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Padding(
            padding: underline != null && underline!
                ? const EdgeInsets.only(bottom: 0.3)
                : EdgeInsets.zero,
            child: Text(
              softWrap: softWrap,
              capitalise ?? false ? text.toUpperCase() : (text).tr,
              maxLines: maxLines,
              overflow: maxLines != null ? TextOverflow.ellipsis : null,
              textAlign: textAlign,
              style: getStyle(
                color: color ?? AppColor.appTextColor,
                textSize ?? 14,
              ),
            ),
          ),
          if (underline ?? false)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: decorationThickness ?? 1,
                color: AppColor.bgColor,
              ),
            ),
        ],
      ),
    );
  }

  TextStyle getStyle(double textSize, {Color? color}) {
    return TextStyle(
      overflow: overflow,
      shadows: shadows,
      color: color,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight ?? getWeight(),
      fontSize: textSize,
      fontStyle: fontStyle ?? FontStyle.normal,
      height: lineHeight ?? 1.2,
      fontFamily: fontFamily ?? "Poppins",
      decorationThickness: decorationThickness ?? 0,
      decoration: strikeThrough != null && strikeThrough!
          ? TextDecoration.lineThrough
          : null,
    );
  }

  double getTextSize(double width) {
    switch (style) {
      case AppTextStyle.title:
        return width * 0.08;
      case AppTextStyle.medium:
        return width * 0.06;
      case AppTextStyle.small:
        return width * 0.02;
      default:
        return width * 0.04;
    }
  }

  FontWeight getWeight() {
    switch (style) {
      case AppTextStyle.title:
        return FontWeight.w600;
      case AppTextStyle.medium:
        return FontWeight.w500;
      case AppTextStyle.regular:
        return FontWeight.w400;
      case AppTextStyle.small:
        return FontWeight.w300;
      default:
        return FontWeight.w400;
    }
  }
}
