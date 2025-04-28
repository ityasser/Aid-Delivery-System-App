import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:nocommission_app/core/customs/list/list_controller.dart';
import 'package:nocommission_app/core/customs/radio_custom.dart';
import 'package:nocommission_app/core/customs/custom_text.dart';
import 'package:nocommission_app/core/customs/text_field_custom.dart';
import 'package:nocommission_app/core/dialogs/bottom_sheet_custom.dart';
import 'package:nocommission_app/core/dialogs/bottom_sheet_list_widget.dart';
import 'package:nocommission_app/core/local.dart';
import 'package:nocommission_app/core/theme/color.dart';
import 'package:nocommission_app/core/utils/validations.dart';
import 'package:nocommission_app/models/area.dart';
import 'country_model.dart';
import 'lists.dart';
const String PropertyName = 'alpha_2_code';


typedef ValueChanged<T> = void Function(T value);


class CustomPhoneNumberInput extends StatefulWidget {
  final void Function(Area)? onConfirmCountry;

  final VoidCallback? onSubmit;
  final ValueChanged<String>? onFieldSubmitted;
  final String? Function(String?)? validator;

  TextEditingController? controller;
  final TextInputAction? keyboardAction;
  String? initialDialCode;
  String? hintText;
  String? labelHint;
  final int maxLength;
  final bool enabled;
  final TextAlign? textAlign;


  final List<String>? countries;
  EdgeInsetsGeometry? contentPadding;

  CustomPhoneNumberInput(
      {Key? key,
        required this.onConfirmCountry,
        this.onSubmit,
        this.onFieldSubmitted,
        this.validator,
        this.controller,
        this.keyboardAction,
        this.initialDialCode,
        this.contentPadding,

        this.maxLength = 9,
        this.enabled = true,

        this.textAlign,
        this.hintText,
        this.labelHint,

        this.countries})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<CustomPhoneNumberInput> with Validations {


  double selectorButtonBottomPadding = 0;
  ListController<Country>? listControllerCountries = Get.put(ListController<Country>(), tag: "Countries_phone_mobile");
  late Country country;
  List<Country> countries = [];
  bool isNotValid = true;

  @override
  void initState() {
    super.initState();
    loadCountries();


  }

  @override
  void setState(fn) {
    widget.controller ??= TextEditingController();
      super.setState(fn);

  }

  String generateFlagEmojiUnicode(String countryCode) {
    final base = 127397;

    return countryCode.codeUnits
        .map((e) => String.fromCharCode(base + e))
        .toList()
        .reduce((value, element) => value + element)
        .toString();
  }
  /// Changes Selector Button Country and Validate Change.
  void onCountryChanged(Country country) {
    setState(() {
      this.country = country;
      widget.initialDialCode= this.country.dialCode;
    });
    widget.onConfirmCountry!(Area(id:country.id,code:country.alpha2Code, title:getCountryName(country, locale),dialCode:country.dialCode??""));
  }

  void onCountryChangedDialCode(String? dialCode) {
    this.country = getInitialSelectedCountry(
      countries,
      dialCode ?? '',
    );
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onConfirmCountry!(Area(id:country.id,code:country.alpha2Code, name:getCountryName(country, locale),dialCode:country.dialCode??""));
    });*/
      }
  @override
  Widget build(BuildContext context) {

    if(widget.initialDialCode!=null)
      onCountryChangedDialCode( widget.initialDialCode);

    return TextFieldCustom(
      contentPadding:  widget.contentPadding ,
      controller: widget.controller,
      validator: widget.validator ?? validator,
      hintText: widget.hintText??"${AppLocal.getString().enter} ${AppLocal.getString().mobileNumber}",
      labelHint: widget.labelHint,
      textInputType:const TextInputType.numberWithOptions(signed: true, decimal: true)??TextInputType.phone,
      heightFont: 1.2.h,
      prefixIcon: Directionality.of(context) == TextDirection.ltr?dial():null,
      suffixIcon:Directionality.of(context) == TextDirection.ltr?null:dial(),

      key: widget.key ,
      enabled: widget.enabled,
      //textInputAction: widget.keyboardAction??TextInputAction.next,
      textAlign: widget.textAlign,

      onFieldSubmitted: widget.onFieldSubmitted,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
       FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onChanged,
    );
  }

  Widget dial(){
   return InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());

          showSheetBuilder(context, (context, scrollController) =>
              BottomSheetListWidget<Country>(
                  shrinkWrap: false,
                  title: "${AppLocal.getString().choose} ${AppLocal.getString().country}",
                  textConfirm: AppLocal.getString().confirm,
                  textCancel: AppLocal.getString().cancel,
                  listController: listControllerCountries,
                  scrollController: scrollController,
                  listItem: countries,
                  listItemSelected: [country],
                  onTapCancel: () {

                  },
                  onTapConfirm: (list) {
                    onCountryChanged(list.first);
                  },
                  itemBuilder:
                      (context, index, item, isSelected) {
                    return CustomRadio(
                      isExpanded: true,
                      controlAffinity:
                      ListTileControlAffinity.trailing,
                      secondary: Row(
                        children: [
                          Container(
                              width: 40.w,
                              child: TextCustom(item.dialCode?.trim() ?? "",size: 13.sp,align:TextAlign.start )),

                          TextCustom(generateFlagEmojiUnicode(item.alpha2Code ?? "")),
                        ],
                      ),
                      value: isSelected,
                      titleText: "${getCountryName(item, locale)}",
                      onChanged: (value) => listControllerCountries
                          ?.updateSelectionItem(
                          value, item, index),
                    );
                  }),
              isPadding: true);
        },
        child: Directionality.of(context) == TextDirection.rtl?Row(
        children: [
          SizedBox(width: 3.w,),

          TextCustom(country.dialCode ?? "+972",height: 1, size: 14.sp,textDirection: TextDirection.ltr),
          Icon(Icons.expand_more, size: 14.sp,
            color: ColorsUi.black,

          ),
          TextCustom(generateFlagEmojiUnicode(country.alpha2Code ?? ""),height: 1.h,
              size: 14.sp),



        ],
      ): Row(
        children: [
          SizedBox(width: 15.w,),
          TextCustom(generateFlagEmojiUnicode(country.alpha2Code ?? ""),height: 1.h, size: 14.sp),
          Icon(Icons.expand_more, size: 14.sp, color: ColorsUi.black,),
          TextCustom(country.dialCode ?? "+972",height: 1, size: 14.sp),
        ],
      ));

  }
  /// Listener that validates changes from the widget, returns a bool to
  /// the `ValueCallback` [widget.onInputValidated]


  /// Validate the phone number when a change occurs
  void onChanged(String value) {
    ///widget.onInputChanged!(Area(id:country.id,code:country.alpha2Code, name:getCountryName(country, locale),dialCode:country.dialCode??""),value);
  }




  /// loads countries from [Countries.countryList] and selected Country
  void loadCountries() {
    if (this.mounted) {
      List<Country> countries = getCountriesData(countries: widget.countries);
      Country country = getInitialSelectedCountry(
        countries,
        widget.initialDialCode ?? '',
      );


      // Remove potential duplicates
      countries = countries.toSet().toList();


      setState(() {
        this.countries = countries;
        this.country = country;

      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onCountryChanged(this.country);
      });
    }
  }
  static Country getInitialSelectedCountry(
      List<Country> countries, String dialCode) {
    return countries.firstWhere((country) => (country.dialCode?.endsWith(dialCode)??false),
        orElse: () => countries[0]);
  }
  List<Country> getCountriesData({required List<String>? countries}) {
    List jsonList = Countries.countryList;

    if (countries == null || countries.isEmpty) {
      return jsonList.map((country) => Country.fromJson(country)).toList();
    }
    List filteredList = jsonList.where((country) {
      return countries.contains(country[PropertyName]);
    }).toList();

    return filteredList.map((country) => Country.fromJson(country)).toList();
  }


  /// Validate and returns a validation error when [FormState] validate is called.
  ///
  /// Also updates [selectorButtonBottomPadding]
  String? validator(String? value) {
    return validateMobile(value);
  }


  void _phoneNumberSaved() {
    if (this.mounted) {
      String? parsedPhoneNumberString = widget.controller?.text.replaceAll(RegExp(r'[^\d+]'), '');

      String phoneNumber = '${this.country.dialCode ?? ''}' +( parsedPhoneNumberString??"");


    }
  }

  /// Saved the phone number when form is saved
  void onSaved(String? value) {
    _phoneNumberSaved();
  }

  /// Corrects duplicate locale
  String? get locale {
    return AppLocal.currentLocaleString;
  }
  String? getCountryName(Country country, String? locale) {
    if (locale != null && country.nameTranslations != null) {
      String? translated = country.nameTranslations![locale];
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
    return country.name;
  }
}







