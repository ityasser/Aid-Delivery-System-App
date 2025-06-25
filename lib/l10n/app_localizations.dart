import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Palestinian Ministry of Social Development'**
  String get appName;

  /// No description provided for @appName2.
  ///
  /// In en, this message translates to:
  /// **'Aid Registry'**
  String get appName2;

  /// No description provided for @rememberme.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberme;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get next;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'end'**
  String get end;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LogIn'**
  String get login;

  /// No description provided for @requireMobile.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get requireMobile;

  /// No description provided for @validMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter valid mobile number'**
  String get validMobile;

  /// No description provided for @requiredEmail.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get requiredEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Email must be valid'**
  String get validEmail;

  /// No description provided for @requiredPassword.
  ///
  /// In en, this message translates to:
  /// **'password is required'**
  String get requiredPassword;

  /// No description provided for @validPassword.
  ///
  /// In en, this message translates to:
  /// **'The password must be greater than 8 letters or numbers'**
  String get validPassword;

  /// No description provided for @pleaseTypeHere.
  ///
  /// In en, this message translates to:
  /// **'Please type here'**
  String get pleaseTypeHere;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'mobile number'**
  String get mobileNumber;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'full name'**
  String get full_name;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'confirm password'**
  String get confirm_password;

  /// No description provided for @password_not_match.
  ///
  /// In en, this message translates to:
  /// **'password do not match'**
  String get password_not_match;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgot_password;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Full address'**
  String get address;

  /// No description provided for @or_register_via.
  ///
  /// In en, this message translates to:
  /// **'or register via'**
  String get or_register_via;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @i_agree_to.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get i_agree_to;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get terms_conditions;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @receive_message_via_email.
  ///
  /// In en, this message translates to:
  /// **'You will receive an email with your verification code'**
  String get receive_message_via_email;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'send'**
  String get send;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'back'**
  String get back;

  /// No description provided for @personal_data.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get personal_data;

  /// No description provided for @service_providers.
  ///
  /// In en, this message translates to:
  /// **'Service Providers'**
  String get service_providers;

  /// No description provided for @help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get help_center;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @account_activation.
  ///
  /// In en, this message translates to:
  /// **'Account activation'**
  String get account_activation;

  /// No description provided for @enter_code_sent_email.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to you via email'**
  String get enter_code_sent_email;

  /// No description provided for @msg_not_login.
  ///
  /// In en, this message translates to:
  /// **'You are not logged in to benefit from the application services please log in'**
  String get msg_not_login;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancel;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @contact_whatsApp.
  ///
  /// In en, this message translates to:
  /// **'Contact via WhatsApp'**
  String get contact_whatsApp;

  /// No description provided for @ad_details.
  ///
  /// In en, this message translates to:
  /// **'Ad details'**
  String get ad_details;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @send_order.
  ///
  /// In en, this message translates to:
  /// **'Send Order'**
  String get send_order;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @enter_search_word.
  ///
  /// In en, this message translates to:
  /// **'Enter search word'**
  String get enter_search_word;

  /// No description provided for @add_ad.
  ///
  /// In en, this message translates to:
  /// **'Add Ad'**
  String get add_ad;

  /// No description provided for @add_al_ad.
  ///
  /// In en, this message translates to:
  /// **'Add Ad'**
  String get add_al_ad;

  /// No description provided for @up_photos_allowed.
  ///
  /// In en, this message translates to:
  /// **'Up to 15 photos are allowed'**
  String get up_photos_allowed;

  /// No description provided for @ad_title.
  ///
  /// In en, this message translates to:
  /// **'Ad Title'**
  String get ad_title;

  /// No description provided for @ad_description.
  ///
  /// In en, this message translates to:
  /// **'Ad Description'**
  String get ad_description;

  /// No description provided for @ad_category.
  ///
  /// In en, this message translates to:
  /// **'Ad category'**
  String get ad_category;

  /// No description provided for @ad_type.
  ///
  /// In en, this message translates to:
  /// **'Ad type'**
  String get ad_type;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @choose_date.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get choose_date;

  /// No description provided for @choose_time.
  ///
  /// In en, this message translates to:
  /// **'Choose Time'**
  String get choose_time;

  /// No description provided for @starting_price.
  ///
  /// In en, this message translates to:
  /// **'Starting price'**
  String get starting_price;

  /// No description provided for @highest_price.
  ///
  /// In en, this message translates to:
  /// **'highest price'**
  String get highest_price;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @neighborhood.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get neighborhood;

  /// No description provided for @contact_number.
  ///
  /// In en, this message translates to:
  /// **'contact number'**
  String get contact_number;

  /// No description provided for @detail_address.
  ///
  /// In en, this message translates to:
  /// **'Detail address'**
  String get detail_address;

  /// No description provided for @whatsapp_number.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp number'**
  String get whatsapp_number;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @company_name.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get company_name;

  /// No description provided for @license_number.
  ///
  /// In en, this message translates to:
  /// **'licensed operator number'**
  String get license_number;

  /// No description provided for @is_provider.
  ///
  /// In en, this message translates to:
  /// **'Are you a Service Provider?'**
  String get is_provider;

  /// No description provided for @is_store.
  ///
  /// In en, this message translates to:
  /// **'Are you a company?'**
  String get is_store;

  /// No description provided for @saving_changes.
  ///
  /// In en, this message translates to:
  /// **'Saving changes'**
  String get saving_changes;

  /// No description provided for @choose_plan.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that is right for you'**
  String get choose_plan;

  /// No description provided for @must_agree_to.
  ///
  /// In en, this message translates to:
  /// **'You must agree to'**
  String get must_agree_to;

  /// No description provided for @please_login.
  ///
  /// In en, this message translates to:
  /// **'Please login to the app'**
  String get please_login;

  /// No description provided for @search_page.
  ///
  /// In en, this message translates to:
  /// **'Search Page'**
  String get search_page;

  /// No description provided for @nointernet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get nointernet;

  /// No description provided for @send_success.
  ///
  /// In en, this message translates to:
  /// **'operation accomplished successfully'**
  String get send_success;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get done;

  /// No description provided for @filter_by.
  ///
  /// In en, this message translates to:
  /// **'Filter By'**
  String get filter_by;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @change_language.
  ///
  /// In en, this message translates to:
  /// **'change language'**
  String get change_language;

  /// No description provided for @service_category.
  ///
  /// In en, this message translates to:
  /// **'Service category'**
  String get service_category;

  /// No description provided for @service_type.
  ///
  /// In en, this message translates to:
  /// **'Service Type'**
  String get service_type;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @search_word.
  ///
  /// In en, this message translates to:
  /// **'search word'**
  String get search_word;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @choose_currency.
  ///
  /// In en, this message translates to:
  /// **'Choose Currency'**
  String get choose_currency;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @space.
  ///
  /// In en, this message translates to:
  /// **'space'**
  String get space;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'enter'**
  String get enter;

  /// No description provided for @my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get my_account;

  /// No description provided for @packages.
  ///
  /// In en, this message translates to:
  /// **'Packages'**
  String get packages;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @customer_reviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customer_reviews;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @address_on_map.
  ///
  /// In en, this message translates to:
  /// **'Determine The Address On The Map'**
  String get address_on_map;

  /// No description provided for @service_details.
  ///
  /// In en, this message translates to:
  /// **'Service details'**
  String get service_details;

  /// No description provided for @ad_number.
  ///
  /// In en, this message translates to:
  /// **'Ad number'**
  String get ad_number;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @ad_rating.
  ///
  /// In en, this message translates to:
  /// **'Ad Rating'**
  String get ad_rating;

  /// No description provided for @readmore.
  ///
  /// In en, this message translates to:
  /// **'read more'**
  String get readmore;

  /// No description provided for @readless.
  ///
  /// In en, this message translates to:
  /// **'read less'**
  String get readless;

  /// No description provided for @less.
  ///
  /// In en, this message translates to:
  /// **'less'**
  String get less;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @many_ads.
  ///
  /// In en, this message translates to:
  /// **'Number Ads'**
  String get many_ads;

  /// No description provided for @choose_phone_code.
  ///
  /// In en, this message translates to:
  /// **'Choose phone code of country'**
  String get choose_phone_code;

  /// No description provided for @account_verification.
  ///
  /// In en, this message translates to:
  /// **'Account verification'**
  String get account_verification;

  /// No description provided for @send_code_again.
  ///
  /// In en, this message translates to:
  /// **'Send the verification code again'**
  String get send_code_again;

  /// No description provided for @password_reset.
  ///
  /// In en, this message translates to:
  /// **'Password Reset'**
  String get password_reset;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirm_new_password;

  /// No description provided for @add_license_document.
  ///
  /// In en, this message translates to:
  /// **'Add a license document'**
  String get add_license_document;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'facebook'**
  String get facebook;

  /// No description provided for @twitter.
  ///
  /// In en, this message translates to:
  /// **'twitter'**
  String get twitter;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'google'**
  String get google;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'apple'**
  String get apple;

  /// No description provided for @you_have_account.
  ///
  /// In en, this message translates to:
  /// **'you have account'**
  String get you_have_account;

  /// No description provided for @code_verification.
  ///
  /// In en, this message translates to:
  /// **'code verification'**
  String get code_verification;

  /// No description provided for @go_to_link_ad.
  ///
  /// In en, this message translates to:
  /// **'go to link ad'**
  String get go_to_link_ad;

  /// No description provided for @account_promotion.
  ///
  /// In en, this message translates to:
  /// **'account promotion'**
  String get account_promotion;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get number;

  /// No description provided for @real_estate.
  ///
  /// In en, this message translates to:
  /// **'Estate'**
  String get real_estate;

  /// No description provided for @estate.
  ///
  /// In en, this message translates to:
  /// **'Estate'**
  String get estate;

  /// No description provided for @explore_by_cities.
  ///
  /// In en, this message translates to:
  /// **'Explore by cities'**
  String get explore_by_cities;

  /// No description provided for @latest_real_estate.
  ///
  /// In en, this message translates to:
  /// **'Latest real estate'**
  String get latest_real_estate;

  /// No description provided for @filtering.
  ///
  /// In en, this message translates to:
  /// **'filtering'**
  String get filtering;

  /// No description provided for @display_type.
  ///
  /// In en, this message translates to:
  /// **'display type'**
  String get display_type;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'statistics'**
  String get statistics;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'settings'**
  String get settings;

  /// No description provided for @support_tickets.
  ///
  /// In en, this message translates to:
  /// **'Support tickets'**
  String get support_tickets;

  /// No description provided for @connect_us.
  ///
  /// In en, this message translates to:
  /// **'connect us'**
  String get connect_us;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'delete account'**
  String get delete_account;

  /// No description provided for @please_agree_to_the_terms_and_conditions.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the terms and conditions'**
  String get please_agree_to_the_terms_and_conditions;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @special.
  ///
  /// In en, this message translates to:
  /// **'special'**
  String get special;

  /// No description provided for @explore_by_categories.
  ///
  /// In en, this message translates to:
  /// **'Explore by categories'**
  String get explore_by_categories;

  /// No description provided for @districts.
  ///
  /// In en, this message translates to:
  /// **'districts'**
  String get districts;

  /// No description provided for @do_you_want_to_logout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get do_you_want_to_logout;

  /// No description provided for @do_you_want_to_delete_the_account.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete the account?'**
  String get do_you_want_to_delete_the_account;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @must_choose.
  ///
  /// In en, this message translates to:
  /// **'Must Choose'**
  String get must_choose;

  /// No description provided for @show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get show_more;

  /// No description provided for @show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get show_less;

  /// No description provided for @estate_type.
  ///
  /// In en, this message translates to:
  /// **'estate type'**
  String get estate_type;

  /// No description provided for @private_ad.
  ///
  /// In en, this message translates to:
  /// **'Private Ad'**
  String get private_ad;

  /// No description provided for @add_private_ad.
  ///
  /// In en, this message translates to:
  /// **'add private ad'**
  String get add_private_ad;

  /// No description provided for @details_ad.
  ///
  /// In en, this message translates to:
  /// **'details ad'**
  String get details_ad;

  /// No description provided for @ad_link.
  ///
  /// In en, this message translates to:
  /// **'ad link'**
  String get ad_link;

  /// No description provided for @duration_ad.
  ///
  /// In en, this message translates to:
  /// **'duration ad'**
  String get duration_ad;

  /// No description provided for @description_ad.
  ///
  /// In en, this message translates to:
  /// **'description ad'**
  String get description_ad;

  /// No description provided for @advertise_now.
  ///
  /// In en, this message translates to:
  /// **'advertise now'**
  String get advertise_now;

  /// No description provided for @ad_extension.
  ///
  /// In en, this message translates to:
  /// **'Ad extension'**
  String get ad_extension;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'review'**
  String get review;

  /// No description provided for @real_estate_you_want_to_feature.
  ///
  /// In en, this message translates to:
  /// **'The real estate you want to feature'**
  String get real_estate_you_want_to_feature;

  /// No description provided for @ad_display_platform.
  ///
  /// In en, this message translates to:
  /// **'Ad display platform'**
  String get ad_display_platform;

  /// No description provided for @ad_display_method.
  ///
  /// In en, this message translates to:
  /// **'Ad display method'**
  String get ad_display_method;

  /// No description provided for @ad_appearance_city.
  ///
  /// In en, this message translates to:
  /// **'Ad appearance city'**
  String get ad_appearance_city;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'select'**
  String get select;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @added_date.
  ///
  /// In en, this message translates to:
  /// **'Added date'**
  String get added_date;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @imagesViewer.
  ///
  /// In en, this message translates to:
  /// **'Images Viewer'**
  String get imagesViewer;

  /// No description provided for @estate_information.
  ///
  /// In en, this message translates to:
  /// **'Estate Information'**
  String get estate_information;

  /// No description provided for @reference_number.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get reference_number;

  /// No description provided for @estate_description.
  ///
  /// In en, this message translates to:
  /// **'Estate Description'**
  String get estate_description;

  /// No description provided for @estate_features.
  ///
  /// In en, this message translates to:
  /// **'Estate Features'**
  String get estate_features;

  /// No description provided for @advantages_services.
  ///
  /// In en, this message translates to:
  /// **'Advantages and services'**
  String get advantages_services;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @internal_features.
  ///
  /// In en, this message translates to:
  /// **'Internal Features'**
  String get internal_features;

  /// No description provided for @external_features.
  ///
  /// In en, this message translates to:
  /// **'External Features'**
  String get external_features;

  /// No description provided for @report_ad.
  ///
  /// In en, this message translates to:
  /// **'Report this ad'**
  String get report_ad;

  /// No description provided for @similar_estates.
  ///
  /// In en, this message translates to:
  /// **'Similar Estates'**
  String get similar_estates;

  /// No description provided for @add_rating.
  ///
  /// In en, this message translates to:
  /// **'Add Rating'**
  String get add_rating;

  /// No description provided for @for_suggestions_questions.
  ///
  /// In en, this message translates to:
  /// **'For suggestions and Questions'**
  String get for_suggestions_questions;

  /// No description provided for @hint_contactus.
  ///
  /// In en, this message translates to:
  /// **'Send us your inquiries using the form below and our team will contact you as soon as possible'**
  String get hint_contactus;

  /// No description provided for @visit_us.
  ///
  /// In en, this message translates to:
  /// **'Visit Us'**
  String get visit_us;

  /// No description provided for @your_message.
  ///
  /// In en, this message translates to:
  /// **'your message'**
  String get your_message;

  /// No description provided for @go_to_add_link.
  ///
  /// In en, this message translates to:
  /// **'Go to ad link'**
  String get go_to_add_link;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @why_report_ad.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to report this ad?'**
  String get why_report_ad;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'company'**
  String get company;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'individual'**
  String get individual;

  /// No description provided for @problem_type.
  ///
  /// In en, this message translates to:
  /// **'problem type'**
  String get problem_type;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'about Us'**
  String get about_us;

  /// No description provided for @payment_policy.
  ///
  /// In en, this message translates to:
  /// **'payment policy'**
  String get payment_policy;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'terms of use'**
  String get terms_of_use;

  /// No description provided for @problem_description.
  ///
  /// In en, this message translates to:
  /// **'Problem description'**
  String get problem_description;

  /// No description provided for @minimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get minimum;

  /// No description provided for @maximum.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get maximum;

  /// No description provided for @add_your_estate.
  ///
  /// In en, this message translates to:
  /// **'add your estate'**
  String get add_your_estate;

  /// No description provided for @start_your_real_estate_journey.
  ///
  /// In en, this message translates to:
  /// **'Start your real estate journey'**
  String get start_your_real_estate_journey;

  /// No description provided for @our_partners.
  ///
  /// In en, this message translates to:
  /// **'our partners'**
  String get our_partners;

  /// No description provided for @remaining_ads.
  ///
  /// In en, this message translates to:
  /// **'remaining ads'**
  String get remaining_ads;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'image'**
  String get image;

  /// No description provided for @are_you_sure_to_delete_the_ad.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to delete the ad?'**
  String get are_you_sure_to_delete_the_ad;

  /// No description provided for @write_message.
  ///
  /// In en, this message translates to:
  /// **'Write Message'**
  String get write_message;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'sale'**
  String get sale;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'rent'**
  String get rent;

  /// No description provided for @estate_name.
  ///
  /// In en, this message translates to:
  /// **'estate name'**
  String get estate_name;

  /// No description provided for @price_display.
  ///
  /// In en, this message translates to:
  /// **'price display'**
  String get price_display;

  /// No description provided for @option.
  ///
  /// In en, this message translates to:
  /// **'option'**
  String get option;

  /// No description provided for @send_email.
  ///
  /// In en, this message translates to:
  /// **'send email'**
  String get send_email;

  /// No description provided for @unit_measure.
  ///
  /// In en, this message translates to:
  /// **'unit measure'**
  String get unit_measure;

  /// No description provided for @step_one_title.
  ///
  /// In en, this message translates to:
  /// **'Real estate data'**
  String get step_one_title;

  /// No description provided for @step_tow_title.
  ///
  /// In en, this message translates to:
  /// **'The location of estate'**
  String get step_tow_title;

  /// No description provided for @step_three_title.
  ///
  /// In en, this message translates to:
  /// **'Properties of estate'**
  String get step_three_title;

  /// No description provided for @step_four_title.
  ///
  /// In en, this message translates to:
  /// **'Images of estate'**
  String get step_four_title;

  /// No description provided for @step_five_title.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get step_five_title;

  /// No description provided for @step_six_title.
  ///
  /// In en, this message translates to:
  /// **'Advertising promotion'**
  String get step_six_title;

  /// No description provided for @step_seven_title.
  ///
  /// In en, this message translates to:
  /// **'Ad preview'**
  String get step_seven_title;

  /// No description provided for @upload_pictures_of_estate.
  ///
  /// In en, this message translates to:
  /// **'Upload pictures of estate'**
  String get upload_pictures_of_estate;

  /// No description provided for @add_a_video.
  ///
  /// In en, this message translates to:
  /// **'Add a video'**
  String get add_a_video;

  /// No description provided for @upload_to_YouTube.
  ///
  /// In en, this message translates to:
  /// **'Add videos to your properties from YouTube. Upload to YouTube and paste the link below'**
  String get upload_to_YouTube;

  /// No description provided for @link_video.
  ///
  /// In en, this message translates to:
  /// **'Link Video'**
  String get link_video;

  /// No description provided for @i_undertake_to_be_the_real_owner_of_estate.
  ///
  /// In en, this message translates to:
  /// **'I undertake to be the real owner of estate'**
  String get i_undertake_to_be_the_real_owner_of_estate;

  /// No description provided for @whatsapp_receive.
  ///
  /// In en, this message translates to:
  /// **'Enter your WhatsApp number to receive inquiries from tenants'**
  String get whatsapp_receive;

  /// No description provided for @non.
  ///
  /// In en, this message translates to:
  /// **'non'**
  String get non;

  /// No description provided for @submit_for_review.
  ///
  /// In en, this message translates to:
  /// **'Submit for review'**
  String get submit_for_review;

  /// No description provided for @add_features.
  ///
  /// In en, this message translates to:
  /// **'add features'**
  String get add_features;

  /// No description provided for @choose_your_package.
  ///
  /// In en, this message translates to:
  /// **'Choose your package'**
  String get choose_your_package;

  /// No description provided for @provide_estate_owners_packages.
  ///
  /// In en, this message translates to:
  /// **'We provide real estate owners with packages to subscribe to the platform with various benefits'**
  String get provide_estate_owners_packages;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'yearly'**
  String get yearly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @subscribe_now.
  ///
  /// In en, this message translates to:
  /// **'subscribe now'**
  String get subscribe_now;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'payment method'**
  String get payment_method;

  /// No description provided for @sub.
  ///
  /// In en, this message translates to:
  /// **'sub'**
  String get sub;

  /// No description provided for @the_final.
  ///
  /// In en, this message translates to:
  /// **'final'**
  String get the_final;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @do_you_have_coupon.
  ///
  /// In en, this message translates to:
  /// **'Do you have a discount coupon?'**
  String get do_you_have_coupon;

  /// No description provided for @coupon.
  ///
  /// In en, this message translates to:
  /// **'coupon'**
  String get coupon;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @estate_location.
  ///
  /// In en, this message translates to:
  /// **'Estate Location'**
  String get estate_location;

  /// No description provided for @no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get no_results_found;

  /// No description provided for @search_locations_recently.
  ///
  /// In en, this message translates to:
  /// **'Locations you searched most recently'**
  String get search_locations_recently;

  /// No description provided for @lowest_price.
  ///
  /// In en, this message translates to:
  /// **'Lowest price'**
  String get lowest_price;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @edite.
  ///
  /// In en, this message translates to:
  /// **'edite'**
  String get edite;

  /// No description provided for @rate_us.
  ///
  /// In en, this message translates to:
  /// **'rate us'**
  String get rate_us;

  /// No description provided for @upgrade_package.
  ///
  /// In en, this message translates to:
  /// **'Package upgrade'**
  String get upgrade_package;

  /// No description provided for @simple_steps_to_find_your_home.
  ///
  /// In en, this message translates to:
  /// **'Simple steps to find your home'**
  String get simple_steps_to_find_your_home;

  /// No description provided for @browse_your_estate.
  ///
  /// In en, this message translates to:
  /// **'Browse your estate'**
  String get browse_your_estate;

  /// No description provided for @sorry_there_are_no_properties.
  ///
  /// In en, this message translates to:
  /// **'Sorry, there are no properties'**
  String get sorry_there_are_no_properties;

  /// No description provided for @go_to.
  ///
  /// In en, this message translates to:
  /// **'Go to'**
  String get go_to;

  /// No description provided for @end_package.
  ///
  /// In en, this message translates to:
  /// **'Your current package subscription has expired'**
  String get end_package;

  /// No description provided for @please_renew_package.
  ///
  /// In en, this message translates to:
  /// **'Please renew your subscription to continue to benefit from our premium services'**
  String get please_renew_package;

  /// No description provided for @subscription_renewal.
  ///
  /// In en, this message translates to:
  /// **'Subscription renewal'**
  String get subscription_renewal;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Sorry, something went wrong'**
  String get error;

  /// No description provided for @error_try_again.
  ///
  /// In en, this message translates to:
  /// **'It seems that something went wrong, please try again'**
  String get error_try_again;

  /// No description provided for @try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get try_again;

  /// No description provided for @make_sure_net.
  ///
  /// In en, this message translates to:
  /// **'Make sure wifi or cellular data is turned on'**
  String get make_sure_net;

  /// No description provided for @sorry_not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you are not logged in'**
  String get sorry_not_logged_in;

  /// No description provided for @do_not_miss_chance_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Don\'t miss the chance to upgrade to take advantage of our enhanced services and upgraded experience'**
  String get do_not_miss_chance_upgrade;

  /// No description provided for @upgrade_your_package.
  ///
  /// In en, this message translates to:
  /// **'Upgrade your package now and enjoy additional features'**
  String get upgrade_your_package;

  /// No description provided for @provider_name.
  ///
  /// In en, this message translates to:
  /// **'Provider name'**
  String get provider_name;

  /// No description provided for @title_our_partners.
  ///
  /// In en, this message translates to:
  /// **'We have a group of success partners who share our excellence It works to achieve our goals'**
  String get title_our_partners;

  /// No description provided for @finish_selling_real_estate_ads.
  ///
  /// In en, this message translates to:
  /// **'Finish selling real estate ads'**
  String get finish_selling_real_estate_ads;

  /// No description provided for @previous_subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Previous subscriptions'**
  String get previous_subscriptions;

  /// No description provided for @user_type.
  ///
  /// In en, this message translates to:
  /// **'User type'**
  String get user_type;

  /// No description provided for @app_description.
  ///
  /// In en, this message translates to:
  /// **'An application for managing humanitarian aid, allowing project and beneficiary registration, tracking aid receipt, and efficient data management. It offers advanced features such as search, automatic updates, and Excel export.'**
  String get app_description;

  /// No description provided for @features_title.
  ///
  /// In en, this message translates to:
  /// **'📌 Key Features:'**
  String get features_title;

  /// No description provided for @feature_1.
  ///
  /// In en, this message translates to:
  /// **'Manage projects and beneficiaries with add, update, and delete options.'**
  String get feature_1;

  /// No description provided for @feature_2.
  ///
  /// In en, this message translates to:
  /// **'Sync data with API for automatic project and beneficiary updates.'**
  String get feature_2;

  /// No description provided for @feature_3.
  ///
  /// In en, this message translates to:
  /// **'Advanced search for beneficiaries using ID number.'**
  String get feature_3;

  /// No description provided for @feature_4.
  ///
  /// In en, this message translates to:
  /// **'Local storage using ObjectBox for fast performance.'**
  String get feature_4;

  /// No description provided for @feature_5.
  ///
  /// In en, this message translates to:
  /// **'Export data to Excel for shareable reports.'**
  String get feature_5;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
