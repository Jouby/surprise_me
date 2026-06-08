// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Surprise Me';

  @override
  String get myCreations => 'Mis creaciones';

  @override
  String get joinedSurprises => 'Unidas';

  @override
  String get refresh => 'Actualizar';

  @override
  String get yourSurprises => 'Tus Sorpresas';

  @override
  String get noSurpriseYet => 'Ninguna sorpresa por ahora';

  @override
  String get noSurpriseHint =>
      'Crea una sorpresa o introduce\nun código para unirte a una.';

  @override
  String get loadError => 'No se pueden cargar las sorpresas';

  @override
  String get retry => 'Reintentar';

  @override
  String get join => 'Unirse';

  @override
  String get create => 'Crear';

  @override
  String get joinSurpriseTitle => 'Unirse a una sorpresa';

  @override
  String get enterSharedCode =>
      'Introduce el código compartido por el organizador.';

  @override
  String get codeNotFound =>
      'Código no encontrado. Verifica e inténtalo de nuevo.';

  @override
  String get createSurprise => 'Crear una sorpresa';

  @override
  String get identity => 'Identidad';

  @override
  String elementsCount(int count) {
    return 'Elementos ($count)';
  }

  @override
  String get elementsHint =>
      'Cada elemento puede revelarse con un código distinto.';

  @override
  String get titleLabel => 'Título *';

  @override
  String get requiredField => 'Obligatorio';

  @override
  String get subtitleLabel => 'Subtítulo (opcional)';

  @override
  String get themeColor => 'Color del tema';

  @override
  String get addElement => 'Añadir un elemento';

  @override
  String get creating => 'Creando…';

  @override
  String get createButton => 'Crear sorpresa';

  @override
  String get addAtLeastOneElement => 'Añade al menos un elemento.';

  @override
  String get completeAllElements => 'Completa todos los elementos.';

  @override
  String errorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get linkCopied => '¡Enlace copiado!';

  @override
  String get surpriseCreated => '¡Sorpresa creada!';

  @override
  String get shareCodeHint =>
      'Comparte este código para que tus seres queridos\npuedan descubrir la sorpresa.';

  @override
  String get copy => 'Copiar';

  @override
  String get share => 'Compartir';

  @override
  String shareMessage(String link, String code) {
    return '¡Tengo una sorpresa para ti! 🎁\nAbre este enlace para descubrirla: $link\n\nO introduce el código manualmente: $code';
  }

  @override
  String get backToHome => 'Volver al inicio';

  @override
  String elementN(int n) {
    return 'Elemento $n';
  }

  @override
  String codeLabel(String code) {
    return 'Código: $code';
  }

  @override
  String get editSurprise => 'Editar sorpresa';

  @override
  String get editElementsHint =>
      'Toca un elemento para editarlo, arrastra para reordenar.';

  @override
  String get titleRequired => 'El título es obligatorio.';

  @override
  String get saving => 'Guardando…';

  @override
  String get saveButton => 'Guardar cambios';

  @override
  String get newBadge => 'Nuevo';

  @override
  String get deleteDialogTitle => '¿Eliminar esta sorpresa?';

  @override
  String get deleteOwnerContent =>
      'Esta acción es irreversible. La sorpresa y todos sus elementos serán eliminados permanentemente.';

  @override
  String get deleteGuestContent =>
      'La sorpresa se eliminará de tu lista. Puedes volver a unirte con su código.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get remove => 'Quitar';

  @override
  String get ownerBanner => 'Eres el creador · Toca un código para revelarlo';

  @override
  String shareWithCode(String code) {
    return 'Compartir · $code';
  }

  @override
  String get revealedElements => 'Elementos revelados';

  @override
  String get enterCode => 'Introducir un código';

  @override
  String shareSheetTitle(String title) {
    return 'Compartir \"$title\"';
  }

  @override
  String get shareAccessHint =>
      'Comparte este código para que tus seres queridos\npuedan acceder a esta sorpresa.';

  @override
  String get linkCopiedClipboard => 'Enlace copiado al portapapeles';

  @override
  String get editElement => 'Editar elemento';

  @override
  String get newElement => 'Nuevo elemento';

  @override
  String get elementTitleLabel => 'Título del elemento *';

  @override
  String get fieldRequired => 'Este campo es obligatorio';

  @override
  String get selectDate => 'Seleccionar una fecha *';

  @override
  String get pleaseSelectDate => 'Por favor, selecciona una fecha';

  @override
  String get pleaseAddImage => 'Por favor, añade una imagen';

  @override
  String get pleaseEnterLocation => 'Por favor, indica un lugar';

  @override
  String get pleaseEnterWord => 'Por favor, introduce una palabra';

  @override
  String get unlockCodeLabel => 'Código de desbloqueo *';

  @override
  String get unlockCodeHint => 'Ej: SECRETO1';

  @override
  String get generateCode => 'Generar un código';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Añadir';

  @override
  String get elementTypeText => 'Texto';

  @override
  String get elementTypeImage => 'Imagen';

  @override
  String get elementTypeDate => 'Fecha';

  @override
  String get elementTypeLocation => 'Lugar';

  @override
  String get elementTypeWordGame => 'Anagrama';

  @override
  String get elementTypePuzzle => 'Puzle';

  @override
  String get messageContent => 'Contenido del mensaje *';

  @override
  String get wordToGuessLabel => 'Palabra a adivinar *';

  @override
  String get wordToGuessHint => 'Ej: SORPRESA';

  @override
  String get wordGameHint =>
      'Las letras se mezclarán. El jugador deberá ordenarlas correctamente.';

  @override
  String get enterYourCode => 'Introduce tu código';

  @override
  String get codeUnlocksElement =>
      'Cada código desbloquea un elemento de la sorpresa.';

  @override
  String get codeAccepted => '¡Código aceptado! Se ha revelado un elemento.';

  @override
  String get invalidCode => 'Código no válido. Verifica e inténtalo de nuevo.';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get enterCodeToReveal => 'Introduce un código para revelar';

  @override
  String get congratulations => '¡Enhorabuena! ¡Encontraste la palabra!';

  @override
  String get shuffleAgain => 'Mezclar de nuevo';

  @override
  String get uploadError => 'Error al subir. Inténtalo de nuevo.';

  @override
  String get addImage => 'Añadir una imagen';

  @override
  String get gallery => 'Galería';

  @override
  String get camera => 'Cámara';

  @override
  String get change => 'Cambiar';

  @override
  String get galleryOrCamera => 'Galería o cámara';

  @override
  String get uploading => 'Subiendo…';

  @override
  String get preview => 'Vista previa';

  @override
  String get previewBanner =>
      'Estás viendo la sorpresa como la verá el destinatario · Todos los elementos están desbloqueados';

  @override
  String get exitPreview => 'Salir de la vista previa';

  @override
  String get settings => 'Ajustes';

  @override
  String get creatorTokens => 'Creator tokens';

  @override
  String get creatorTokensHint =>
      'Estos tokens demuestran que eres el creador de una sorpresa. Guárdalos en un lugar seguro — permiten vincular un nuevo dispositivo a tus sorpresas.';

  @override
  String get noCreatedSurprises =>
      'Ninguna sorpresa creada en este dispositivo.';

  @override
  String get tokenCopied => '¡Token copiado!';

  @override
  String surpriseId(String id) {
    return 'ID: $id';
  }

  @override
  String get localData => 'Datos locales';

  @override
  String get localDataHint =>
      'Estos datos se almacenan únicamente en este dispositivo.';

  @override
  String get savedShareCodes => 'Códigos de compartición guardados';

  @override
  String get unlockedCodes => 'Códigos de desbloqueo memorizados';

  @override
  String get elementTypeMotus => 'Motus';

  @override
  String get motusWordLabel => 'Palabra a adivinar *';

  @override
  String get motusWordHint => 'Ej: SORPRESA';

  @override
  String get motusFormHint =>
      'El jugador tendrá 6 intentos para adivinar la palabra. La primera letra siempre se revela.';

  @override
  String get playMotus => 'Jugar al Motus';

  @override
  String get motusTitle => 'Motus';

  @override
  String motusAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count intentos restantes',
      one: '1 intento restante',
      zero: 'Sin intentos',
    );
    return '$_temp0';
  }

  @override
  String get motusValidate => 'OK';

  @override
  String get motusWon => '¡Bien hecho! ¡Encontraste la palabra!';

  @override
  String motusLost(String word) {
    return '¡Lástima! La palabra era $word';
  }

  @override
  String get motusRestart => 'Volver a jugar';

  @override
  String get elementTypeScratch => 'Rasca y gana';

  @override
  String get scratchMessageLabel => 'Mensaje a revelar *';

  @override
  String get scratchMessageHint => 'Ej: ¡Nos vemos el sábado a las 20h!';

  @override
  String get scratchFormHint =>
      'El jugador deberá rascar la zona plateada para descubrir tu mensaje.';

  @override
  String get scratchHint => '¡Rasca para revelar!';

  @override
  String scratchProgress(int percent) {
    return '$percent% revelado';
  }

  @override
  String get scratchRevealed => '¡Mensaje revelado!';

  @override
  String get scratchRevealedImage => '¡Imagen revelada!';

  @override
  String get scratchRestart => 'Volver a empezar';

  @override
  String get scratchPlay => '¡Rascar!';

  @override
  String get scratchBackToSurprise => 'Ver la sorpresa';

  @override
  String get scratchContentTypeText => 'Texto';

  @override
  String get scratchContentTypeImage => 'Imagen';

  @override
  String get scratchImageFormHint => 'La imagen se revelará después de rascar.';
}
