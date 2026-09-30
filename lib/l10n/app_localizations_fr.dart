// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LifeKeeper';

  @override
  String get navHome => 'Accueil';

  @override
  String get navTasks => 'Tâches';

  @override
  String get navLists => 'Listes';

  @override
  String get navReceipts => 'Reçus';

  @override
  String get navMore => 'Plus';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get undo => 'Annuler';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get rename => 'Renommer';

  @override
  String get close => 'Fermer';

  @override
  String get all => 'Tout';

  @override
  String get greetingMorning => 'Bonjour';

  @override
  String get greetingAfternoon => 'Bon après-midi';

  @override
  String get greetingEvening => 'Bonsoir';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Aujourd\'hui';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count choses à faire',
      one: '1 chose à faire',
      zero: 'Rien à faire',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Courses';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles',
      one: '1 article',
      zero: 'Rien à acheter',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Reçus';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count enregistrés',
      one: '1 enregistré',
      zero: 'Aucun enregistré',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Dépenses';

  @override
  String get homeSpendingNone => 'Rien ce mois-ci';

  @override
  String get homeHomeTasks => 'Tâches ménagères';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count à faire cette semaine',
      one: '1 à faire cette semaine',
      zero: 'Rien cette semaine',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Abonnements';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actifs',
      zero: 'Aucun ajouté',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Factures et documents';

  @override
  String get homeHomework => 'Devoirs';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count à faire',
      zero: 'Tout est fait',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Prochain examen';

  @override
  String get homeNoExam => 'Aucun examen prévu';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Dans $days jours',
      one: 'Demain',
      zero: 'Aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Médicaments';

  @override
  String get homeAppointments => 'Rendez-vous';

  @override
  String homeNext(String when) {
    return 'Prochain : $when';
  }

  @override
  String get homeNothingPlanned => 'Rien de prévu';

  @override
  String get homeDueToday => 'À faire aujourd\'hui';

  @override
  String get homeAllDone => 'Tout est fait pour aujourd\'hui';

  @override
  String get homeSeeAll => 'Voir tout';

  @override
  String get homeEmergency => 'Contact d\'urgence';

  @override
  String homeCall(String name) {
    return 'Appeler $name';
  }

  @override
  String get homeEmergencyNotSet => 'Ajoutez un contact d\'urgence dans Plus';

  @override
  String get callFailed => 'Impossible de lancer un appel sur cet appareil.';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicyDesc => 'S\'ouvre dans votre navigateur';

  @override
  String get linkFailed =>
      'Impossible d\'ouvrir le lien. Vérifiez votre connexion Internet.';

  @override
  String get tasksTitle => 'Tâches';

  @override
  String get tasksEmptyTitle => 'Rien ici pour le moment';

  @override
  String get tasksEmptyBody => 'Votre liste attend sa première tâche.';

  @override
  String get tasksEmptyFiltered => 'Rien dans cette catégorie.';

  @override
  String get sectionOverdue => 'En retard';

  @override
  String get sectionToday => 'Aujourd\'hui';

  @override
  String get sectionTomorrow => 'Demain';

  @override
  String get sectionThisWeek => 'Cette semaine';

  @override
  String get sectionLater => 'Plus tard';

  @override
  String get sectionNoDate => 'Sans date';

  @override
  String sectionCompleted(int count) {
    return 'Terminées ($count)';
  }

  @override
  String get taskNew => 'Nouvelle tâche';

  @override
  String get taskEdit => 'Modifier la tâche';

  @override
  String get taskTitleLabel => 'Que devez-vous faire ?';

  @override
  String get taskTitleRequired => 'Veuillez saisir un titre';

  @override
  String get taskNotesLabel => 'Notes (facultatif)';

  @override
  String get taskCategoryLabel => 'Type';

  @override
  String get taskDateLabel => 'Date';

  @override
  String get taskNoDate => 'Sans date';

  @override
  String get taskTimeLabel => 'Heure';

  @override
  String get taskAllDay => 'Toute la journée';

  @override
  String get taskRemind => 'Me le rappeler';

  @override
  String get taskRemindAllDayHint =>
      'Vous recevrez un rappel à 09:00 le jour même.';

  @override
  String get taskRemindNeedsDate =>
      'Choisissez une date pour recevoir un rappel.';

  @override
  String get taskRepeatLabel => 'Répéter';

  @override
  String get taskClearDate => 'Supprimer la date';

  @override
  String get taskClearTime => 'Supprimer l\'heure';

  @override
  String get taskCompleted => 'Tâche terminée';

  @override
  String taskRescheduled(String date) {
    return 'C\'est fait. Prochaine fois : $date';
  }

  @override
  String get taskDeleted => 'Tâche supprimée';

  @override
  String get taskMarkDone => 'Marquer comme fait';

  @override
  String get taskMarkNotDone => 'Marquer comme non fait';

  @override
  String get taskOverdue => 'En retard';

  @override
  String get taskRepeats => 'Se répète';

  @override
  String get taskSnoozed => 'Reporté de 10 minutes';

  @override
  String get taskNotFound => 'Cette tâche n\'existe plus.';

  @override
  String get confirmDeleteTitle => 'Supprimer ?';

  @override
  String confirmDeleteItem(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get reminderPermissionDenied =>
      'Les notifications sont désactivées, donc les rappels ne s\'afficheront pas. Vous pouvez les autoriser dans les réglages de votre téléphone.';

  @override
  String get catGeneral => 'Général';

  @override
  String get catStudy => 'Devoirs';

  @override
  String get catExam => 'Examen';

  @override
  String get catHome => 'Maison';

  @override
  String get catAppointment => 'Rendez-vous';

  @override
  String get catMedicine => 'Médicament';

  @override
  String get catDocument => 'Document';

  @override
  String get catSubscription => 'Abonnement';

  @override
  String get catBill => 'Facture';

  @override
  String get repeatNone => 'Ne se répète pas';

  @override
  String get repeatDaily => 'Tous les jours';

  @override
  String get repeatWeekly => 'Toutes les semaines';

  @override
  String get repeatMonthly => 'Tous les mois';

  @override
  String get repeatYearly => 'Tous les ans';

  @override
  String get notifChannelName => 'Rappels';

  @override
  String get notifChannelDescription =>
      'Rappels de tâches, médicaments et rendez-vous';

  @override
  String get notifSnooze => 'Reporter de 10 min';

  @override
  String get notifDone => 'Terminé';

  @override
  String get listsTitle => 'Listes de courses';

  @override
  String get listsEmptyTitle => 'Aucune liste pour le moment';

  @override
  String get listsEmptyBody =>
      'Créez une liste pour les courses, les fournitures scolaires ou autre chose.';

  @override
  String get listNew => 'Nouvelle liste';

  @override
  String get listNameLabel => 'Nom de la liste';

  @override
  String get listNameRequired => 'Veuillez saisir un nom';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articles restants',
      one: '1 article restant',
      zero: 'Tout est fait',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'Liste supprimée';

  @override
  String get listEmptyItems => 'Votre liste attend son premier article.';

  @override
  String get itemAddHint => 'Ajouter un article';

  @override
  String get itemAdd => 'Ajouter l\'article';

  @override
  String get itemEdit => 'Modifier l\'article';

  @override
  String get itemNameLabel => 'Article';

  @override
  String get itemQuantityLabel => 'Quantité (facultatif)';

  @override
  String get itemRemoved => 'Article retiré';

  @override
  String get clearChecked => 'Effacer les articles cochés';

  @override
  String get clearedChecked => 'Articles cochés effacés';

  @override
  String get listOptions => 'Options de la liste';

  @override
  String get receiptsTitle => 'Reçus';

  @override
  String get receiptsEmptyTitle => 'Aucun reçu pour le moment';

  @override
  String get receiptsEmptyBody =>
      'Enregistrez vos reçus pour suivre vos dépenses et garder une preuve d\'achat pour les garanties.';

  @override
  String get receiptNew => 'Nouveau reçu';

  @override
  String get receiptEdit => 'Modifier le reçu';

  @override
  String get receiptMerchantLabel => 'Magasin ou commerçant';

  @override
  String get receiptMerchantRequired =>
      'Veuillez indiquer où vous l\'avez acheté';

  @override
  String get receiptAmountLabel => 'Montant';

  @override
  String receiptAmountInvalid(String example) {
    return 'Saisissez un montant comme $example';
  }

  @override
  String get receiptCurrencyLabel => 'Devise';

  @override
  String get receiptDateLabel => 'Date d\'achat';

  @override
  String get receiptCategoryLabel => 'Catégorie';

  @override
  String get receiptNoteLabel => 'Note (facultatif)';

  @override
  String get receiptWarrantyLabel => 'Garantie jusqu\'au';

  @override
  String get receiptNoWarranty => 'Aucune garantie';

  @override
  String receiptPhoto(String merchant) {
    return 'Photo du reçu de $merchant';
  }

  @override
  String get receiptDeleted => 'Reçu supprimé';

  @override
  String get receiptThisMonth => 'Ce mois-ci';

  @override
  String get receiptSearchHint => 'Rechercher des reçus';

  @override
  String get receiptNoResults => 'Aucun reçu ne correspond à votre recherche.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Garantie jusqu\'au $date';
  }

  @override
  String get receiptWarrantyExpired => 'Garantie expirée';

  @override
  String get rcGroceries => 'Alimentation';

  @override
  String get rcHousehold => 'Maison';

  @override
  String get rcElectronics => 'Électronique';

  @override
  String get rcClothing => 'Vêtements';

  @override
  String get rcHealth => 'Santé';

  @override
  String get rcTransport => 'Transport';

  @override
  String get rcEatingOut => 'Restauration';

  @override
  String get rcSchool => 'École';

  @override
  String get rcOther => 'Autre';

  @override
  String get moreTitle => 'Plus';

  @override
  String get settingsGeneral => 'Général';

  @override
  String get settingsName => 'Votre nom';

  @override
  String get settingsNameNotSet => 'Non défini';

  @override
  String get settingsMode => 'Mode';

  @override
  String get settingsCurrency => 'Devise par défaut';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsTheme => 'Thème';

  @override
  String get themeSystem => 'Comme le téléphone';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get settingsAccessibility => 'Accessibilité';

  @override
  String get settingsLargeText => 'Texte plus grand';

  @override
  String get settingsLargeTextDesc => 'Agrandit tous les textes et boutons.';

  @override
  String get settingsHighContrast => 'Contraste élevé';

  @override
  String get settingsHighContrastDesc =>
      'Des couleurs plus marquées, plus faciles à lire.';

  @override
  String get settingsConfirmDelete => 'Demander avant de supprimer';

  @override
  String get settingsConfirmDeleteDesc =>
      'Afficher une confirmation avant toute suppression.';

  @override
  String get settingsSafety => 'Sécurité';

  @override
  String get settingsEmergency => 'Contact d\'urgence';

  @override
  String get emergencyNameLabel => 'Nom';

  @override
  String get emergencyPhoneLabel => 'Numéro de téléphone';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get aboutBody =>
      'Tout reste sur cet appareil. Pas de compte, pas de publicité, pas de suivi.';

  @override
  String get aboutFormats =>
      'Les dates suivent l\'ordre jour-mois-année et les semaines commencent le lundi.';

  @override
  String get modeStudent => 'Étudiant';

  @override
  String get modeStudentDesc =>
      'Devoirs, examens, listes scolaires et dépenses simples.';

  @override
  String get modeEveryday => 'Quotidien';

  @override
  String get modeEverydayDesc =>
      'Reçus, tâches ménagères, factures, abonnements et courses.';

  @override
  String get modeSimple => 'Simple';

  @override
  String get modeSimpleDesc =>
      'Texte et boutons plus grands, rappels de médicaments et de rendez-vous, contact d\'urgence.';

  @override
  String get onbWelcomeTitle => 'Bienvenue dans LifeKeeper';

  @override
  String get onbWelcomeBody =>
      'Toutes vos affaires du quotidien, dans un seul endroit paisible.';

  @override
  String get onbNext => 'Suivant';

  @override
  String get onbBack => 'Retour';

  @override
  String get onbStart => 'Commencer';

  @override
  String get onbModeTitle => 'Comment allez-vous utiliser LifeKeeper ?';

  @override
  String get onbModeBody => 'Vous pouvez changer cela à tout moment dans Plus.';

  @override
  String get onbNameTitle => 'Comment devons-nous vous appeler ?';

  @override
  String get onbNameHint => 'Votre prénom (facultatif)';

  @override
  String get onbCurrencyTitle => 'Quelle devise utilisez-vous ?';

  @override
  String onbStep(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get navSpending => 'Dépenses';

  @override
  String get spendingTitle => 'Dépenses';

  @override
  String get photoAdd => 'Ajouter une photo';

  @override
  String get photoTake => 'Prendre une photo';

  @override
  String get photoChoose => 'Choisir dans la galerie';

  @override
  String get photoRemove => 'Retirer la photo';

  @override
  String get photoError =>
      'Impossible d\'ajouter la photo. Veuillez réessayer.';

  @override
  String get homeDocuments => 'Documents';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
      zero: 'Aucun enregistré',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expirent bientôt',
      one: '1 expire bientôt',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Documents';

  @override
  String get docsEmptyTitle => 'Aucun document pour le moment';

  @override
  String get docsEmptyBody =>
      'Gardez une trace de votre passeport, carte d\'identité, assurance et plus. LifeKeeper vous rappelle avant leur expiration.';

  @override
  String get docNew => 'Nouveau document';

  @override
  String get docEdit => 'Modifier le document';

  @override
  String get docTypeLabel => 'Type';

  @override
  String get docTitleLabel => 'Nom';

  @override
  String get docNumberLabel => 'Numéro de document (facultatif)';

  @override
  String get docExpiryLabel => 'Expire le';

  @override
  String get docNoExpiry => 'Aucune date d\'expiration';

  @override
  String get docExpired => 'Expiré';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expire dans $days jours',
      one: 'Expire demain',
      zero: 'Expire aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Valide jusqu\'au $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Expire le $date';
  }

  @override
  String get docRemindLabel => 'Rappel';

  @override
  String get docRemindNone => 'Aucun rappel';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours avant',
      one: '1 jour avant',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate =>
      'Ajoutez une date d\'expiration pour recevoir un rappel.';

  @override
  String docPhoto(String title) {
    return 'Photo de $title';
  }

  @override
  String get docDeleted => 'Document supprimé';

  @override
  String get docTypePassport => 'Passeport';

  @override
  String get docTypeIdCard => 'Carte d\'identité';

  @override
  String get docTypeDrivingLicence => 'Permis de conduire';

  @override
  String get docTypeInsurance => 'Assurance';

  @override
  String get docTypeVehicle => 'Voiture / véhicule';

  @override
  String get docTypeHealth => 'Carte de santé';

  @override
  String get docTypeContract => 'Contrat';

  @override
  String get docTypeWarranty => 'Garantie';

  @override
  String get docTypeOther => 'Autre';

  @override
  String get moreOrganise => 'Organiser';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get languageSystem => 'Comme le téléphone';

  @override
  String get listShare => 'Partager la liste';

  @override
  String get listCopied => 'Liste copiée dans le presse-papiers';

  @override
  String get backupTitle => 'Sauvegarde';

  @override
  String get backupCreate => 'Créer une sauvegarde';

  @override
  String get backupCreateDesc =>
      'Enregistrez toutes vos données et photos dans un fichier.';

  @override
  String get backupRestore => 'Restaurer une sauvegarde';

  @override
  String get backupRestoreDesc =>
      'Remplacer toutes les données par un fichier de sauvegarde.';

  @override
  String get backupCreated => 'Sauvegarde enregistrée';

  @override
  String get backupFailed => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get backupInvalid =>
      'Ce fichier n\'est pas une sauvegarde LifeKeeper.';

  @override
  String get backupTooNew =>
      'Cette sauvegarde a été créée avec une version plus récente de LifeKeeper. Veuillez d\'abord mettre à jour l\'application.';

  @override
  String get backupRestoreConfirmTitle => 'Restaurer la sauvegarde ?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Tâches : $tasks\nListes : $lists\nReçus : $receipts\nDocuments : $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Tout ce qui se trouve actuellement dans l\'application sera remplacé.';

  @override
  String get backupRestoreAction => 'Restaurer';

  @override
  String get backupRestored => 'Sauvegarde restaurée';

  @override
  String get modeStudentShort => 'École, examens et argent';

  @override
  String get modeEverydayShort => 'Maison et quotidien';

  @override
  String get modeSimpleShort => 'Plus grand et plus simple';

  @override
  String get homeYourDay => 'Votre journée';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count choses à régler',
      one: '1 chose à régler',
      zero: 'Rien à régler',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Voir';

  @override
  String receiptMonthSpending(String month) {
    return 'Dépenses de $month';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reçus',
      one: '1 reçu',
      zero: 'Aucun reçu',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Expire bientôt';

  @override
  String get tasksAllDoneBody => 'Profitez du reste de votre journée.';

  @override
  String get settingsPalette => 'Thème de couleurs';

  @override
  String get paletteDeepOcean => 'Océan profond';

  @override
  String get paletteMatchaHoney => 'Matcha & miel';

  @override
  String get paletteSunsetPop => 'Coucher de soleil';

  @override
  String get paletteMidnightCandy => 'Bonbon de minuit';

  @override
  String get paletteSoftPastel => 'Pastel doux';

  @override
  String get paletteAlwaysDark => 'Toujours sombre';

  @override
  String get paletteCreamCocoa => 'Crème & cacao';

  @override
  String get paletteNordicSnow => 'Neige nordique';

  @override
  String get paletteSkySunshine => 'Ciel & soleil';

  @override
  String get paletteLavenderNight => 'Nuit lavande';

  @override
  String get paletteLemonCharcoal => 'Citron & anthracite';

  @override
  String get currencySearchHint => 'Rechercher une devise ou un pays';

  @override
  String get currencyPopular => 'Populaires';

  @override
  String get currencyAll => 'Toutes les devises';

  @override
  String get currencyNoResults => 'Aucune devise trouvée';

  @override
  String get currencyMore => 'Autres devises';

  @override
  String get receiptDateFuture =>
      'La date d\'achat ne peut pas être dans le futur.';

  @override
  String get homeUpcomingTasks => 'Tâches à venir';

  @override
  String get taskPastDateTime =>
      'La date et l\'heure ne peuvent pas être dans le passé.';

  @override
  String get reminderOnTimeTitle => 'Autoriser les rappels à l’heure';

  @override
  String get reminderOnTimeBody =>
      'Android peut retarder les rappels pendant que votre téléphone est en veille. Pour les recevoir à l’heure exacte, même quand LifeKeeper est fermé, activez « Alarmes et rappels » pour LifeKeeper sur l’écran suivant.';

  @override
  String get reminderOnTimeAllow => 'Autoriser';

  @override
  String get reminderOnTimeLater => 'Plus tard';
}
