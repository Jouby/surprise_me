// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Surprise Me';

  @override
  String get myCreations => 'Mes créations';

  @override
  String get joinedSurprises => 'Rejointes';

  @override
  String get refresh => 'Actualiser';

  @override
  String get yourSurprises => 'Vos Surprises';

  @override
  String get noSurpriseYet => 'Aucune surprise pour l\'instant';

  @override
  String get noSurpriseHint =>
      'Créez une surprise ou entrez\nun code pour en rejoindre une.';

  @override
  String get loadError => 'Impossible de charger les surprises';

  @override
  String get retry => 'Réessayer';

  @override
  String get join => 'Rejoindre';

  @override
  String get create => 'Créer';

  @override
  String get joinSurpriseTitle => 'Rejoindre une surprise';

  @override
  String get enterSharedCode => 'Entrez le code partagé par l\'organisateur.';

  @override
  String get codeNotFound => 'Code introuvable. Vérifiez et réessayez.';

  @override
  String get createSurprise => 'Créer une surprise';

  @override
  String get identity => 'Identité';

  @override
  String elementsCount(int count) {
    return 'Éléments ($count)';
  }

  @override
  String get elementsHint =>
      'Chaque élément peut être révélé par un code distinct.';

  @override
  String get titleLabel => 'Titre *';

  @override
  String get requiredField => 'Requis';

  @override
  String get subtitleLabel => 'Sous-titre (optionnel)';

  @override
  String get themeColor => 'Couleur thème';

  @override
  String get addElement => 'Ajouter un élément';

  @override
  String get creating => 'Création…';

  @override
  String get createButton => 'Créer la surprise';

  @override
  String get addAtLeastOneElement => 'Ajoutez au moins un élément.';

  @override
  String get completeAllElements => 'Complétez tous les éléments.';

  @override
  String errorPrefix(String error) {
    return 'Erreur : $error';
  }

  @override
  String get genericError => 'Une erreur est survenue. Veuillez réessayer.';

  @override
  String get linkCopied => 'Lien copié !';

  @override
  String get surpriseCreated => 'Surprise créée !';

  @override
  String get shareCodeHint =>
      'Partagez ce code pour que vos proches\npuissent découvrir la surprise.';

  @override
  String get copy => 'Copier';

  @override
  String get share => 'Partager';

  @override
  String shareMessage(String link, String code) {
    return 'J\'ai une surprise pour toi ! 🎁\nOuvre ce lien pour la découvrir : $link\n\nOu entre le code manuellement : $code';
  }

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String elementN(int n) {
    return 'Élément $n';
  }

  @override
  String codeLabel(String code) {
    return 'Code : $code';
  }

  @override
  String get editSurprise => 'Modifier la surprise';

  @override
  String get editElementsHint =>
      'Appuyez sur un élément pour le modifier, glissez pour réordonner.';

  @override
  String get titleRequired => 'Le titre est requis.';

  @override
  String get saving => 'Sauvegarde…';

  @override
  String get saveButton => 'Enregistrer les modifications';

  @override
  String get newBadge => 'Nouveau';

  @override
  String get deleteDialogTitle => 'Supprimer cette surprise ?';

  @override
  String get deleteOwnerContent =>
      'Cette action est irréversible. La surprise et tous ses éléments seront définitivement supprimés.';

  @override
  String get deleteGuestContent =>
      'La surprise sera retirée de votre liste. Vous pourrez la rejoindre à nouveau avec son code.';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get remove => 'Retirer';

  @override
  String get ownerBanner =>
      'Vous êtes le créateur · Appuyez sur un code pour le révéler';

  @override
  String shareWithCode(String code) {
    return 'Partager · $code';
  }

  @override
  String get revealedElements => 'Éléments révélés';

  @override
  String get enterCode => 'Entrer un code';

  @override
  String shareSheetTitle(String title) {
    return 'Partager \"$title\"';
  }

  @override
  String get shareAccessHint =>
      'Partagez ce code pour que vos proches\npuissent accéder à cette surprise.';

  @override
  String get linkCopiedClipboard => 'Lien copié dans le presse-papier';

  @override
  String get editElement => 'Modifier l\'élément';

  @override
  String get newElement => 'Nouvel élément';

  @override
  String get elementTitleLabel => 'Titre de l\'élément *';

  @override
  String get fieldRequired => 'Ce champ est requis';

  @override
  String get selectDate => 'Sélectionner une date *';

  @override
  String get pleaseSelectDate => 'Veuillez sélectionner une date';

  @override
  String get pleaseAddImage => 'Veuillez ajouter une image';

  @override
  String get pleaseEnterLocation => 'Veuillez indiquer un lieu';

  @override
  String get pleaseEnterWord => 'Veuillez saisir un mot';

  @override
  String get unlockCodeLabel => 'Code de déverrouillage *';

  @override
  String get unlockCodeHint => 'Ex : SECRET1';

  @override
  String get unlockCodeInfo =>
      "Ce code est celui que le destinataire devra saisir pour révéler cet élément. Tu peux le communiquer à l'oral, par SMS, ou le cacher dans un autre élément.";

  @override
  String get generateCode => 'Générer un code';

  @override
  String get solveCodeLabel => 'Code récompense (optionnel)';

  @override
  String get solveCodeHint => 'Ex : NIVEAU2 — laisse vide si aucun';

  @override
  String get solveCodeInfo =>
      "Optionnel. Ce code sera automatiquement saisi quand le destinataire réussit ce jeu, débloquant ainsi un autre élément de la surprise sans qu'il ait besoin de le taper.";

  @override
  String get save => 'Enregistrer';

  @override
  String get add => 'Ajouter';

  @override
  String get elementGroupContent => 'Contenu';

  @override
  String get elementGroupGames => 'Jeux';

  @override
  String get elementTypeText => 'Texte';

  @override
  String get elementTypeImage => 'Image';

  @override
  String get elementTypeDate => 'Date';

  @override
  String get elementTypeLocation => 'Lieu';

  @override
  String get elementTypeWordGame => 'Mot mêlé';

  @override
  String get elementTypePuzzle => 'Taquin';

  @override
  String get messageContent => 'Contenu du message *';

  @override
  String get wordToGuessLabel => 'Mot à deviner *';

  @override
  String get wordToGuessHint => 'Ex : SURPRISE';

  @override
  String get wordGameHint =>
      'Les lettres seront mélangées. Le joueur devra les remettre dans le bon ordre.';

  @override
  String get enterYourCode => 'Entrez votre code';

  @override
  String get codeUnlocksElement =>
      'Chaque code débloque un élément de la surprise.';

  @override
  String get codeAccepted => 'Code accepté ! Un élément a été révélé.';

  @override
  String get invalidCode => 'Code invalide. Vérifiez et réessayez.';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get unlocked => 'Débloqué';

  @override
  String get enterCodeToReveal => 'Entrez un code pour révéler';

  @override
  String get congratulations => 'Bravo ! Tu as trouvé le mot !';

  @override
  String get shuffleAgain => 'Mélanger à nouveau';

  @override
  String get uploadError => 'Erreur d\'envoi. Réessayez.';

  @override
  String get addImage => 'Ajouter une image';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Appareil photo';

  @override
  String get change => 'Changer';

  @override
  String get galleryOrCamera => 'Galerie ou appareil photo';

  @override
  String get uploading => 'Envoi en cours…';

  @override
  String get preview => 'Aperçu';

  @override
  String get previewBanner =>
      'Vous voyez la surprise comme le receveur la verra · Tous les éléments sont débloqués';

  @override
  String get exitPreview => 'Quitter l\'aperçu';

  @override
  String get settings => 'Paramètres';

  @override
  String get creatorTokens => 'Token créateur';

  @override
  String get creatorTokensHint =>
      'Ce token est lié à votre compte et prouve que vous êtes le créateur de vos surprises. Conservez-le précieusement — il permet de lier un nouvel appareil à votre compte.';

  @override
  String get noCreatedSurprises => 'Aucune surprise créée sur cet appareil.';

  @override
  String get tokenCopied => 'Token copié !';

  @override
  String surpriseId(String id) {
    return 'ID : $id';
  }

  @override
  String get localData => 'Mes données';

  @override
  String get localDataHint =>
      'Ces données sont stockées uniquement sur cet appareil.';

  @override
  String get savedShareCodes => 'Codes de partage enregistrés';

  @override
  String get unlockedCodes => 'Codes de déverrouillage mémorisés';

  @override
  String get clearLocalDataButton => 'Supprimer toutes mes données';

  @override
  String get clearLocalDataTitle => 'Supprimer toutes mes données ?';

  @override
  String get clearLocalDataContent =>
      'Cette action supprimera définitivement :\n\n• Toutes les surprises que vous avez créées (sur tous les appareils)\n• Toutes les surprises rejointes sur cet appareil\n• Votre progression (codes déverrouillés, jeux résolus)\n\nCette action est irréversible.';

  @override
  String get clearLocalDataConfirm => 'Tout supprimer';

  @override
  String get clearLocalDataDone => 'Toutes vos données ont été supprimées.';

  @override
  String get clearLocalDataHint =>
      'Supprime définitivement vos surprises créées, retire les surprises rejointes et efface votre progression sur cet appareil.';

  @override
  String get elementTypeMotus => 'Motus';

  @override
  String get motusWordLabel => 'Mot à deviner *';

  @override
  String get motusWordHint => 'Ex : SURPRISE';

  @override
  String get motusFormHint =>
      'Le joueur devra trouver le mot en 6 tentatives. La première lettre est toujours révélée.';

  @override
  String get playMotus => 'Jouer au Motus';

  @override
  String get motusTitle => 'Motus';

  @override
  String motusAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentatives restantes',
      one: '1 tentative restante',
      zero: 'Plus de tentatives',
    );
    return '$_temp0';
  }

  @override
  String get motusValidate => 'OK';

  @override
  String get motusWon => 'Bravo ! Tu as trouvé le mot !';

  @override
  String motusLost(String word) {
    return 'Dommage… Le mot était $word';
  }

  @override
  String get motusRestart => 'Rejouer';

  @override
  String get motusRevealed => 'Mot trouvé !';

  @override
  String get elementTypeScratch => 'Gratte-moi';

  @override
  String get scratchMessageLabel => 'Message à révéler *';

  @override
  String get scratchMessageHint => 'Ex : Rendez-vous samedi à 20h !';

  @override
  String get scratchFormHint =>
      'Le joueur devra gratter la zone argentée pour découvrir votre message.';

  @override
  String get scratchHint => 'Gratte pour révéler !';

  @override
  String scratchProgress(int percent) {
    return '$percent% révélé';
  }

  @override
  String get scratchRevealed => 'Message révélé !';

  @override
  String get scratchRevealedImage => 'Image révélée !';

  @override
  String get scratchRestart => 'Recommencer';

  @override
  String get scratchPlay => 'Gratter !';

  @override
  String get scratchBackToSurprise => 'Voir la surprise';

  @override
  String get scratchContentTypeText => 'Texte';

  @override
  String get scratchContentTypeImage => 'Image';

  @override
  String get scratchImageFormHint => 'L\'image sera révélée après grattage.';

  @override
  String get elementTypeCodeGame => 'Code secret';

  @override
  String get codeGameSecretLabel => 'Code à 4 chiffres *';

  @override
  String get codeGameSecretHint => 'Ex : 4729';

  @override
  String get codeGameFormHint =>
      'Le joueur devra deviner ce code en 8 tentatives. Après chaque essai, il reçoit des indices sur les bons chiffres.';

  @override
  String get codeGameInvalidCode =>
      'Le code doit contenir exactement 4 chiffres';

  @override
  String get codeGamePlay => 'Deviner le code';

  @override
  String codeGameAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentatives restantes',
      one: '1 tentative restante',
      zero: 'Plus de tentatives',
    );
    return '$_temp0';
  }

  @override
  String get codeGameValidate => 'OK';

  @override
  String get codeGameWon => 'Bravo ! Tu as trouvé le code !';

  @override
  String codeGameLost(String code) {
    return 'Dommage… Le code était $code';
  }

  @override
  String get codeGameRestart => 'Rejouer';

  @override
  String get codeGameSolved => 'Code trouvé !';

  @override
  String get premiumTitle => 'Surprise Me Premium';

  @override
  String get premiumPerkUnlimited =>
      'Créez autant de surprises que vous voulez';

  @override
  String get premiumPerkGames => 'Accédez à tous les éléments de type Jeu';

  @override
  String get premiumPerkOneTime => 'Achat unique, sans abonnement';

  @override
  String get premiumBuy => 'Passer en Premium';

  @override
  String get premiumRestore => 'Restaurer mes achats';

  @override
  String get premiumRestoreNotFound => 'Aucun achat trouvé à restaurer.';

  @override
  String get premiumLimitReached =>
      'Vous avez atteint la limite gratuite (1 surprise). Passez en Premium pour en créer davantage.';

  @override
  String get premiumGamesLocked =>
      'Les jeux sont réservés aux utilisateurs Premium.';
}
