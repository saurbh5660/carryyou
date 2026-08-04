import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

var regexToRemoveEmoji =
    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

class CommonTextField extends StatefulWidget {
  final String? title;
  final FontWeight? titleFontWeight;
  final double? titleSpacing;
  final Color? titleColor;
  final Color? borderColor;
  final Color? focusBorderColor;
  final double? titleSize;
  final String? hintText;
  final String? counterText;
  final bool? obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isDense;
  final Color? hintTextColor;
  final Color? textColor;
  final Color? bgColor;
  final Color? cursorColor;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool? readOnly;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? enabled;
  final bool? focusNode;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final InputBorder? inputBorder;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final EdgeInsetsGeometry? contentPadding; // Added for customizable padding
  final EdgeInsets? scrollPadding;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding; // Existing padding parameter
  final TextAlignVertical? textAlignVertical;
  final double? elevation;
  final double? fontSize;
  final double? hintSize;
  final String? fontFamily;
  final String? hintFontFamily;
  final FontWeight? fontWeight;
  final FontWeight? hintWeight;
  final TextAlign? textAlign;
  final double? cursorHeight;
  bool? borderSide;

  CommonTextField({
    super.key,
    this.inputFormatters,
    this.hintText,
    this.obscureText,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.hintTextColor,
    this.textColor,
    this.maxLines,
    this.minLines,
    this.readOnly,
    this.textInputAction,
    this.keyboardType,
    this.enabled,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onTap,
    this.textCapitalization,
    this.maxLength,
    this.counterText,
    this.title,
    this.titleSpacing,
    this.titleColor,
    this.titleSize,
    this.focusBorderColor,
    this.cursorColor,
    this.validator,
    this.inputBorder,
    this.contentPadding, // Added here
    this.prefixIconConstraints,
    this.borderRadius,
    this.margin,
    this.padding,
    this.bgColor,
    this.textAlignVertical,
    this.elevation,
    this.fontSize,
    this.hintSize,
    this.fontWeight,
    this.hintWeight,
    this.suffixIconConstraints,
    this.focusedBorder,
    this.enabledBorder,
    this.textAlign,
    this.cursorHeight,
    this.scrollPadding,
    this.isDense,
    this.borderSide,
    this.fontFamily,
    this.hintFontFamily,
    this.titleFontWeight,
  });

  final regexToRemoveEmoji =
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])';

  final vehicleRegistrationRegex = RegExp(r'^[A-Z]{2}\d{2}[A-Z]{2}\d{4}$');
  final vehicleNumberRegex = RegExp(r'^[A-Za-z]{2}\d{2}[A-Za-z]{3}$');
  final drivingLicenseRegex = RegExp(r'^[A-Za-z]{2}\d{6}$');

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: (widget.title ?? "").isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title ?? "",
                  style: GoogleFonts.inter(
                    color: AppColor.blackColor,
                    fontSize: widget.titleSize ?? 16,
                    fontWeight: widget.titleFontWeight ?? FontWeight.w500,
                  ),
                ),
                SizedBox(height: widget.titleSpacing ?? 5),
              ],
            )),
        Material(
          elevation: widget.elevation ?? 0,
          shadowColor: Colors.black.withOpacity(0.25),
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 15),
          color: widget.bgColor ?? AppColor.white,
          child: TextFormField(
            textAlign: widget.textAlign ?? TextAlign.start,
            textAlignVertical:
            widget.textAlignVertical ?? TextAlignVertical.center,
            focusNode: _focusNode,
            inputFormatters: widget.inputFormatters,
            onTap: widget.onTap,
            textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
            cursorColor: widget.cursorColor ?? Colors.black,
            cursorWidth: 1.4,
            cursorHeight: widget.cursorHeight ?? 17,
            onChanged: widget.onChanged,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            enabled: widget.enabled,
            scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
            obscureText: widget.obscureText ?? false,
            obscuringCharacter: "●",
            readOnly: widget.readOnly ?? false,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            style: GoogleFonts.inter(
              color: widget.textColor,
              fontWeight: widget.fontWeight ?? FontWeight.w400,
              fontSize: widget.fontSize ?? 14,
            ),
            decoration: InputDecoration(
              isDense: widget.isDense ?? false,
              counterText: widget.counterText,
              filled: true,
              fillColor: Colors.transparent, // IMPORTANT for elevation
              hintText: widget.hintText ?? "",
              hintStyle: GoogleFonts.inter(
                color: widget.hintTextColor ?? AppColor.hintColor,
                fontWeight: widget.hintWeight ?? FontWeight.w400,
                fontSize: widget.hintSize ?? 14,
              ),
              enabledBorder: widget.enabledBorder ??
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 15),
                    borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.transparent,
                    ),
                  ),
              focusedBorder: widget.focusedBorder ??
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 15),
                    borderSide: BorderSide(
                      color: widget.focusBorderColor ?? Colors.transparent,
                    ),
                  ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              prefixIconConstraints: widget.prefixIconConstraints,
              suffixIconConstraints: widget.suffixIconConstraints,
            ),
          ),
        ),

      ],
    );
  }
}
