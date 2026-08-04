import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app_colors.dart';
import 'app_text.dart';

AppBar commonAppBar({
  String? title,
  Widget? titleWidget,
  required bool isLeading,
  double? toolbarHeight,
  double? textSize,
  FontWeight? fontWeight,
  SystemUiOverlayStyle? systemOverlayStyle,
  Color? backgroundColor,
  Color? iconColor,
  Color? surfaceTintColor,
  Color? shadowColor,
  double? leadingWidth,
  ShapeBorder? shape,
  bool? centerTitle,
  double? elevation,
  Widget? leading,
  void Function()? onPressed,
  void Function()? onTap,
  List<Widget>? actions,
}) {
  return AppBar(
    shadowColor: shadowColor ?? Colors.transparent,
    shape: shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
    title: GestureDetector(
      onTap: onTap,
      child: titleWidget ??
          AppText(
            text: title ?? "",
            textSize: textSize ?? 18,
            color: Colors.white,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontFamily: 'Poppins',
          ),
    ),
    elevation: elevation ?? 0.0,
    toolbarHeight: toolbarHeight ?? 70,
    systemOverlayStyle: systemOverlayStyle ??
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
        ),
    leadingWidth: leadingWidth ?? 70,
    leading: isLeading
        ? Padding(
      padding: const EdgeInsets.all(22
      ),
      child: leading ??
          InkWell(
            onTap: () => onPressed != null ? onPressed() : Get.back(),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.appBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.arrow_back, color: AppColor.white,size: 30,),
            ),
          ),
    )
        : Container(),
    automaticallyImplyLeading: false,
    centerTitle: centerTitle ?? false,
    backgroundColor: backgroundColor ?? AppColor.appBlack,
    surfaceTintColor: surfaceTintColor ?? Colors.transparent,
    actions: actions,
  );
}
