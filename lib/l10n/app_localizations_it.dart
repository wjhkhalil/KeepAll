// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'KeepAll';

  @override
  String get navHome => 'Home';

  @override
  String get navTasks => 'Attività';

  @override
  String get navLists => 'Liste';

  @override
  String get navReceipts => 'Ricevute';

  @override
  String get navMore => 'Altro';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get undo => 'Annulla';

  @override
  String get edit => 'Modifica';

  @override
  String get add => 'Aggiungi';

  @override
  String get rename => 'Rinomina';

  @override
  String get close => 'Chiudi';

  @override
  String get all => 'Tutti';

  @override
  String get greetingMorning => 'Buongiorno';

  @override
  String get greetingAfternoon => 'Buon pomeriggio';

  @override
  String get greetingEvening => 'Buonasera';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Oggi';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cose da fare',
      one: '1 cosa da fare',
      zero: 'Niente da fare',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Spesa';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '1 articolo',
      zero: 'Niente da comprare',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Ricevute';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count salvate',
      one: '1 salvata',
      zero: 'Nessuna salvata',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Spese';

  @override
  String get homeSpendingNone => 'Niente questo mese';

  @override
  String get homeHomeTasks => 'Faccende di casa';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in scadenza questa settimana',
      one: '1 in scadenza questa settimana',
      zero: 'Niente questa settimana',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Abbonamenti';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attivi',
      zero: 'Nessuno aggiunto',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Bollette e documenti';

  @override
  String get homeHomework => 'Compiti';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count da fare',
      zero: 'Tutto fatto',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Prossimo esame';

  @override
  String get homeNoExam => 'Nessun esame in programma';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tra $days giorni',
      one: 'Domani',
      zero: 'Oggi',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Farmaci';

  @override
  String get homeAppointments => 'Appuntamenti';

  @override
  String homeNext(String when) {
    return 'Prossimo: $when';
  }

  @override
  String get homeNothingPlanned => 'Niente in programma';

  @override
  String get homeDueToday => 'In scadenza oggi';

  @override
  String get homeAllDone => 'Tutto fatto per oggi';

  @override
  String get homeSeeAll => 'Vedi tutto';

  @override
  String get homeEmergency => 'Contatto di emergenza';

  @override
  String homeCall(String name) {
    return 'Chiama $name';
  }

  @override
  String get homeEmergencyNotSet =>
      'Aggiungi un contatto di emergenza in Altro';

  @override
  String get callFailed =>
      'Non è stato possibile avviare la chiamata su questo dispositivo.';

  @override
  String get tasksTitle => 'Attività';

  @override
  String get tasksEmptyTitle => 'Non c\'è ancora niente qui';

  @override
  String get tasksEmptyBody => 'La tua lista aspetta la sua prima attività.';

  @override
  String get tasksEmptyFiltered => 'Niente in questa categoria.';

  @override
  String get sectionOverdue => 'In ritardo';

  @override
  String get sectionToday => 'Oggi';

  @override
  String get sectionTomorrow => 'Domani';

  @override
  String get sectionThisWeek => 'Questa settimana';

  @override
  String get sectionLater => 'Più avanti';

  @override
  String get sectionNoDate => 'Nessuna data';

  @override
  String sectionCompleted(int count) {
    return 'Completate ($count)';
  }

  @override
  String get taskNew => 'Nuova attività';

  @override
  String get taskEdit => 'Modifica attività';

  @override
  String get taskTitleLabel => 'Cosa devi fare?';

  @override
  String get taskTitleRequired => 'Inserisci un titolo';

  @override
  String get taskNotesLabel => 'Note (facoltative)';

  @override
  String get taskCategoryLabel => 'Tipo';

  @override
  String get taskDateLabel => 'Data';

  @override
  String get taskNoDate => 'Nessuna data';

  @override
  String get taskTimeLabel => 'Ora';

  @override
  String get taskAllDay => 'Tutto il giorno';

  @override
  String get taskRemind => 'Ricordamelo';

  @override
  String get taskRemindAllDayHint =>
      'Riceverai un promemoria alle 09:00 quel giorno.';

  @override
  String get taskRemindNeedsDate =>
      'Scegli una data per ricevere un promemoria.';

  @override
  String get taskRepeatLabel => 'Ripeti';

  @override
  String get taskClearDate => 'Rimuovi data';

  @override
  String get taskClearTime => 'Rimuovi ora';

  @override
  String get taskCompleted => 'Attività completata';

  @override
  String taskRescheduled(String date) {
    return 'Fatto. Prossima volta: $date';
  }

  @override
  String get taskDeleted => 'Attività eliminata';

  @override
  String get taskMarkDone => 'Segna come fatto';

  @override
  String get taskMarkNotDone => 'Segna come non fatto';

  @override
  String get taskOverdue => 'In ritardo';

  @override
  String get taskRepeats => 'Si ripete';

  @override
  String get taskSnoozed => 'Rimandato di 10 minuti';

  @override
  String get taskNotFound => 'Questa attività non esiste più.';

  @override
  String get confirmDeleteTitle => 'Eliminare?';

  @override
  String confirmDeleteItem(String name) {
    return 'Eliminare \"$name\"?';
  }

  @override
  String get reminderPermissionDenied =>
      'Le notifiche sono disattivate, quindi i promemoria non appariranno. Puoi attivarle nelle impostazioni del telefono.';

  @override
  String get catGeneral => 'Generale';

  @override
  String get catStudy => 'Compiti';

  @override
  String get catExam => 'Esame';

  @override
  String get catHome => 'Casa';

  @override
  String get catAppointment => 'Appuntamento';

  @override
  String get catMedicine => 'Farmaco';

  @override
  String get catDocument => 'Documento';

  @override
  String get catSubscription => 'Abbonamento';

  @override
  String get catBill => 'Bolletta';

  @override
  String get repeatNone => 'Non si ripete';

  @override
  String get repeatDaily => 'Ogni giorno';

  @override
  String get repeatWeekly => 'Ogni settimana';

  @override
  String get repeatMonthly => 'Ogni mese';

  @override
  String get repeatYearly => 'Ogni anno';

  @override
  String get notifChannelName => 'Promemoria';

  @override
  String get notifChannelDescription =>
      'Promemoria per attività, farmaci e appuntamenti';

  @override
  String get notifSnooze => 'Rimanda 10 min';

  @override
  String get notifDone => 'Fatto';

  @override
  String get listsTitle => 'Liste della spesa';

  @override
  String get listsEmptyTitle => 'Nessuna lista';

  @override
  String get listsEmptyBody =>
      'Crea una lista per la spesa, il materiale scolastico o altro.';

  @override
  String get listNew => 'Nuova lista';

  @override
  String get listNameLabel => 'Nome della lista';

  @override
  String get listNameRequired => 'Inserisci un nome';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli rimasti',
      one: '1 articolo rimasto',
      zero: 'Tutto fatto',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'Lista eliminata';

  @override
  String get listEmptyItems => 'La tua lista aspetta il suo primo articolo.';

  @override
  String get itemAddHint => 'Aggiungi un articolo';

  @override
  String get itemAdd => 'Aggiungi articolo';

  @override
  String get itemEdit => 'Modifica articolo';

  @override
  String get itemNameLabel => 'Articolo';

  @override
  String get itemQuantityLabel => 'Quantità (facoltativa)';

  @override
  String get itemRemoved => 'Articolo rimosso';

  @override
  String get clearChecked => 'Rimuovi gli articoli spuntati';

  @override
  String get clearedChecked => 'Articoli spuntati rimossi';

  @override
  String get listOptions => 'Opzioni lista';

  @override
  String get receiptsTitle => 'Ricevute';

  @override
  String get receiptsEmptyTitle => 'Nessuna ricevuta';

  @override
  String get receiptsEmptyBody =>
      'Salva le ricevute per tenere traccia delle spese e avere una prova d\'acquisto per le garanzie.';

  @override
  String get receiptNew => 'Nuova ricevuta';

  @override
  String get receiptEdit => 'Modifica ricevuta';

  @override
  String get receiptMerchantLabel => 'Negozio o venditore';

  @override
  String get receiptMerchantRequired => 'Inserisci dove l\'hai acquistato';

  @override
  String get receiptAmountLabel => 'Importo';

  @override
  String receiptAmountInvalid(String example) {
    return 'Inserisci un importo come $example';
  }

  @override
  String get receiptCurrencyLabel => 'Valuta';

  @override
  String get receiptDateLabel => 'Data di acquisto';

  @override
  String get receiptCategoryLabel => 'Categoria';

  @override
  String get receiptNoteLabel => 'Nota (facoltativa)';

  @override
  String get receiptWarrantyLabel => 'Garanzia fino al';

  @override
  String get receiptNoWarranty => 'Nessuna garanzia';

  @override
  String receiptPhoto(String merchant) {
    return 'Foto della ricevuta di $merchant';
  }

  @override
  String get receiptDeleted => 'Ricevuta eliminata';

  @override
  String get receiptThisMonth => 'Questo mese';

  @override
  String get receiptSearchHint => 'Cerca ricevute';

  @override
  String get receiptNoResults =>
      'Nessuna ricevuta corrisponde alla tua ricerca.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Garanzia fino al $date';
  }

  @override
  String get receiptWarrantyExpired => 'Garanzia scaduta';

  @override
  String get rcGroceries => 'Alimentari';

  @override
  String get rcHousehold => 'Casa';

  @override
  String get rcElectronics => 'Elettronica';

  @override
  String get rcClothing => 'Abbigliamento';

  @override
  String get rcHealth => 'Salute';

  @override
  String get rcTransport => 'Trasporti';

  @override
  String get rcEatingOut => 'Fuori a mangiare';

  @override
  String get rcSchool => 'Scuola';

  @override
  String get rcOther => 'Altro';

  @override
  String get moreTitle => 'Altro';

  @override
  String get settingsGeneral => 'Generale';

  @override
  String get settingsName => 'Il tuo nome';

  @override
  String get settingsNameNotSet => 'Non impostato';

  @override
  String get settingsMode => 'Modalità';

  @override
  String get settingsCurrency => 'Valuta predefinita';

  @override
  String get settingsAppearance => 'Aspetto';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Come il telefono';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get settingsAccessibility => 'Accessibilità';

  @override
  String get settingsLargeText => 'Testo più grande';

  @override
  String get settingsLargeTextDesc =>
      'Rende tutto il testo e i pulsanti più grandi.';

  @override
  String get settingsHighContrast => 'Contrasto elevato';

  @override
  String get settingsHighContrastDesc =>
      'Colori più forti e più facili da leggere.';

  @override
  String get settingsConfirmDelete => 'Chiedi prima di eliminare';

  @override
  String get settingsConfirmDeleteDesc =>
      'Mostra una conferma prima di eliminare qualsiasi cosa.';

  @override
  String get settingsSafety => 'Sicurezza';

  @override
  String get settingsEmergency => 'Contatto di emergenza';

  @override
  String get emergencyNameLabel => 'Nome';

  @override
  String get emergencyPhoneLabel => 'Numero di telefono';

  @override
  String get settingsAbout => 'Informazioni';

  @override
  String get aboutBody =>
      'Tutto resta su questo dispositivo. Nessun account, nessuna pubblicità, nessun tracciamento.';

  @override
  String get aboutFormats =>
      'Le date seguono l\'ordine giorno-mese-anno e le settimane iniziano di lunedì.';

  @override
  String get modeStudent => 'Studente';

  @override
  String get modeStudentDesc =>
      'Compiti, esami, liste per la scuola e spese semplici.';

  @override
  String get modeEveryday => 'Quotidiano';

  @override
  String get modeEverydayDesc =>
      'Ricevute, faccende di casa, bollette, abbonamenti e spesa.';

  @override
  String get modeSimple => 'Semplice';

  @override
  String get modeSimpleDesc =>
      'Testo e pulsanti più grandi, promemoria per farmaci e appuntamenti, contatto di emergenza.';

  @override
  String get onbWelcomeTitle => 'Benvenuto in KeepAll';

  @override
  String get onbWelcomeBody =>
      'Le tue cose di ogni giorno, tutte in un unico posto tranquillo.';

  @override
  String get onbNext => 'Avanti';

  @override
  String get onbBack => 'Indietro';

  @override
  String get onbStart => 'Inizia';

  @override
  String get onbModeTitle => 'Come vuoi usare KeepAll?';

  @override
  String get onbModeBody => 'Puoi cambiarlo in qualsiasi momento in Altro.';

  @override
  String get onbNameTitle => 'Come ti chiamiamo?';

  @override
  String get onbNameHint => 'Il tuo nome (facoltativo)';

  @override
  String get onbCurrencyTitle => 'Quale valuta usi?';

  @override
  String onbStep(int step, int total) {
    return 'Passo $step di $total';
  }

  @override
  String get navSpending => 'Spese';

  @override
  String get spendingTitle => 'Spese';

  @override
  String get photoAdd => 'Aggiungi foto';

  @override
  String get photoTake => 'Scatta foto';

  @override
  String get photoChoose => 'Scegli dalla galleria';

  @override
  String get photoRemove => 'Rimuovi foto';

  @override
  String get photoError => 'Non è stato possibile aggiungere la foto. Riprova.';

  @override
  String get homeDocuments => 'Documenti';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documenti',
      one: '1 documento',
      zero: 'Nessuno salvato',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count in scadenza',
      one: '1 in scadenza',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Documenti';

  @override
  String get docsEmptyTitle => 'Nessun documento';

  @override
  String get docsEmptyBody =>
      'Tieni sotto controllo passaporto, carta d\'identità, assicurazione e altro. KeepAll ti avvisa prima che scadano.';

  @override
  String get docNew => 'Nuovo documento';

  @override
  String get docEdit => 'Modifica documento';

  @override
  String get docTypeLabel => 'Tipo';

  @override
  String get docTitleLabel => 'Nome';

  @override
  String get docNumberLabel => 'Numero del documento (facoltativo)';

  @override
  String get docExpiryLabel => 'Scade il';

  @override
  String get docNoExpiry => 'Nessuna data di scadenza';

  @override
  String get docExpired => 'Scaduto';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Scade tra $days giorni',
      one: 'Scade domani',
      zero: 'Scade oggi',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Valido fino al $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Scade il $date';
  }

  @override
  String get docRemindLabel => 'Promemoria';

  @override
  String get docRemindNone => 'Nessun promemoria';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni prima',
      one: '1 giorno prima',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate =>
      'Aggiungi una data di scadenza per ricevere un promemoria.';

  @override
  String docPhoto(String title) {
    return 'Foto di $title';
  }

  @override
  String get docDeleted => 'Documento eliminato';

  @override
  String get docTypePassport => 'Passaporto';

  @override
  String get docTypeIdCard => 'Carta d\'identità';

  @override
  String get docTypeDrivingLicence => 'Patente di guida';

  @override
  String get docTypeInsurance => 'Assicurazione';

  @override
  String get docTypeVehicle => 'Auto / veicolo';

  @override
  String get docTypeHealth => 'Tessera sanitaria';

  @override
  String get docTypeContract => 'Contratto';

  @override
  String get docTypeWarranty => 'Garanzia';

  @override
  String get docTypeOther => 'Altro';

  @override
  String get moreOrganise => 'Organizza';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get languageSystem => 'Come il telefono';

  @override
  String get listShare => 'Condividi lista';

  @override
  String get listCopied => 'Lista copiata negli appunti';

  @override
  String get backupTitle => 'Backup';

  @override
  String get backupCreate => 'Crea backup';

  @override
  String get backupCreateDesc =>
      'Salva tutti i tuoi dati e le tue foto in un file.';

  @override
  String get backupRestore => 'Ripristina da backup';

  @override
  String get backupRestoreDesc => 'Sostituisci tutto con un file di backup.';

  @override
  String get backupCreated => 'Backup salvato';

  @override
  String get backupFailed => 'Qualcosa è andato storto. Riprova.';

  @override
  String get backupInvalid => 'Questo file non è un backup di KeepAll.';

  @override
  String get backupTooNew =>
      'Questo backup è stato creato con una versione più recente di KeepAll. Aggiorna prima l\'app.';

  @override
  String get backupRestoreConfirmTitle => 'Ripristinare il backup?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Attività: $tasks\nListe: $lists\nRicevute: $receipts\nDocumenti: $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Tutto ciò che è attualmente nell\'app verrà sostituito.';

  @override
  String get backupRestoreAction => 'Ripristina';

  @override
  String get backupRestored => 'Backup ripristinato';

  @override
  String get modeStudentShort => 'Scuola, esami e soldi';

  @override
  String get modeEverydayShort => 'Casa e vita quotidiana';

  @override
  String get modeSimpleShort => 'Più grande e più semplice';

  @override
  String get homeYourDay => 'La tua giornata';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cose di cui occuparti',
      one: '1 cosa di cui occuparti',
      zero: 'Niente di cui occuparti',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Vedi';

  @override
  String receiptMonthSpending(String month) {
    return 'Spese di $month';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ricevute',
      one: '1 ricevuta',
      zero: 'Nessuna ricevuta',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Scade presto';

  @override
  String get tasksAllDoneBody => 'Goditi il resto della giornata.';

  @override
  String get settingsPalette => 'Tema colori';

  @override
  String get paletteDeepOcean => 'Oceano profondo';

  @override
  String get paletteMatchaHoney => 'Matcha e miele';

  @override
  String get paletteSunsetPop => 'Tramonto';

  @override
  String get paletteMidnightCandy => 'Caramella di mezzanotte';

  @override
  String get paletteSoftPastel => 'Pastello tenue';

  @override
  String get paletteAlwaysDark => 'Sempre scuro';

  @override
  String get paletteCreamCocoa => 'Crema e cacao';

  @override
  String get paletteNordicSnow => 'Neve nordica';

  @override
  String get paletteSkySunshine => 'Cielo e sole';

  @override
  String get paletteLavenderNight => 'Notte di lavanda';

  @override
  String get paletteLemonCharcoal => 'Limone e antracite';

  @override
  String get currencySearchHint => 'Cerca valuta o paese';

  @override
  String get currencyPopular => 'Più usate';

  @override
  String get currencyAll => 'Tutte le valute';

  @override
  String get currencyNoResults => 'Nessuna valuta trovata';

  @override
  String get currencyMore => 'Altre valute';

  @override
  String get receiptDateFuture =>
      'La data di acquisto non può essere nel futuro.';

  @override
  String get homeUpcomingTasks => 'Prossime attività';

  @override
  String get taskPastDateTime =>
      'La data e l\'ora non possono essere nel passato.';

  @override
  String get reminderOnTimeTitle => 'Consenti promemoria puntuali';

  @override
  String get reminderOnTimeBody =>
      'Android può ritardare i promemoria mentre il telefono è in standby. Per riceverli all’ora esatta, anche con KeepAll chiusa, attiva «Sveglie e promemoria» per KeepAll nella schermata successiva.';

  @override
  String get reminderOnTimeAllow => 'Consenti';

  @override
  String get reminderOnTimeLater => 'Non ora';
}
