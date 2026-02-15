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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'The Pink Club'**
  String get appTitle;

  /// No description provided for @premiumMember.
  ///
  /// In en, this message translates to:
  /// **'Premium Member'**
  String get premiumMember;

  /// No description provided for @searchServices.
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get searchServices;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @premiumPartner.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM PARTNER'**
  String get premiumPartner;

  /// No description provided for @exclusiveOffering.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Offering'**
  String get exclusiveOffering;

  /// No description provided for @premiumAssistance.
  ///
  /// In en, this message translates to:
  /// **'Roadside'**
  String get premiumAssistance;

  /// No description provided for @strategicAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Strategic Advisory'**
  String get strategicAdvisory;

  /// No description provided for @medicalNetwork.
  ///
  /// In en, this message translates to:
  /// **'Medical Network'**
  String get medicalNetwork;

  /// No description provided for @healthAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Health Advisory'**
  String get healthAdvisory;

  /// No description provided for @eliteConcierge.
  ///
  /// In en, this message translates to:
  /// **'Elite Concierge'**
  String get eliteConcierge;

  /// No description provided for @vehicleSupplies.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Supplies'**
  String get vehicleSupplies;

  /// No description provided for @licenseServices.
  ///
  /// In en, this message translates to:
  /// **'License Services'**
  String get licenseServices;

  /// No description provided for @secondOpinion.
  ///
  /// In en, this message translates to:
  /// **'Second Opinion'**
  String get secondOpinion;

  /// No description provided for @exploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get exploreMore;

  /// No description provided for @exclusiveService.
  ///
  /// In en, this message translates to:
  /// **'EXCLUSIVE SERVICE'**
  String get exclusiveService;

  /// No description provided for @aboutService.
  ///
  /// In en, this message translates to:
  /// **'About Service'**
  String get aboutService;

  /// No description provided for @keyAdvantages.
  ///
  /// In en, this message translates to:
  /// **'Key Advantages'**
  String get keyAdvantages;

  /// No description provided for @processingInquiry.
  ///
  /// In en, this message translates to:
  /// **'Processing your inquiry...'**
  String get processingInquiry;

  /// No description provided for @requestServiceAccess.
  ///
  /// In en, this message translates to:
  /// **'Request Service Access'**
  String get requestServiceAccess;

  /// No description provided for @inquireBespokeAccess.
  ///
  /// In en, this message translates to:
  /// **'Inquire for Bespoke Access'**
  String get inquireBespokeAccess;

  /// No description provided for @ourIdentity.
  ///
  /// In en, this message translates to:
  /// **'Our Identity'**
  String get ourIdentity;

  /// No description provided for @aboutTagline.
  ///
  /// In en, this message translates to:
  /// **'Redefining premium assistance and strategic advisory for the select few.'**
  String get aboutTagline;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our Vision'**
  String get ourVision;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @contactExcellence.
  ///
  /// In en, this message translates to:
  /// **'Contact Excellence'**
  String get contactExcellence;

  /// No description provided for @getInTouch.
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// No description provided for @contactSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Our concierge team is here to assist you with any inquiries or bespoke requests.'**
  String get contactSupportDesc;

  /// No description provided for @messageReceived.
  ///
  /// In en, this message translates to:
  /// **'Your message has been received'**
  String get messageReceived;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @phoneWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp / Phone'**
  String get phoneWhatsApp;

  /// No description provided for @yourInquiry.
  ///
  /// In en, this message translates to:
  /// **'Your Inquiry'**
  String get yourInquiry;

  /// No description provided for @transmitMessage.
  ///
  /// In en, this message translates to:
  /// **'Transmit Message'**
  String get transmitMessage;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Field required'**
  String get fieldRequired;

  /// No description provided for @exclusiveMembership.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Membership'**
  String get exclusiveMembership;

  /// No description provided for @membershipSuccess.
  ///
  /// In en, this message translates to:
  /// **'Membership secured successfully'**
  String get membershipSuccess;

  /// No description provided for @choosePrivilege.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Privilege'**
  String get choosePrivilege;

  /// No description provided for @choosePackageDesc.
  ///
  /// In en, this message translates to:
  /// **'Select the package that best fits your bespoke lifestyle.'**
  String get choosePackageDesc;

  /// No description provided for @continueAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Continue Authentication'**
  String get continueAuthentication;

  /// No description provided for @personalIdentity.
  ///
  /// In en, this message translates to:
  /// **'Personal Identity'**
  String get personalIdentity;

  /// No description provided for @identityStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your authentication to proceed with the membership.'**
  String get identityStepDesc;

  /// No description provided for @fullLegalName.
  ///
  /// In en, this message translates to:
  /// **'Full Legal Name'**
  String get fullLegalName;

  /// No description provided for @primaryContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Primary Contact Number'**
  String get primaryContactNumber;

  /// No description provided for @residencyAddress.
  ///
  /// In en, this message translates to:
  /// **'Residency Address'**
  String get residencyAddress;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @proceedToVehicle.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Vehicle Details'**
  String get proceedToVehicle;

  /// No description provided for @vehicleSpecification.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Specification'**
  String get vehicleSpecification;

  /// No description provided for @vehicleStepDesc.
  ///
  /// In en, this message translates to:
  /// **'Register your primary vehicle for club eligibility.'**
  String get vehicleStepDesc;

  /// No description provided for @manufacturerBrand.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer / Brand'**
  String get manufacturerBrand;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @manufactureYear.
  ///
  /// In en, this message translates to:
  /// **'Manufacture Year'**
  String get manufactureYear;

  /// No description provided for @plateIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Plate Identifier'**
  String get plateIdentifier;

  /// No description provided for @chassisVin.
  ///
  /// In en, this message translates to:
  /// **'Chassis VIN Number'**
  String get chassisVin;

  /// No description provided for @preferredPayment.
  ///
  /// In en, this message translates to:
  /// **'Preferred Payment'**
  String get preferredPayment;

  /// No description provided for @confirmMembership.
  ///
  /// In en, this message translates to:
  /// **'Confirm Membership'**
  String get confirmMembership;

  /// No description provided for @selectPackageFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a package first'**
  String get selectPackageFirst;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @navServices.
  ///
  /// In en, this message translates to:
  /// **'SERVICES'**
  String get navServices;

  /// No description provided for @navPartners.
  ///
  /// In en, this message translates to:
  /// **'PARTNERS'**
  String get navPartners;

  /// No description provided for @navMembership.
  ///
  /// In en, this message translates to:
  /// **'MEMBERSHIP'**
  String get navMembership;

  /// No description provided for @navContact.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get navContact;

  /// No description provided for @navIdentity.
  ///
  /// In en, this message translates to:
  /// **'IDENTITY'**
  String get navIdentity;

  /// No description provided for @bespokePartners.
  ///
  /// In en, this message translates to:
  /// **'Bespoke Partners'**
  String get bespokePartners;

  /// No description provided for @contactNotFound.
  ///
  /// In en, this message translates to:
  /// **'Contact information not found'**
  String get contactNotFound;

  /// No description provided for @chooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get chooseYourPlan;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noPackagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No packages available'**
  String get noPackagesAvailable;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error: Please check your internet connection'**
  String get networkError;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout: Please try again'**
  String get requestTimeout;

  /// No description provided for @invalidDataFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid data format from server'**
  String get invalidDataFormat;

  /// No description provided for @failedLoadPackages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load packages'**
  String get failedLoadPackages;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
