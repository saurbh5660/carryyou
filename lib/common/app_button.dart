import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_colors.dart';

class AppButton extends StatelessWidget {

  final String text;
  final Gradient? gradient;
  final Function onTap;
  final double? width;
  final double? borderWidth;
  final double? borderRadius;
  final double? scale;
  final Color? textColor;
  final Color? buttonColor;
  final Color? borderColor;
  final double? textSize;
  final double? elevation;
  final double? height;
  final bool? capitalise;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? margin;
  final String? icon1;
  final Color? color;
  final String? icon2;
  final String? fontFamily;
  final double? heightIcon1;
  final double? widthIcon1;
  final double? heightIcon2;
  final double? widthIcon2;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width,
    this.textColor,
    this.borderColor,
    this.textSize,
    this.fontWeight,
    this.height,
    this.capitalise,
    this.borderRadius,
    this.borderWidth,
    this.elevation,
    this.margin,
    this.gradient,
    this.buttonColor,
    this.icon1,
    this.icon2,
    this.fontFamily,
    this.color,
    this.scale,
    this.padding,
    this.heightIcon1,
    this.widthIcon1,
    this.heightIcon2,
    this.widthIcon2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        width: width ?? double.infinity,
        height: height ?? 58,
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color : color ?? AppColor.yellowColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 15),
          border:
              Border.all(color: AppColor.yellowColor, width: borderWidth ?? 1.0),

        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (icon1 != null) ...{
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    icon1!,
                    height: heightIcon1 ?? 24,
                    width: widthIcon1 ?? 24,
                    color: AppColor.white,
                    scale: scale ?? 1.0,
                  ),
                )
              } else ...{
                const SizedBox.shrink(),
              },
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Text(
                    text.tr,
                    style: TextStyle(
                      color:  AppColor.blackColor,
                      fontSize: textSize ?? 17.0,
                      fontWeight: fontWeight ?? FontWeight.w400,
                      fontFamily: fontFamily ?? "Poppins",
                    ),
                  ),
                ),
              ),
              if (icon2 != null) ...{
                Image.asset(
                  icon2!,
                  height: heightIcon2 ?? 24,
                  width: widthIcon2 ?? 24,
                )
              } else...{
                const SizedBox.shrink(),
              }

            ],
          ).paddingOnly(bottom: 1.0),
        ),
      ),
    );
  }
}
