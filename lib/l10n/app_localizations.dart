import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Surprise Me'**
  String get appTitle;

  /// No description provided for @myCreations.
  ///
  /// In fr, this message translates to:
  /// **'Mes créations'**
  String get myCreations;

  /// No description provided for @joinedSurprises.
  ///
  /// In fr, this message translates to:
  /// **'Rejointes'**
  String get joinedSurprises;

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @yourSurprises.
  ///
  /// In fr, this message translates to:
  /// **'Vos Surprises'**
  String get yourSurprises;

  /// No description provided for @noSurpriseYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune surprise pour l\'instant'**
  String get noSurpriseYet;

  /// No description provided for @noSurpriseHint.
  ///
  /// In fr, this message translates to:
  /// **'Créez une surprise ou entrez\nun code pour en rejoindre une.'**
  String get noSurpriseHint;

  /// No description provided for @loadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les surprises'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @join.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get join;

  /// No description provided for @create.
  ///
  /// In fr, this message translates to:
  /// **'Créer'**
  String get create;

  /// No description provided for @joinSurpriseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une surprise'**
  String get joinSurpriseTitle;

  /// No description provided for @enterSharedCode.
  ///
  /// In fr, this message translates to:
  /// **'Entrez le code partagé par l\'organisateur.'**
  String get enterSharedCode;

  /// No description provided for @codeNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Code introuvable. Vérifiez et réessayez.'**
  String get codeNotFound;

  /// No description provided for @createSurprise.
  ///
  /// In fr, this message translates to:
  /// **'Créer une surprise'**
  String get createSurprise;

  /// No description provided for @identity.
  ///
  /// In fr, this message translates to:
  /// **'Identité'**
  String get identity;

  /// No description provided for @elementsCount.
  ///
  /// In fr, this message translates to:
  /// **'Éléments ({count})'**
  String elementsCount(int count);

  /// No description provided for @elementsHint.
  ///
  /// In fr, this message translates to:
  /// **'Chaque élément peut être révélé par un code distinct.'**
  String get elementsHint;

  /// No description provided for @titleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre *'**
  String get titleLabel;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get requiredField;

  /// No description provided for @subtitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sous-titre (optionnel)'**
  String get subtitleLabel;

  /// No description provided for @themeColor.
  ///
  /// In fr, this message translates to:
  /// **'Couleur thème'**
  String get themeColor;

  /// No description provided for @addElement.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un élément'**
  String get addElement;

  /// No description provided for @creating.
  ///
  /// In fr, this message translates to:
  /// **'Création…'**
  String get creating;

  /// No description provided for @createButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer la surprise'**
  String get createButton;

  /// No description provided for @addAtLeastOneElement.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au moins un élément.'**
  String get addAtLeastOneElement;

  /// No description provided for @completeAllElements.
  ///
  /// In fr, this message translates to:
  /// **'Complétez tous les éléments.'**
  String get completeAllElements;

  /// No description provided for @errorPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String errorPrefix(String error);

  /// No description provided for @linkCopied.
  ///
  /// In fr, this message translates to:
  /// **'Lien copié !'**
  String get linkCopied;

  /// No description provided for @surpriseCreated.
  ///
  /// In fr, this message translates to:
  /// **'Surprise créée !'**
  String get surpriseCreated;

  /// No description provided for @shareCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Partagez ce code pour que vos proches\npuissent découvrir la surprise.'**
  String get shareCodeHint;

  /// No description provided for @copy.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copy;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @shareMessage.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai une surprise pour toi ! 🎁\nOuvre ce lien pour la découvrir : {link}\n\nOu entre le code manuellement : {code}'**
  String shareMessage(String link, String code);

  /// No description provided for @backToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get backToHome;

  /// No description provided for @elementN.
  ///
  /// In fr, this message translates to:
  /// **'Élément {n}'**
  String elementN(int n);

  /// No description provided for @codeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code : {code}'**
  String codeLabel(String code);

  /// No description provided for @editSurprise.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la surprise'**
  String get editSurprise;

  /// No description provided for @editElementsHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur un élément pour le modifier, glissez pour réordonner.'**
  String get editElementsHint;

  /// No description provided for @titleRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le titre est requis.'**
  String get titleRequired;

  /// No description provided for @saving.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde…'**
  String get saving;

  /// No description provided for @saveButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer les modifications'**
  String get saveButton;

  /// No description provided for @newBadge.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get newBadge;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette surprise ?'**
  String get deleteDialogTitle;

  /// No description provided for @deleteOwnerContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible. La surprise et tous ses éléments seront définitivement supprimés.'**
  String get deleteOwnerContent;

  /// No description provided for @deleteGuestContent.
  ///
  /// In fr, this message translates to:
  /// **'La surprise sera retirée de votre liste. Vous pourrez la rejoindre à nouveau avec son code.'**
  String get deleteGuestContent;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get remove;

  /// No description provided for @ownerBanner.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes le créateur · Appuyez sur un code pour le révéler'**
  String get ownerBanner;

  /// No description provided for @shareWithCode.
  ///
  /// In fr, this message translates to:
  /// **'Partager · {code}'**
  String shareWithCode(String code);

  /// No description provided for @revealedElements.
  ///
  /// In fr, this message translates to:
  /// **'Éléments révélés'**
  String get revealedElements;

  /// No description provided for @enterCode.
  ///
  /// In fr, this message translates to:
  /// **'Entrer un code'**
  String get enterCode;

  /// No description provided for @shareSheetTitle.
  ///
  /// In fr, this message translates to:
  /// **'Partager \"{title}\"'**
  String shareSheetTitle(String title);

  /// No description provided for @shareAccessHint.
  ///
  /// In fr, this message translates to:
  /// **'Partagez ce code pour que vos proches\npuissent accéder à cette surprise.'**
  String get shareAccessHint;

  /// No description provided for @linkCopiedClipboard.
  ///
  /// In fr, this message translates to:
  /// **'Lien copié dans le presse-papier'**
  String get linkCopiedClipboard;

  /// No description provided for @editElement.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'élément'**
  String get editElement;

  /// No description provided for @newElement.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel élément'**
  String get newElement;

  /// No description provided for @elementTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre de l\'élément *'**
  String get elementTitleLabel;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est requis'**
  String get fieldRequired;

  /// No description provided for @selectDate.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une date *'**
  String get selectDate;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez sélectionner une date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseAddImage.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez ajouter une image'**
  String get pleaseAddImage;

  /// No description provided for @pleaseEnterLocation.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez indiquer un lieu'**
  String get pleaseEnterLocation;

  /// No description provided for @pleaseEnterWord.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez saisir un mot'**
  String get pleaseEnterWord;

  /// No description provided for @unlockCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code de déverrouillage *'**
  String get unlockCodeLabel;

  /// No description provided for @unlockCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : SECRET1'**
  String get unlockCodeHint;

  /// No description provided for @generateCode.
  ///
  /// In fr, this message translates to:
  /// **'Générer un code'**
  String get generateCode;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @elementTypeText.
  ///
  /// In fr, this message translates to:
  /// **'Texte'**
  String get elementTypeText;

  /// No description provided for @elementTypeImage.
  ///
  /// In fr, this message translates to:
  /// **'Image'**
  String get elementTypeImage;

  /// No description provided for @elementTypeDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get elementTypeDate;

  /// No description provided for @elementTypeLocation.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get elementTypeLocation;

  /// No description provided for @elementTypeWordGame.
  ///
  /// In fr, this message translates to:
  /// **'Mot mêlé'**
  String get elementTypeWordGame;

  /// No description provided for @elementTypePuzzle.
  ///
  /// In fr, this message translates to:
  /// **'Taquin'**
  String get elementTypePuzzle;

  /// No description provided for @messageContent.
  ///
  /// In fr, this message translates to:
  /// **'Contenu du message *'**
  String get messageContent;

  /// No description provided for @wordToGuessLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot à deviner *'**
  String get wordToGuessLabel;

  /// No description provided for @wordToGuessHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex : SURPRISE'**
  String get wordToGuessHint;

  /// No description provided for @wordGameHint.
  ///
  /// In fr, this message translates to:
  /// **'Les lettres seront mélangées. Le joueur devra les remettre dans le bon ordre.'**
  String get wordGameHint;

  /// No description provided for @enterYourCode.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre code'**
  String get enterYourCode;

  /// No description provided for @codeUnlocksElement.
  ///
  /// In fr, this message translates to:
  /// **'Chaque code débloque un élément de la surprise.'**
  String get codeUnlocksElement;

  /// No description provided for @codeAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Code accepté ! Un élément a été révélé.'**
  String get codeAccepted;

  /// No description provided for @invalidCode.
  ///
  /// In fr, this message translates to:
  /// **'Code invalide. Vérifiez et réessayez.'**
  String get invalidCode;

  /// No description provided for @unlock.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller'**
  String get unlock;

  /// No description provided for @unlocked.
  ///
  /// In fr, this message translates to:
  /// **'Débloqué'**
  String get unlocked;

  /// No description provided for @enterCodeToReveal.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un code pour révéler'**
  String get enterCodeToReveal;

  /// No description provided for @congratulations.
  ///
  /// In fr, this message translates to:
  /// **'Bravo ! Tu as trouvé le mot !'**
  String get congratulations;

  /// No description provided for @shuffleAgain.
  ///
  /// In fr, this message translates to:
  /// **'Mélanger à nouveau'**
  String get shuffleAgain;

  /// No description provided for @uploadError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur d\'envoi. Réessayez.'**
  String get uploadError;

  /// No description provided for @addImage.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une image'**
  String get addImage;

  /// No description provided for @gallery.
  ///
  /// In fr, this message translates to:
  /// **'Galerie'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In fr, this message translates to:
  /// **'Appareil photo'**
  String get camera;

  /// No description provided for @change.
  ///
  /// In fr, this message translates to:
  /// **'Changer'**
  String get change;

  /// No description provided for @galleryOrCamera.
  ///
  /// In fr, this message translates to:
  /// **'Galerie ou appareil photo'**
  String get galleryOrCamera;

  /// No description provided for @uploading.
  ///
  /// In fr, this message translates to:
  /// **'Envoi en cours…'**
  String get uploading;

  /// No description provided for @preview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu'**
  String get preview;

  /// No description provided for @previewBanner.
  ///
  /// In fr, this message translates to:
  /// **'Vous voyez la surprise comme le receveur la verra · Tous les éléments sont débloqués'**
  String get previewBanner;

  /// No description provided for @exitPreview.
  ///
  /// In fr, this message translates to:
  /// **'Quitter l\'aperçu'**
  String get exitPreview;

  /// No description provided for @linkDevice.
  ///
  /// In fr, this message translates to:
  /// **'Lier cet appareil'**
  String get linkDevice;

  /// No description provided for @linkDeviceHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre creator token pour lier cet appareil à vos surprises.'**
  String get linkDeviceHint;

  /// No description provided for @invalidToken.
  ///
  /// In fr, this message translates to:
  /// **'Token invalide.'**
  String get invalidToken;

  /// No description provided for @link.
  ///
  /// In fr, this message translates to:
  /// **'Lier'**
  String get link;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @creatorTokens.
  ///
  /// In fr, this message translates to:
  /// **'Creator tokens'**
  String get creatorTokens;

  /// No description provided for @creatorTokensHint.
  ///
  /// In fr, this message translates to:
  /// **'Ces tokens prouvent que vous êtes le créateur d\'une surprise. Conservez-les précieusement — ils permettent de lier un nouvel appareil à vos surprises.'**
  String get creatorTokensHint;

  /// No description provided for @noCreatedSurprises.
  ///
  /// In fr, this message translates to:
  /// **'Aucune surprise créée sur cet appareil.'**
  String get noCreatedSurprises;

  /// No description provided for @tokenCopied.
  ///
  /// In fr, this message translates to:
  /// **'Token copié !'**
  String get tokenCopied;

  /// No description provided for @surpriseId.
  ///
  /// In fr, this message translates to:
  /// **'ID : {id}'**
  String surpriseId(String id);

  /// No description provided for @localData.
  ///
  /// In fr, this message translates to:
  /// **'Données locales'**
  String get localData;

  /// No description provided for @localDataHint.
  ///
  /// In fr, this message translates to:
  /// **'Ces données sont stockées uniquement sur cet appareil.'**
  String get localDataHint;

  /// No description provided for @savedShareCodes.
  ///
  /// In fr, this message translates to:
  /// **'Codes de partage enregistrés'**
  String get savedShareCodes;

  /// No description provided for @unlockedCodes.
  ///
  /// In fr, this message translates to:
  /// **'Codes de déverrouillage mémorisés'**
  String get unlockedCodes;
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
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
