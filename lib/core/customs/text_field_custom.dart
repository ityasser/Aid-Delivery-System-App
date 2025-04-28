import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart' as intl;

import '../theme/color.dart';

class TextFieldCustom extends StatefulWidget {
  String? initialValue;
  String hintText;
  String? labelHint;
  EdgeInsetsGeometry? contentPadding;
  Widget? prefixIcon;
  Widget? suffixIcon;
  TextInputType textInputType;
  Color? hintColor;
  Color fillColor;
  Color? slectedColor;
  Color? borderColor;
  Color? borderEnabledColor;
  bool obscureText;
  TextAlign? textAlign;
  TextEditingController? controller;
  TextInputAction textInputAction;
  bool enabled;
  bool hideCounter;
  bool expands;
  bool readOnly;
  int? maxLine = 1;
  int? minLines = 1;
  int? maxLength;
  ValueChanged<String>? onFieldSubmitted;
  String? fontFamily;
  FormFieldValidator<String>? validator;
  GestureTapCallback? onTap;
  TextDirection? textDirection;
  ValueChanged<String>? onChanged;
  FocusNode? focusNode;
  BoxConstraints? prefixIconConstraints;
  BoxConstraints? suffixIconConstraints;
  List<TextInputFormatter>? inputFormatters;
  double? heightFont;
  DateTime? date;
  AutovalidateMode? autovalidateMode;

      TextFieldCustom(
      {Key? key,
      this.hintText = '',
      this.focusNode,
      this.inputFormatters,
      this.labelHint,
      this.initialValue,
      this.maxLength,
      this.contentPadding,
      this.textAlign,
      this.suffixIcon,
      this.suffixIconConstraints,
      this.prefixIcon,
      this.prefixIconConstraints,
      this.onTap,
      this.textDirection,
      this.fillColor = Colors.white,
      this.slectedColor,
      this.hintColor,
      this.borderColor,
      this.maxLine = 1,
      this.minLines = 1,
      this.onFieldSubmitted,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      this.expands = false,
      this.controller,
      this.textInputAction = TextInputAction.next,
      this.enabled = true,
      this.readOnly = false,
      this.fontFamily,
      this.validator,
      this.hideCounter = false,
      this.heightFont,
      this.autovalidateMode,
      this.borderEnabledColor,
      this.onChanged})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<TextFieldCustom> {
  late String? labelHint = widget.labelHint;
  bool hasFocus = false;

  @override
  void didUpdateWidget(TextFieldCustom oldWidget) {
    if (isRTL(oldWidget.controller?.text) != isRTL(widget.controller?.text)) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => isRTL(widget.controller?.text));
    }
    super.didUpdateWidget(oldWidget);
  }

  bool isRTL(String? text) {
    if (text == null || text.isEmpty)
      return Directionality.of(context) == TextDirection.rtl;
    return intl.Bidi.detectRtlDirectionality(text);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onFocusChange: (hasFocusc) {
        setState(() {
          hasFocus = hasFocusc;
        });
      },
      child: TextFormField(
        focusNode: widget.focusNode,
        expands: widget.expands,
        scrollPhysics: BouncingScrollPhysics(),
        autofocus: true,
        onTap: widget.onTap ??
            () async {
              if(widget.textInputType == TextInputType.datetime) {
                widget.date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: widget.date ?? DateTime.now(),
                  lastDate: DateTime(2099),
                  useRootNavigator: false,
                  initialDatePickerMode: DatePickerMode.day,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                setState(() {
                  if (widget.date != null) {
                    widget.controller?.text = "${widget.date?.day}-${widget.date?.month}-${widget.date?.year}";
                  }
                });
              }
            },
        maxLength: widget.maxLength,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        onFieldSubmitted: widget.onFieldSubmitted ??
            (value) {
              FocusScope.of(context).nextFocus();
            },
        inputFormatters: widget.inputFormatters,
        validator: widget.validator,
        onChanged: (str) {
          setState(() {
            if (widget.onChanged != null) widget.onChanged!(str);
            // labelHint=(widget.text?.isEmpty??true)?null:widget.labelHint;
          });
        },

        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: widget.textInputType,
        autovalidateMode:widget. autovalidateMode,
        textInputAction: widget.textInputAction,
        textAlign: widget.textAlign != null
            ? widget.textAlign == TextAlign.start
                ? isRTL(widget.controller?.text)
                    ? TextAlign.start
                    : TextAlign.end
                : widget.textAlign == TextAlign.end
                    ? isRTL(widget.controller?.text)
                        ? TextAlign.end
                        : TextAlign.start
                    : widget.textAlign!
            : TextAlign.start
        // widget.controller?.text.isNotEmpty??false ? isRTL(widget.controller?.text)?TextAlign.start:TextAlign.start:TextAlign.start
        ,
        style: TextStyle(
          fontSize: 14.sp,
          color: ColorsUi.black,
          height: widget.heightFont ?? 1.2.h,
        ),
        maxLines: widget.maxLine,
        minLines: widget.minLines,
        textDirection: widget.textDirection ??
            (isRTL(widget.controller?.text)
                ? TextDirection.rtl
                : TextDirection.ltr),
        cursorColor: ColorsUi.secondary,
        textAlignVertical: TextAlignVertical.center,

        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.borderEnabledColor?? ColorsUi.primary),
              borderRadius: BorderRadius.all(Radius.circular(23.r))
          ),

          counter: widget.hideCounter ? const Offstage() : null,
          counterStyle: const TextStyle(
            height: 0.7,
          ),
          isDense: false,
          labelText: widget.labelHint,
          hintText: widget.hintText,
          contentPadding: widget.contentPadding ??
              EdgeInsetsDirectional.only(
                  start: 15.w, end: 10.w, top: widget.minLines!=null?20.h: 0.h, bottom: 0.h),
          hintTextDirection: widget.textDirection ??
              (isRTL(widget.controller?.text)
                  ? TextDirection.rtl
                  : TextDirection.ltr),
          fillColor: widget.fillColor,
          filled: true,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.textInputType == TextInputType.visiblePassword
              ? InkWell(
                  onTap: () async {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  child: Icon(
                    widget.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: ColorsUi.primary,
                  ))
              : widget.suffixIcon,
          prefixIconConstraints: widget.prefixIconConstraints ??
              BoxConstraints(minWidth: 40.w, maxHeight: 25.h, maxWidth: 80.w,),
          suffixIconConstraints: widget.suffixIconConstraints ??
              BoxConstraints(minWidth: 40.w, maxHeight: 42.h, maxWidth: 80.w),
        ),
      ),
    );
  }
}
