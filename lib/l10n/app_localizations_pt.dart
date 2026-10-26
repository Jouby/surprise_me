// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Surprise Me';

  @override
  String get myCreations => 'Minhas criações';

  @override
  String get joinedSurprises => 'Participando';

  @override
  String get refresh => 'Atualizar';

  @override
  String get yourSurprises => 'Suas surpresas';

  @override
  String get noSurpriseYet => 'Nenhuma surpresa ainda';

  @override
  String get noSurpriseHint =>
      'Crie uma surpresa ou digite\num código para participar.';

  @override
  String get loadError => 'Não foi possível carregar as surpresas';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get join => 'Participar';

  @override
  String get create => 'Criar';

  @override
  String get joinSurpriseTitle => 'Participar de uma surpresa';

  @override
  String get enterSharedCode =>
      'Digite o código compartilhado pelo organizador.';

  @override
  String get codeNotFound =>
      'Código não encontrado. Verifique e tente novamente.';

  @override
  String get createSurprise => 'Criar uma surpresa';

  @override
  String get identity => 'Identidade';

  @override
  String elementsCount(int count) {
    return 'Elementos ($count)';
  }

  @override
  String get elementsHint =>
      'Cada elemento pode ser revelado com um código diferente.';

  @override
  String get titleLabel => 'Título *';

  @override
  String get requiredField => 'Obrigatório';

  @override
  String get subtitleLabel => 'Subtítulo (opcional)';

  @override
  String get themeColor => 'Cor do tema';

  @override
  String get addElement => 'Adicionar um elemento';

  @override
  String get creating => 'Criando…';

  @override
  String get createButton => 'Criar surpresa';

  @override
  String get addAtLeastOneElement => 'Adicione pelo menos um elemento.';

  @override
  String get completeAllElements => 'Preencha todos os elementos.';

  @override
  String errorPrefix(String error) {
    return 'Erro: $error';
  }

  @override
  String get genericError => 'Ocorreu um erro. Tente novamente.';

  @override
  String get linkCopied => 'Link copiado!';

  @override
  String get surpriseCreated => 'Surpresa criada!';

  @override
  String get shareCodeHint =>
      'Compartilhe este código para que seus queridos\npossam descobrir a surpresa.';

  @override
  String get copy => 'Copiar';

  @override
  String get share => 'Compartilhar';

  @override
  String shareMessage(String link, String code) {
    return 'Tenho uma surpresa para você! 🎁\nAbra este link para descobri-la: $link\n\nOu digite o código manualmente: $code';
  }

  @override
  String get backToHome => 'Voltar ao início';

  @override
  String elementN(int n) {
    return 'Elemento $n';
  }

  @override
  String codeLabel(String code) {
    return 'Código: $code';
  }

  @override
  String get editSurprise => 'Editar surpresa';

  @override
  String get editElementsHint =>
      'Toque em um elemento para editá-lo, arraste para reordenar.';

  @override
  String get titleRequired => 'O título é obrigatório.';

  @override
  String get saving => 'Salvando…';

  @override
  String get saveButton => 'Salvar alterações';

  @override
  String get newBadge => 'Novo';

  @override
  String get deleteDialogTitle => 'Excluir esta surpresa?';

  @override
  String get deleteOwnerContent =>
      'Esta ação é irreversível. A surpresa e todos os seus elementos serão excluídos permanentemente.';

  @override
  String get deleteGuestContent =>
      'A surpresa será removida da sua lista. Você pode participar novamente com o código dela.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get remove => 'Remover';

  @override
  String get ownerBanner =>
      'Você é o criador · Toque em um código para revelá-lo';

  @override
  String shareWithCode(String code) {
    return 'Compartilhar · $code';
  }

  @override
  String get revealedElements => 'Elementos revelados';

  @override
  String get enterCode => 'Digitar um código';

  @override
  String onboardingUnlockHint(String code) {
    return 'Toque aqui para digitar seu código secreto e revelar um elemento! 🗝️\n\nPara começar, digite o código: $code';
  }

  @override
  String shareSheetTitle(String title) {
    return 'Compartilhar \"$title\"';
  }

  @override
  String get shareAccessHint =>
      'Compartilhe este código para que seus queridos\npossam acessar esta surpresa.';

  @override
  String get linkCopiedClipboard => 'Link copiado para a área de transferência';

  @override
  String get editElement => 'Editar elemento';

  @override
  String get newElement => 'Novo elemento';

  @override
  String get elementTitleLabel => 'Título do elemento *';

  @override
  String get fieldRequired => 'Este campo é obrigatório';

  @override
  String get selectDate => 'Selecione uma data *';

  @override
  String get pleaseSelectDate => 'Selecione uma data';

  @override
  String get pleaseAddImage => 'Adicione uma imagem';

  @override
  String get pleaseEnterLocation => 'Digite um local';

  @override
  String get pleaseEnterWord => 'Digite uma palavra';

  @override
  String get unlockCodeLabel => 'Código de desbloqueio *';

  @override
  String get unlockCodeHint => 'ex.: SEGREDO1';

  @override
  String get unlockCodeInfo =>
      'É o código que o destinatário deve digitar para revelar este elemento. Você pode passá-lo pessoalmente, por mensagem ou escondê-lo em outro elemento.';

  @override
  String get generateCode => 'Gerar um código';

  @override
  String get solveCodeLabel => 'Código de recompensa (opcional)';

  @override
  String get solveCodeHint => 'ex.: NIVEL2 — deixe vazio se não houver';

  @override
  String get solveCodeInfo =>
      'Opcional. Este código é inserido automaticamente quando o destinatário resolve este jogo, desbloqueando outro elemento da surpresa sem que ele precise digitá-lo.';

  @override
  String get save => 'Salvar';

  @override
  String get add => 'Adicionar';

  @override
  String get elementGroupContent => 'Conteúdo';

  @override
  String get elementGroupGames => 'Jogos';

  @override
  String get elementTypeText => 'Texto';

  @override
  String get elementTypeImage => 'Imagem';

  @override
  String get elementTypeDate => 'Data';

  @override
  String get elementTypeLocation => 'Local';

  @override
  String get elementTypeWordGame => 'Jogo de palavras';

  @override
  String get elementTypePuzzle => 'Quebra-cabeça';

  @override
  String get messageContent => 'Conteúdo da mensagem *';

  @override
  String get wordToGuessLabel => 'Palavra a adivinhar *';

  @override
  String get wordToGuessHint => 'ex.: SURPRESA';

  @override
  String get wordGameHint =>
      'As letras serão embaralhadas. O jogador precisa colocá-las de volta na ordem certa.';

  @override
  String get enterYourCode => 'Digite seu código';

  @override
  String get codeUnlocksElement =>
      'Cada código desbloqueia um elemento da surpresa.';

  @override
  String get codeAccepted => 'Código aceito! Um elemento foi revelado.';

  @override
  String get invalidCode => 'Código inválido. Verifique e tente novamente.';

  @override
  String get unlock => 'Desbloquear';

  @override
  String get unlocked => 'Desbloqueado';

  @override
  String get enterCodeToReveal => 'Digite um código para revelar';

  @override
  String get congratulations => 'Muito bem! Você encontrou a palavra!';

  @override
  String get shuffleAgain => 'Embaralhar de novo';

  @override
  String get uploadError => 'Erro no envio. Tente novamente.';

  @override
  String get addImage => 'Adicionar uma imagem';

  @override
  String get gallery => 'Galeria';

  @override
  String get camera => 'Câmera';

  @override
  String get change => 'Alterar';

  @override
  String get galleryOrCamera => 'Galeria ou câmera';

  @override
  String get uploading => 'Enviando…';

  @override
  String get preview => 'Pré-visualizar';

  @override
  String get previewBanner =>
      'Você está vendo a surpresa como o destinatário verá · Todos os elementos estão desbloqueados';

  @override
  String get exitPreview => 'Sair da pré-visualização';

  @override
  String get settings => 'Configurações';

  @override
  String get creatorTokens => 'Token de criador';

  @override
  String get creatorTokensHint =>
      'Este token está ligado à sua conta e comprova que você é o criador das suas surpresas. Guarde-o com cuidado — ele permite vincular um novo dispositivo à sua conta.';

  @override
  String get noCreatedSurprises => 'Nenhuma surpresa criada neste dispositivo.';

  @override
  String get tokenCopied => 'Token copiado!';

  @override
  String surpriseId(String id) {
    return 'ID: $id';
  }

  @override
  String get localData => 'Meus dados';

  @override
  String get localDataHint =>
      'Estes dados são armazenados apenas neste dispositivo.';

  @override
  String get savedShareCodes => 'Códigos de compartilhamento salvos';

  @override
  String get unlockedCodes => 'Códigos de desbloqueio memorizados';

  @override
  String get clearLocalDataButton => 'Excluir todos os meus dados';

  @override
  String get clearLocalDataTitle => 'Excluir todos os meus dados?';

  @override
  String get clearLocalDataContent =>
      'Isto excluirá permanentemente:\n\n• Todas as surpresas que você criou (em todos os dispositivos)\n• Todas as surpresas de que você participa neste dispositivo\n• Seu progresso (códigos desbloqueados, jogos resolvidos)\n\nEsta ação não pode ser desfeita.';

  @override
  String get clearLocalDataConfirm => 'Excluir tudo';

  @override
  String get clearLocalDataDone => 'Todos os seus dados foram excluídos.';

  @override
  String get clearLocalDataHint =>
      'Exclui permanentemente as surpresas que você criou, remove as surpresas de que participa e apaga seu progresso neste dispositivo.';

  @override
  String get elementTypeMotus => 'Motus';

  @override
  String get motusWordLabel => 'Palavra a adivinhar *';

  @override
  String get motusWordHint => 'Ex.: SURPRESA';

  @override
  String get motusFormHint =>
      'O jogador terá 6 tentativas para adivinhar a palavra. A primeira letra é sempre revelada.';

  @override
  String get playMotus => 'Jogar Motus';

  @override
  String get motusTitle => 'Motus';

  @override
  String motusAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativas restantes',
      one: '1 tentativa restante',
      zero: 'Nenhuma tentativa restante',
    );
    return '$_temp0';
  }

  @override
  String get motusValidate => 'OK';

  @override
  String get motusWon => 'Muito bem! Você encontrou a palavra!';

  @override
  String motusLost(String word) {
    return 'Que pena… A palavra era $word';
  }

  @override
  String get motusRestart => 'Jogar de novo';

  @override
  String get motusRevealed => 'Palavra encontrada!';

  @override
  String get elementTypeScratch => 'Raspadinha';

  @override
  String get scratchMessageLabel => 'Mensagem a revelar *';

  @override
  String get scratchMessageHint => 'Ex.: Até sábado às 20h!';

  @override
  String get scratchFormHint =>
      'O jogador vai raspar a área prateada para descobrir sua mensagem.';

  @override
  String get scratchHint => 'Raspe para revelar!';

  @override
  String scratchProgress(int percent) {
    return '$percent% revelado';
  }

  @override
  String get scratchRevealed => 'Mensagem revelada!';

  @override
  String get scratchRevealedImage => 'Imagem revelada!';

  @override
  String get scratchRestart => 'Recomeçar';

  @override
  String get scratchPlay => 'Raspar!';

  @override
  String get scratchBackToSurprise => 'Ver a surpresa';

  @override
  String get scratchContentTypeText => 'Texto';

  @override
  String get scratchContentTypeImage => 'Imagem';

  @override
  String get scratchImageFormHint =>
      'A imagem será revelada depois de raspada.';

  @override
  String get elementTypeCodeGame => 'Código secreto';

  @override
  String get codeGameSecretLabel => 'Código de 4 dígitos *';

  @override
  String get codeGameSecretHint => 'Ex.: 4729';

  @override
  String get codeGameFormHint =>
      'O jogador terá 8 tentativas para adivinhar o código. Após cada tentativa, recebe dicas sobre os dígitos corretos.';

  @override
  String get codeGameInvalidCode => 'O código deve ter exatamente 4 dígitos';

  @override
  String get codeGamePlay => 'Adivinhar o código';

  @override
  String codeGameAttemptsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tentativas restantes',
      one: '1 tentativa restante',
      zero: 'Nenhuma tentativa restante',
    );
    return '$_temp0';
  }

  @override
  String get codeGameValidate => 'OK';

  @override
  String get codeGameWon => 'Muito bem! Você decifrou o código!';

  @override
  String codeGameLost(String code) {
    return 'Que pena… O código era $code';
  }

  @override
  String get codeGameRestart => 'Jogar de novo';

  @override
  String get codeGameSolved => 'Código decifrado!';

  @override
  String get premiumTitle => 'Surprise Me Premium';

  @override
  String get premiumPerkUnlimited => 'Crie quantas surpresas quiser';

  @override
  String get premiumPerkGames => 'Acesso a todos os elementos do tipo Jogo';

  @override
  String get premiumPerkOneTime => 'Compra única, sem assinatura';

  @override
  String get premiumBuy => 'Seja Premium';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumRestoreNotFound =>
      'Nenhuma compra encontrada para restaurar.';

  @override
  String get premiumLimitReached =>
      'Você atingiu o limite gratuito (1 surpresa). Seja Premium para criar mais.';

  @override
  String get premiumGamesLocked =>
      'Os jogos estão disponíveis apenas para usuários Premium.';
}
