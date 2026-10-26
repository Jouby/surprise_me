// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Surprise Me';

  @override
  String get myCreations => 'Le mie creazioni';

  @override
  String get joinedSurprises => 'Partecipate';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get yourSurprises => 'Le tue sorprese';

  @override
  String get noSurpriseYet => 'Ancora nessuna sorpresa';

  @override
  String get noSurpriseHint =>
      'Crea una sorpresa o inserisci\nun codice per partecipare.';

  @override
  String get loadError => 'Impossibile caricare le sorprese';

  @override
  String get retry => 'Riprova';

  @override
  String get join => 'Partecipa';

  @override
  String get create => 'Crea';

  @override
  String get joinSurpriseTitle => 'Partecipa a una sorpresa';

  @override
  String get enterSharedCode =>
      'Inserisci il codice condiviso dall\'organizzatore.';

  @override
  String get codeNotFound => 'Codice non trovato. Controlla e riprova.';

  @override
  String get createSurprise => 'Crea una sorpresa';

  @override
  String get identity => 'Identità';

  @override
  String elementsCount(int count) {
    return 'Elementi ($count)';
  }

  @override
  String get elementsHint =>
      'Ogni elemento può essere svelato con un codice diverso.';

  @override
  String get titleLabel => 'Titolo *';

  @override
  String get requiredField => 'Obbligatorio';

  @override
  String get subtitleLabel => 'Sottotitolo (facoltativo)';

  @override
  String get themeColor => 'Colore del tema';

  @override
  String get addElement => 'Aggiungi un elemento';

  @override
  String get creating => 'Creazione in corso…';

  @override
  String get createButton => 'Crea la sorpresa';

  @override
  String get addAtLeastOneElement => 'Aggiungi almeno un elemento.';

  @override
  String get completeAllElements => 'Completa tutti gli elementi.';

  @override
  String errorPrefix(String error) {
    return 'Errore: $error';
  }

  @override
  String get genericError => 'Si è verificato un errore. Riprova.';

  @override
  String get linkCopied => 'Link copiato!';

  @override
  String get surpriseCreated => 'Sorpresa creata!';

  @override
  String get shareCodeHint =>
      'Condividi questo codice perché i tuoi cari\npossano scoprire la sorpresa.';

  @override
  String get copy => 'Copia';

  @override
  String get share => 'Condividi';

  @override
  String shareMessage(String link, String code) {
    return 'Ho una sorpresa per te! 🎁\nApri questo link per scoprirla: $link\n\nOppure inserisci il codice manualmente: $code';
  }

  @override
  String get backToHome => 'Torna alla home';

  @override
  String elementN(int n) {
    return 'Elemento $n';
  }

  @override
  String codeLabel(String code) {
    return 'Codice: $code';
  }

  @override
  String get editSurprise => 'Modifica la sorpresa';

  @override
  String get editElementsHint =>
      'Tocca un elemento per modificarlo, trascinalo per riordinarlo.';

  @override
  String get titleRequired => 'Il titolo è obbligatorio.';

  @override
  String get saving => 'Salvataggio in corso…';

  @override
  String get saveButton => 'Salva le modifiche';

  @override
  String get newBadge => 'Nuovo';

  @override
  String get deleteDialogTitle => 'Eliminare questa sorpresa?';

  @override
  String get deleteOwnerContent =>
      'Questa azione è irreversibile. La sorpresa e tutti i suoi elementi verranno eliminati definitivamente.';

  @override
  String get deleteGuestContent =>
      'La sorpresa verrà rimossa dalla tua lista. Puoi partecipare di nuovo con il suo codice.';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get remove => 'Rimuovi';

  @override
  String get ownerBanner => 'Sei il creatore · Tocca un codice per mostrarlo';

  @override
  String shareWithCode(String code) {
    return 'Condividi · $code';
  }

  @override
  String get revealedElements => 'Elementi svelati';

  @override
  String get enterCode => 'Inserisci un codice';

  @override
  String onboardingUnlockHint(String code) {
    return 'Tocca qui per inserire il tuo codice segreto e svelare un elemento! 🗝️\n\nPer iniziare, inserisci il codice: $code';
  }

  @override
  String shareSheetTitle(String title) {
    return 'Condividi \"$title\"';
  }

  @override
  String get shareAccessHint =>
      'Condividi questo codice perché i tuoi cari\npossano accedere a questa sorpresa.';

  @override
  String get linkCopiedClipboard => 'Link copiato negli appunti';

  @override
  String get editElement => 'Modifica elemento';

  @override
  String get newElement => 'Nuovo elemento';

  @override
  String get elementTitleLabel => 'Titolo dell\'elemento *';

  @override
  String get fieldRequired => 'Questo campo è obbligatorio';

  @override
  String get selectDate => 'Seleziona una data *';

  @override
  String get pleaseSelectDate => 'Seleziona una data';

  @override
  String get pleaseAddImage => 'Aggiungi un\'immagine';

  @override
  String get pleaseEnterLocation => 'Inserisci un luogo';

  @override
  String get pleaseEnterWord => 'Inserisci una parola';

  @override
  String get unlockCodeLabel => 'Codice di sblocco *';

  @override
  String get unlockCodeHint => 'es. SEGRETO1';

  @override
  String get unlockCodeInfo =>
      'È il codice che il destinatario deve inserire per svelare questo elemento. Puoi comunicarlo a voce, per messaggio o nasconderlo in un altro elemento.';

  @override
  String get generateCode => 'Genera un codice';

  @override
  String get solveCodeLabel => 'Codice premio (facoltativo)';

  @override
  String get solveCodeHint => 'es. LIVELLO2 — lascia vuoto se non serve';

  @override
  String get solveCodeInfo =>
      'Facoltativo. Questo codice viene inserito automaticamente quando il destinatario risolve questo gioco e sblocca un altro elemento della sorpresa senza doverlo digitare.';

  @override
  String get save => 'Salva';

  @override
  String get add => 'Aggiungi';

  @override
  String get elementGroupContent => 'Contenuto';

  @override
  String get elementGroupGames => 'Giochi';

  @override
  String get elementTypeText => 'Testo';

  @override
  String get elementTypeImage => 'Immagine';

  @override
  String get elementTypeDate => 'Data';

  @override
  String get elementTypeLocation => 'Luogo';

  @override
  String get elementTypeWordGame => 'Gioco di parole';

  @override
  String get elementTypePuzzle => 'Puzzle';

  @override
  String get messageContent => 'Contenuto del messaggio *';

  @override
  String get wordToGuessLabel => 'Parola da indovinare *';

  @override
  String get wordToGuessHint => 'es. SORPRESA';

  @override
  String get wordGameHint =>
      'Le lettere verranno mescolate. Il giocatore deve rimetterle nell\'ordine giusto.';

  @override
  String get enterYourCode => 'Inserisci il tuo codice';

  @override
  String get codeUnlocksElement =>
      'Ogni codice sblocca un elemento della sorpresa.';

  @override
  String get codeAccepted => 'Codice accettato! Un elemento è stato svelato.';

  @override
  String get invalidCode => 'Codice non valido. Controlla e riprova.';

  @override
  String get unlock => 'Sblocca';

  @override
  String get unlocked => 'Sbloccato';

  @override
  String get enterCodeToReveal => 'Inserisci un codice per svelare';

  @override
  String get congratulations => 'Bravo! Hai trovato la parola!';

  @override
  String get shuffleAgain => 'Mescola di nuovo';

  @override
  String get uploadError => 'Errore di caricamento. Riprova.';

  @override
  String get addImage => 'Aggiungi un\'immagine';

  @override
  String get gallery => 'Galleria';

  @override
  String get camera => 'Fotocamera';

  @override
  String get change => 'Cambia';

  @override
  String get galleryOrCamera => 'Galleria o fotocamera';

  @override
  String get uploading => 'Caricamento in corso…';

  @override
  String get preview => 'Anteprima';

  @override
  String get previewBanner =>
      'Vedi la sorpresa come la vedrà il destinatario · Tutti gli elementi sono sbloccati';

  @override
  String get exitPreview => 'Esci dall\'anteprima';

  @override
  String get settings => 'Impostazioni';

  @override
  String get creatorTokens => 'Token del creatore';

  @override
  String get creatorTokensHint =>
      'Questo token è legato al tuo account e dimostra che sei il creatore delle tue sorprese. Conservalo con cura: ti permette di collegare un nuovo dispositivo al tuo account.';

  @override
  String get noCreatedSurprises =>
      'Nessuna sorpresa creata su questo dispositivo.';

  @override
  String get tokenCopied => 'Token copiato!';

  @override
  String surpriseId(String id) {
    return 'ID: $id';
  }

  @override
  String get localData => 'I miei dati';

  @override
  String get localDataHint =>
      'Questi dati sono salvati solo su questo dispositivo.';

  @override
  String get savedShareCodes => 'Codici di condivisione salvati';

  @override
  String get unlockedCodes => 'Codici di sblocco memorizzati';

  @override
  String get clearLocalDataButton => 'Elimina tutti i miei dati';

  @override
  String get clearLocalDataTitle => 'Eliminare tutti i miei dati?';

  @override
  String get clearLocalDataContent =>
      'Verranno eliminati definitivamente:\n\n• Tutte le sorprese che hai creato (su tutti i dispositivi)\n• Tutte le sorprese a cui partecipi su questo dispositivo\n• I tuoi progressi (codici sbloccati, giochi risolti)\n\nQuesta azione non può essere annullata.';

  @override
  String get clearLocalDataConfirm => 'Elimina tutto';

  @override
  String get clearLocalDataDone => 'Tutti i tuoi dati sono stati eliminati.';

  @override
  String get clearLocalDataHint =>
      'Elimina definitivamente le sorprese che hai creato, rimuove quelle a cui partecipi e cancella i tuoi progressi su questo dispositivo.';

  @override
  String get elementTypeMotus => 'Motus';

  @override
  String get motusWordLabel => 'Parola da indovinare *';

  @override
  String get motusWordHint => 'Es. SORPRESA';

  @override
  String get motusFormHint =>
      'Il giocatore avrà 6 tentativi per indovinare la parola. La prima lettera è sempre mostrata.';

  @override
  String get playMotus => 'Gioca a Motus';

  @override
  String get motusTitle => 'Motus';

  @override
  String motusAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativi rimasti',
      one: '1 tentativo rimasto',
      zero: 'Nessun tentativo rimasto',
    );
    return '$_temp0';
  }

  @override
  String get motusValidate => 'OK';

  @override
  String get motusWon => 'Bravo! Hai trovato la parola!';

  @override
  String motusLost(String word) {
    return 'Peccato… La parola era $word';
  }

  @override
  String get motusRestart => 'Gioca ancora';

  @override
  String get motusRevealed => 'Parola trovata!';

  @override
  String get elementTypeScratch => 'Gratta e scopri';

  @override
  String get scratchMessageLabel => 'Messaggio da svelare *';

  @override
  String get scratchMessageHint => 'Es. Ci vediamo sabato alle 20!';

  @override
  String get scratchFormHint =>
      'Il giocatore gratterà la zona argentata per scoprire il tuo messaggio.';

  @override
  String get scratchHint => 'Gratta per scoprire!';

  @override
  String scratchProgress(int percent) {
    return '$percent% svelato';
  }

  @override
  String get scratchRevealed => 'Messaggio svelato!';

  @override
  String get scratchRevealedImage => 'Immagine svelata!';

  @override
  String get scratchRestart => 'Ricomincia';

  @override
  String get scratchPlay => 'Gratta!';

  @override
  String get scratchBackToSurprise => 'Vedi la sorpresa';

  @override
  String get scratchContentTypeText => 'Testo';

  @override
  String get scratchContentTypeImage => 'Immagine';

  @override
  String get scratchImageFormHint =>
      'L\'immagine verrà svelata dopo averla grattata.';

  @override
  String get elementTypeCodeGame => 'Codice segreto';

  @override
  String get codeGameSecretLabel => 'Codice a 4 cifre *';

  @override
  String get codeGameSecretHint => 'Es. 4729';

  @override
  String get codeGameFormHint =>
      'Il giocatore avrà 8 tentativi per indovinare il codice. Dopo ogni tentativo riceve indizi sulle cifre corrette.';

  @override
  String get codeGameInvalidCode => 'Il codice deve avere esattamente 4 cifre';

  @override
  String get codeGamePlay => 'Indovina il codice';

  @override
  String codeGameAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativi rimasti',
      one: '1 tentativo rimasto',
      zero: 'Nessun tentativo rimasto',
    );
    return '$_temp0';
  }

  @override
  String get codeGameValidate => 'OK';

  @override
  String get codeGameWon => 'Bravo! Hai decifrato il codice!';

  @override
  String codeGameLost(String code) {
    return 'Peccato… Il codice era $code';
  }

  @override
  String get codeGameRestart => 'Gioca ancora';

  @override
  String get codeGameSolved => 'Codice decifrato!';

  @override
  String get premiumTitle => 'Surprise Me Premium';

  @override
  String get premiumPerkUnlimited => 'Crea tutte le sorprese che vuoi';

  @override
  String get premiumPerkGames => 'Accedi a tutti gli elementi di tipo Gioco';

  @override
  String get premiumPerkOneTime => 'Acquisto unico, nessun abbonamento';

  @override
  String get premiumBuy => 'Passa a Premium';

  @override
  String get premiumRestore => 'Ripristina acquisti';

  @override
  String get premiumRestoreNotFound => 'Nessun acquisto da ripristinare.';

  @override
  String get premiumLimitReached =>
      'Hai raggiunto il limite gratuito (1 sorpresa). Passa a Premium per crearne altre.';

  @override
  String get premiumGamesLocked =>
      'I giochi sono disponibili solo per gli utenti Premium.';
}
