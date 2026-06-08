// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Surprise Me';

  @override
  String get myCreations => 'My creations';

  @override
  String get joinedSurprises => 'Joined';

  @override
  String get refresh => 'Refresh';

  @override
  String get yourSurprises => 'Your Surprises';

  @override
  String get noSurpriseYet => 'No surprises yet';

  @override
  String get noSurpriseHint =>
      'Create a surprise or enter\na code to join one.';

  @override
  String get loadError => 'Unable to load surprises';

  @override
  String get retry => 'Retry';

  @override
  String get join => 'Join';

  @override
  String get create => 'Create';

  @override
  String get joinSurpriseTitle => 'Join a surprise';

  @override
  String get enterSharedCode => 'Enter the code shared by the organiser.';

  @override
  String get codeNotFound => 'Code not found. Check and try again.';

  @override
  String get createSurprise => 'Create a surprise';

  @override
  String get identity => 'Identity';

  @override
  String elementsCount(int count) {
    return 'Elements ($count)';
  }

  @override
  String get elementsHint =>
      'Each element can be revealed with a separate code.';

  @override
  String get titleLabel => 'Title *';

  @override
  String get requiredField => 'Required';

  @override
  String get subtitleLabel => 'Subtitle (optional)';

  @override
  String get themeColor => 'Theme colour';

  @override
  String get addElement => 'Add an element';

  @override
  String get creating => 'Creating…';

  @override
  String get createButton => 'Create surprise';

  @override
  String get addAtLeastOneElement => 'Add at least one element.';

  @override
  String get completeAllElements => 'Complete all elements.';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get linkCopied => 'Link copied!';

  @override
  String get surpriseCreated => 'Surprise created!';

  @override
  String get shareCodeHint =>
      'Share this code so your loved ones\ncan discover the surprise.';

  @override
  String get copy => 'Copy';

  @override
  String get share => 'Share';

  @override
  String shareMessage(String link, String code) {
    return 'I have a surprise for you! 🎁\nOpen this link to discover it: $link\n\nOr enter the code manually: $code';
  }

  @override
  String get backToHome => 'Back to home';

  @override
  String elementN(int n) {
    return 'Element $n';
  }

  @override
  String codeLabel(String code) {
    return 'Code: $code';
  }

  @override
  String get editSurprise => 'Edit surprise';

  @override
  String get editElementsHint => 'Tap an element to edit it, drag to reorder.';

  @override
  String get titleRequired => 'Title is required.';

  @override
  String get saving => 'Saving…';

  @override
  String get saveButton => 'Save changes';

  @override
  String get newBadge => 'New';

  @override
  String get deleteDialogTitle => 'Delete this surprise?';

  @override
  String get deleteOwnerContent =>
      'This action is irreversible. The surprise and all its elements will be permanently deleted.';

  @override
  String get deleteGuestContent =>
      'The surprise will be removed from your list. You can join it again with its code.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get ownerBanner => 'You are the creator · Tap a code to reveal it';

  @override
  String shareWithCode(String code) {
    return 'Share · $code';
  }

  @override
  String get revealedElements => 'Revealed elements';

  @override
  String get enterCode => 'Enter a code';

  @override
  String shareSheetTitle(String title) {
    return 'Share \"$title\"';
  }

  @override
  String get shareAccessHint =>
      'Share this code so your loved ones\ncan access this surprise.';

  @override
  String get linkCopiedClipboard => 'Link copied to clipboard';

  @override
  String get editElement => 'Edit element';

  @override
  String get newElement => 'New element';

  @override
  String get elementTitleLabel => 'Element title *';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get selectDate => 'Select a date *';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseAddImage => 'Please add an image';

  @override
  String get pleaseEnterLocation => 'Please enter a location';

  @override
  String get pleaseEnterWord => 'Please enter a word';

  @override
  String get unlockCodeLabel => 'Unlock code *';

  @override
  String get unlockCodeHint => 'e.g. SECRET1';

  @override
  String get generateCode => 'Generate a code';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get elementTypeText => 'Text';

  @override
  String get elementTypeImage => 'Image';

  @override
  String get elementTypeDate => 'Date';

  @override
  String get elementTypeLocation => 'Location';

  @override
  String get elementTypeWordGame => 'Word game';

  @override
  String get elementTypePuzzle => 'Puzzle';

  @override
  String get messageContent => 'Message content *';

  @override
  String get wordToGuessLabel => 'Word to guess *';

  @override
  String get wordToGuessHint => 'e.g. SURPRISE';

  @override
  String get wordGameHint =>
      'The letters will be shuffled. The player must put them back in the right order.';

  @override
  String get enterYourCode => 'Enter your code';

  @override
  String get codeUnlocksElement =>
      'Each code unlocks one element of the surprise.';

  @override
  String get codeAccepted => 'Code accepted! An element has been revealed.';

  @override
  String get invalidCode => 'Invalid code. Check and try again.';

  @override
  String get unlock => 'Unlock';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get enterCodeToReveal => 'Enter a code to reveal';

  @override
  String get congratulations => 'Well done! You found the word!';

  @override
  String get shuffleAgain => 'Shuffle again';

  @override
  String get uploadError => 'Upload error. Please try again.';

  @override
  String get addImage => 'Add an image';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get change => 'Change';

  @override
  String get galleryOrCamera => 'Gallery or camera';

  @override
  String get uploading => 'Uploading…';

  @override
  String get preview => 'Preview';

  @override
  String get previewBanner =>
      'You are seeing the surprise as the recipient will · All elements are unlocked';

  @override
  String get exitPreview => 'Exit preview';

  @override
  String get settings => 'Settings';

  @override
  String get creatorTokens => 'Creator tokens';

  @override
  String get creatorTokensHint =>
      'These tokens prove you are the creator of a surprise. Keep them safe — they allow you to link a new device to your surprises.';

  @override
  String get noCreatedSurprises => 'No surprises created on this device.';

  @override
  String get tokenCopied => 'Token copied!';

  @override
  String surpriseId(String id) {
    return 'ID: $id';
  }

  @override
  String get localData => 'Local data';

  @override
  String get localDataHint => 'This data is stored only on this device.';

  @override
  String get savedShareCodes => 'Saved share codes';

  @override
  String get unlockedCodes => 'Memorised unlock codes';

  @override
  String get elementTypeMotus => 'Motus';

  @override
  String get motusWordLabel => 'Word to guess *';

  @override
  String get motusWordHint => 'E.g. SURPRISE';

  @override
  String get motusFormHint =>
      'The player will have 6 attempts to guess the word. The first letter is always revealed.';

  @override
  String get playMotus => 'Play Motus';

  @override
  String get motusTitle => 'Motus';

  @override
  String motusAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attempts left',
      one: '1 attempt left',
      zero: 'No attempts left',
    );
    return '$_temp0';
  }

  @override
  String get motusValidate => 'OK';

  @override
  String get motusWon => 'Well done! You found the word!';

  @override
  String motusLost(String word) {
    return 'Too bad… The word was $word';
  }

  @override
  String get motusRestart => 'Play again';

  @override
  String get motusRevealed => 'Word found!';

  @override
  String get elementTypeScratch => 'Scratch card';

  @override
  String get scratchMessageLabel => 'Message to reveal *';

  @override
  String get scratchMessageHint => 'E.g. See you Saturday at 8pm!';

  @override
  String get scratchFormHint =>
      'The player will scratch the silver area to uncover your message.';

  @override
  String get scratchHint => 'Scratch to reveal!';

  @override
  String scratchProgress(int percent) {
    return '$percent% revealed';
  }

  @override
  String get scratchRevealed => 'Message revealed!';

  @override
  String get scratchRevealedImage => 'Image revealed!';

  @override
  String get scratchRestart => 'Start over';

  @override
  String get scratchPlay => 'Scratch!';

  @override
  String get scratchBackToSurprise => 'See the surprise';

  @override
  String get scratchContentTypeText => 'Text';

  @override
  String get scratchContentTypeImage => 'Image';

  @override
  String get scratchImageFormHint =>
      'The image will be revealed after scratching.';

  @override
  String get elementTypeCodeGame => 'Secret code';

  @override
  String get codeGameSecretLabel => '4-digit code *';

  @override
  String get codeGameSecretHint => 'E.g. 4729';

  @override
  String get codeGameFormHint =>
      'The player will have 8 attempts to guess the code. After each try, hints are given about correct digits.';

  @override
  String get codeGameInvalidCode => 'The code must be exactly 4 digits';

  @override
  String get codeGamePlay => 'Guess the code';

  @override
  String codeGameAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attempts left',
      one: '1 attempt left',
      zero: 'No attempts left',
    );
    return '$_temp0';
  }

  @override
  String get codeGameValidate => 'OK';

  @override
  String get codeGameWon => 'Well done! You cracked the code!';

  @override
  String codeGameLost(String code) {
    return 'Too bad… The code was $code';
  }

  @override
  String get codeGameRestart => 'Play again';

  @override
  String get codeGameSolved => 'Code cracked!';
}
