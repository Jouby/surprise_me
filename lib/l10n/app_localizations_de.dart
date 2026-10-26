// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Surprise Me';

  @override
  String get myCreations => 'Meine Kreationen';

  @override
  String get joinedSurprises => 'Beigetreten';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get yourSurprises => 'Deine Überraschungen';

  @override
  String get noSurpriseYet => 'Noch keine Überraschungen';

  @override
  String get noSurpriseHint =>
      'Erstelle eine Überraschung oder gib\neinen Code ein, um einer beizutreten.';

  @override
  String get loadError => 'Überraschungen konnten nicht geladen werden';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get join => 'Beitreten';

  @override
  String get create => 'Erstellen';

  @override
  String get joinSurpriseTitle => 'Einer Überraschung beitreten';

  @override
  String get enterSharedCode =>
      'Gib den Code ein, den dir der Organisator geschickt hat.';

  @override
  String get codeNotFound =>
      'Code nicht gefunden. Überprüfe ihn und versuche es erneut.';

  @override
  String get createSurprise => 'Überraschung erstellen';

  @override
  String get identity => 'Identität';

  @override
  String elementsCount(int count) {
    return 'Elemente ($count)';
  }

  @override
  String get elementsHint =>
      'Jedes Element kann mit einem eigenen Code enthüllt werden.';

  @override
  String get titleLabel => 'Titel *';

  @override
  String get requiredField => 'Pflichtfeld';

  @override
  String get subtitleLabel => 'Untertitel (optional)';

  @override
  String get themeColor => 'Themenfarbe';

  @override
  String get addElement => 'Element hinzufügen';

  @override
  String get creating => 'Wird erstellt…';

  @override
  String get createButton => 'Überraschung erstellen';

  @override
  String get addAtLeastOneElement => 'Füge mindestens ein Element hinzu.';

  @override
  String get completeAllElements => 'Vervollständige alle Elemente.';

  @override
  String errorPrefix(String error) {
    return 'Fehler: $error';
  }

  @override
  String get genericError =>
      'Ein Fehler ist aufgetreten. Bitte versuche es erneut.';

  @override
  String get linkCopied => 'Link kopiert!';

  @override
  String get surpriseCreated => 'Überraschung erstellt!';

  @override
  String get shareCodeHint =>
      'Teile diesen Code, damit deine Liebsten\ndie Überraschung entdecken können.';

  @override
  String get copy => 'Kopieren';

  @override
  String get share => 'Teilen';

  @override
  String shareMessage(String link, String code) {
    return 'Ich habe eine Überraschung für dich! 🎁\nÖffne diesen Link, um sie zu entdecken: $link\n\nOder gib den Code manuell ein: $code';
  }

  @override
  String get backToHome => 'Zurück zur Startseite';

  @override
  String elementN(int n) {
    return 'Element $n';
  }

  @override
  String codeLabel(String code) {
    return 'Code: $code';
  }

  @override
  String get editSurprise => 'Überraschung bearbeiten';

  @override
  String get editElementsHint =>
      'Tippe auf ein Element, um es zu bearbeiten, ziehe es, um die Reihenfolge zu ändern.';

  @override
  String get titleRequired => 'Der Titel ist erforderlich.';

  @override
  String get saving => 'Wird gespeichert…';

  @override
  String get saveButton => 'Änderungen speichern';

  @override
  String get newBadge => 'Neu';

  @override
  String get deleteDialogTitle => 'Diese Überraschung löschen?';

  @override
  String get deleteOwnerContent =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Die Überraschung und alle ihre Elemente werden endgültig gelöscht.';

  @override
  String get deleteGuestContent =>
      'Die Überraschung wird aus deiner Liste entfernt. Du kannst ihr mit ihrem Code erneut beitreten.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get remove => 'Entfernen';

  @override
  String get ownerBanner =>
      'Du bist der Ersteller · Tippe auf einen Code, um ihn anzuzeigen';

  @override
  String shareWithCode(String code) {
    return 'Teilen · $code';
  }

  @override
  String get revealedElements => 'Enthüllte Elemente';

  @override
  String get enterCode => 'Code eingeben';

  @override
  String onboardingUnlockHint(String code) {
    return 'Tippe hier, um deinen geheimen Code einzugeben und ein Element zu enthüllen! 🗝️\n\nGib zum Start diesen Code ein: $code';
  }

  @override
  String shareSheetTitle(String title) {
    return '„$title“ teilen';
  }

  @override
  String get shareAccessHint =>
      'Teile diesen Code, damit deine Liebsten\nZugriff auf diese Überraschung haben.';

  @override
  String get linkCopiedClipboard => 'Link in die Zwischenablage kopiert';

  @override
  String get editElement => 'Element bearbeiten';

  @override
  String get newElement => 'Neues Element';

  @override
  String get elementTitleLabel => 'Titel des Elements *';

  @override
  String get fieldRequired => 'Dieses Feld ist erforderlich';

  @override
  String get selectDate => 'Datum auswählen *';

  @override
  String get pleaseSelectDate => 'Bitte wähle ein Datum aus';

  @override
  String get pleaseAddImage => 'Bitte füge ein Bild hinzu';

  @override
  String get pleaseEnterLocation => 'Bitte gib einen Ort ein';

  @override
  String get pleaseEnterWord => 'Bitte gib ein Wort ein';

  @override
  String get unlockCodeLabel => 'Freischaltcode *';

  @override
  String get unlockCodeHint => 'z. B. GEHEIM1';

  @override
  String get unlockCodeInfo =>
      'Diesen Code muss der Empfänger eingeben, um dieses Element zu enthüllen. Du kannst ihn mündlich oder per Nachricht weitergeben oder in einem anderen Element verstecken.';

  @override
  String get generateCode => 'Code generieren';

  @override
  String get solveCodeLabel => 'Belohnungscode (optional)';

  @override
  String get solveCodeHint => 'z. B. STUFE2 – leer lassen, falls keiner';

  @override
  String get solveCodeInfo =>
      'Optional. Dieser Code wird automatisch eingegeben, wenn der Empfänger dieses Spiel löst, und schaltet ein weiteres Element der Überraschung frei, ohne dass er ihn eintippen muss.';

  @override
  String get save => 'Speichern';

  @override
  String get add => 'Hinzufügen';

  @override
  String get elementGroupContent => 'Inhalt';

  @override
  String get elementGroupGames => 'Spiele';

  @override
  String get elementTypeText => 'Text';

  @override
  String get elementTypeImage => 'Bild';

  @override
  String get elementTypeDate => 'Datum';

  @override
  String get elementTypeLocation => 'Ort';

  @override
  String get elementTypeWordGame => 'Wortspiel';

  @override
  String get elementTypePuzzle => 'Puzzle';

  @override
  String get messageContent => 'Nachrichteninhalt *';

  @override
  String get wordToGuessLabel => 'Zu erratendes Wort *';

  @override
  String get wordToGuessHint => 'z. B. GESCHENK';

  @override
  String get wordGameHint =>
      'Die Buchstaben werden gemischt. Der Spieler muss sie wieder in die richtige Reihenfolge bringen.';

  @override
  String get enterYourCode => 'Gib deinen Code ein';

  @override
  String get codeUnlocksElement =>
      'Jeder Code schaltet ein Element der Überraschung frei.';

  @override
  String get codeAccepted => 'Code akzeptiert! Ein Element wurde enthüllt.';

  @override
  String get invalidCode =>
      'Ungültiger Code. Überprüfe ihn und versuche es erneut.';

  @override
  String get unlock => 'Freischalten';

  @override
  String get unlocked => 'Freigeschaltet';

  @override
  String get enterCodeToReveal => 'Code eingeben zum Enthüllen';

  @override
  String get congratulations => 'Gut gemacht! Du hast das Wort gefunden!';

  @override
  String get shuffleAgain => 'Neu mischen';

  @override
  String get uploadError => 'Fehler beim Hochladen. Bitte versuche es erneut.';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Kamera';

  @override
  String get change => 'Ändern';

  @override
  String get galleryOrCamera => 'Galerie oder Kamera';

  @override
  String get uploading => 'Wird hochgeladen…';

  @override
  String get preview => 'Vorschau';

  @override
  String get previewBanner =>
      'Du siehst die Überraschung so, wie der Empfänger sie sehen wird · Alle Elemente sind freigeschaltet';

  @override
  String get exitPreview => 'Vorschau beenden';

  @override
  String get settings => 'Einstellungen';

  @override
  String get creatorTokens => 'Ersteller-Token';

  @override
  String get creatorTokensHint =>
      'Dieses Token ist mit deinem Konto verknüpft und beweist, dass du deine Überraschungen erstellt hast. Bewahre es sicher auf – damit kannst du ein neues Gerät mit deinem Konto verbinden.';

  @override
  String get noCreatedSurprises =>
      'Auf diesem Gerät wurden keine Überraschungen erstellt.';

  @override
  String get tokenCopied => 'Token kopiert!';

  @override
  String surpriseId(String id) {
    return 'ID: $id';
  }

  @override
  String get localData => 'Meine Daten';

  @override
  String get localDataHint =>
      'Diese Daten werden nur auf diesem Gerät gespeichert.';

  @override
  String get savedShareCodes => 'Gespeicherte Teilen-Codes';

  @override
  String get unlockedCodes => 'Gemerkte Freischaltcodes';

  @override
  String get clearLocalDataButton => 'Alle meine Daten löschen';

  @override
  String get clearLocalDataTitle => 'Alle meine Daten löschen?';

  @override
  String get clearLocalDataContent =>
      'Folgendes wird endgültig gelöscht:\n\n• Alle von dir erstellten Überraschungen (auf allen Geräten)\n• Alle Überraschungen, denen du auf diesem Gerät beigetreten bist\n• Dein Fortschritt (freigeschaltete Codes, gelöste Spiele)\n\nDiese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get clearLocalDataConfirm => 'Alles löschen';

  @override
  String get clearLocalDataDone => 'Alle deine Daten wurden gelöscht.';

  @override
  String get clearLocalDataHint =>
      'Löscht deine erstellten Überraschungen endgültig, entfernt beigetretene Überraschungen und setzt deinen Fortschritt auf diesem Gerät zurück.';

  @override
  String get elementTypeMotus => 'Motus';

  @override
  String get motusWordLabel => 'Zu erratendes Wort *';

  @override
  String get motusWordHint => 'Z. B. GESCHENK';

  @override
  String get motusFormHint =>
      'Der Spieler hat 6 Versuche, um das Wort zu erraten. Der erste Buchstabe wird immer angezeigt.';

  @override
  String get playMotus => 'Motus spielen';

  @override
  String get motusTitle => 'Motus';

  @override
  String motusAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Versuche',
      one: 'Noch 1 Versuch',
      zero: 'Keine Versuche mehr',
    );
    return '$_temp0';
  }

  @override
  String get motusValidate => 'OK';

  @override
  String get motusWon => 'Gut gemacht! Du hast das Wort gefunden!';

  @override
  String motusLost(String word) {
    return 'Schade… Das Wort war $word';
  }

  @override
  String get motusRestart => 'Nochmal spielen';

  @override
  String get motusRevealed => 'Wort gefunden!';

  @override
  String get elementTypeScratch => 'Rubbelkarte';

  @override
  String get scratchMessageLabel => 'Zu enthüllende Nachricht *';

  @override
  String get scratchMessageHint => 'Z. B. Wir sehen uns am Samstag um 20 Uhr!';

  @override
  String get scratchFormHint =>
      'Der Spieler rubbelt die silberne Fläche frei, um deine Nachricht aufzudecken.';

  @override
  String get scratchHint => 'Rubbeln zum Enthüllen!';

  @override
  String scratchProgress(int percent) {
    return '$percent % enthüllt';
  }

  @override
  String get scratchRevealed => 'Nachricht enthüllt!';

  @override
  String get scratchRevealedImage => 'Bild enthüllt!';

  @override
  String get scratchRestart => 'Von vorne beginnen';

  @override
  String get scratchPlay => 'Rubbeln!';

  @override
  String get scratchBackToSurprise => 'Zur Überraschung';

  @override
  String get scratchContentTypeText => 'Text';

  @override
  String get scratchContentTypeImage => 'Bild';

  @override
  String get scratchImageFormHint => 'Das Bild wird nach dem Rubbeln enthüllt.';

  @override
  String get elementTypeCodeGame => 'Geheimcode';

  @override
  String get codeGameSecretLabel => '4-stelliger Code *';

  @override
  String get codeGameSecretHint => 'Z. B. 4729';

  @override
  String get codeGameFormHint =>
      'Der Spieler hat 8 Versuche, um den Code zu erraten. Nach jedem Versuch gibt es Hinweise zu den richtigen Ziffern.';

  @override
  String get codeGameInvalidCode => 'Der Code muss genau 4 Ziffern haben';

  @override
  String get codeGamePlay => 'Code erraten';

  @override
  String codeGameAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Versuche',
      one: 'Noch 1 Versuch',
      zero: 'Keine Versuche mehr',
    );
    return '$_temp0';
  }

  @override
  String get codeGameValidate => 'OK';

  @override
  String get codeGameWon => 'Gut gemacht! Du hast den Code geknackt!';

  @override
  String codeGameLost(String code) {
    return 'Schade… Der Code war $code';
  }

  @override
  String get codeGameRestart => 'Nochmal spielen';

  @override
  String get codeGameSolved => 'Code geknackt!';

  @override
  String get premiumTitle => 'Surprise Me Premium';

  @override
  String get premiumPerkUnlimited =>
      'Erstelle so viele Überraschungen, wie du willst';

  @override
  String get premiumPerkGames => 'Zugriff auf alle Spiel-Elemente';

  @override
  String get premiumPerkOneTime => 'Einmalkauf, kein Abo';

  @override
  String get premiumBuy => 'Premium holen';

  @override
  String get premiumRestore => 'Käufe wiederherstellen';

  @override
  String get premiumRestoreNotFound =>
      'Kein Kauf zum Wiederherstellen gefunden.';

  @override
  String get premiumLimitReached =>
      'Du hast das kostenlose Limit erreicht (1 Überraschung). Hol dir Premium, um mehr zu erstellen.';

  @override
  String get premiumGamesLocked =>
      'Spiele sind nur für Premium-Nutzer verfügbar.';
}
