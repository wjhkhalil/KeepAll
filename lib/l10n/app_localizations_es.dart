// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'KeepAll';

  @override
  String get navHome => 'Inicio';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navLists => 'Listas';

  @override
  String get navReceipts => 'Recibos';

  @override
  String get navMore => 'Más';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get undo => 'Deshacer';

  @override
  String get edit => 'Editar';

  @override
  String get add => 'Añadir';

  @override
  String get rename => 'Renombrar';

  @override
  String get close => 'Cerrar';

  @override
  String get all => 'Todo';

  @override
  String get greetingMorning => 'Buenos días';

  @override
  String get greetingAfternoon => 'Buenas tardes';

  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeToday => 'Hoy';

  @override
  String homeTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cosas pendientes',
      one: '1 cosa pendiente',
      zero: 'Nada pendiente',
    );
    return '$_temp0';
  }

  @override
  String get homeShopping => 'Compra';

  @override
  String homeShoppingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos',
      one: '1 artículo',
      zero: 'Nada que comprar',
    );
    return '$_temp0';
  }

  @override
  String get homeReceipts => 'Recibos';

  @override
  String homeReceiptsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count guardados',
      one: '1 guardado',
      zero: 'Ninguno guardado',
    );
    return '$_temp0';
  }

  @override
  String get homeSpending => 'Gastos';

  @override
  String get homeSpendingNone => 'Nada este mes';

  @override
  String get homeHomeTasks => 'Tareas del hogar';

  @override
  String homeDueThisWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pendientes esta semana',
      one: '1 pendiente esta semana',
      zero: 'Nada esta semana',
    );
    return '$_temp0';
  }

  @override
  String get homeSubscriptions => 'Suscripciones';

  @override
  String homeActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count activas',
      zero: 'Ninguna añadida',
    );
    return '$_temp0';
  }

  @override
  String get homeBills => 'Facturas y documentos';

  @override
  String get homeHomework => 'Deberes';

  @override
  String homeOpen(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count por hacer',
      zero: 'Todo hecho',
    );
    return '$_temp0';
  }

  @override
  String get homeNextExam => 'Próximo examen';

  @override
  String get homeNoExam => 'No hay exámenes planeados';

  @override
  String examCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'En $days días',
      one: 'Mañana',
      zero: 'Hoy',
    );
    return '$_temp0';
  }

  @override
  String get homeMedicine => 'Medicinas';

  @override
  String get homeAppointments => 'Citas';

  @override
  String homeNext(String when) {
    return 'Próximo: $when';
  }

  @override
  String get homeNothingPlanned => 'Nada planeado';

  @override
  String get homeDueToday => 'Para hoy';

  @override
  String get homeAllDone => 'Todo hecho por hoy';

  @override
  String get homeSeeAll => 'Ver todo';

  @override
  String get homeEmergency => 'Contacto de emergencia';

  @override
  String homeCall(String name) {
    return 'Llamar a $name';
  }

  @override
  String get homeEmergencyNotSet => 'Añade un contacto de emergencia en Más';

  @override
  String get callFailed =>
      'No se ha podido iniciar la llamada en este dispositivo.';

  @override
  String get tasksTitle => 'Tareas';

  @override
  String get tasksEmptyTitle => 'Todavía no hay nada aquí';

  @override
  String get tasksEmptyBody => 'Tu lista está esperando su primera tarea.';

  @override
  String get tasksEmptyFiltered => 'No hay nada en esta categoría.';

  @override
  String get sectionOverdue => 'Atrasadas';

  @override
  String get sectionToday => 'Hoy';

  @override
  String get sectionTomorrow => 'Mañana';

  @override
  String get sectionThisWeek => 'Esta semana';

  @override
  String get sectionLater => 'Más adelante';

  @override
  String get sectionNoDate => 'Sin fecha';

  @override
  String sectionCompleted(int count) {
    return 'Completadas ($count)';
  }

  @override
  String get taskNew => 'Nueva tarea';

  @override
  String get taskEdit => 'Editar tarea';

  @override
  String get taskTitleLabel => '¿Qué tienes que hacer?';

  @override
  String get taskTitleRequired => 'Escribe un título';

  @override
  String get taskNotesLabel => 'Notas (opcional)';

  @override
  String get taskCategoryLabel => 'Tipo';

  @override
  String get taskDateLabel => 'Fecha';

  @override
  String get taskNoDate => 'Sin fecha';

  @override
  String get taskTimeLabel => 'Hora';

  @override
  String get taskAllDay => 'Todo el día';

  @override
  String get taskRemind => 'Recordarme';

  @override
  String get taskRemindAllDayHint =>
      'Recibirás un recordatorio a las 09:00 ese día.';

  @override
  String get taskRemindNeedsDate =>
      'Elige una fecha para recibir un recordatorio.';

  @override
  String get taskRepeatLabel => 'Repetir';

  @override
  String get taskClearDate => 'Quitar fecha';

  @override
  String get taskClearTime => 'Quitar hora';

  @override
  String get taskCompleted => 'Tarea completada';

  @override
  String taskRescheduled(String date) {
    return 'Hecho. Próxima vez: $date';
  }

  @override
  String get taskDeleted => 'Tarea eliminada';

  @override
  String get taskMarkDone => 'Marcar como hecha';

  @override
  String get taskMarkNotDone => 'Marcar como no hecha';

  @override
  String get taskOverdue => 'Atrasada';

  @override
  String get taskRepeats => 'Se repite';

  @override
  String get taskSnoozed => 'Aplazada 10 minutos';

  @override
  String get taskNotFound => 'Esta tarea ya no existe.';

  @override
  String get confirmDeleteTitle => '¿Eliminar?';

  @override
  String confirmDeleteItem(String name) {
    return '¿Eliminar \"$name\"?';
  }

  @override
  String get reminderPermissionDenied =>
      'Las notificaciones están desactivadas, así que los recordatorios no aparecerán. Puedes activarlas en los ajustes de tu teléfono.';

  @override
  String get catGeneral => 'General';

  @override
  String get catStudy => 'Deberes';

  @override
  String get catExam => 'Examen';

  @override
  String get catHome => 'Hogar';

  @override
  String get catAppointment => 'Cita';

  @override
  String get catMedicine => 'Medicina';

  @override
  String get catDocument => 'Documento';

  @override
  String get catSubscription => 'Suscripción';

  @override
  String get catBill => 'Factura';

  @override
  String get repeatNone => 'No se repite';

  @override
  String get repeatDaily => 'Cada día';

  @override
  String get repeatWeekly => 'Cada semana';

  @override
  String get repeatMonthly => 'Cada mes';

  @override
  String get repeatYearly => 'Cada año';

  @override
  String get notifChannelName => 'Recordatorios';

  @override
  String get notifChannelDescription =>
      'Recordatorios de tareas, medicinas y citas';

  @override
  String get notifSnooze => 'Aplazar 10 min';

  @override
  String get notifDone => 'Hecho';

  @override
  String get listsTitle => 'Listas de la compra';

  @override
  String get listsEmptyTitle => 'Todavía no hay listas';

  @override
  String get listsEmptyBody =>
      'Crea una lista para la compra, material escolar o cualquier otra cosa.';

  @override
  String get listNew => 'Nueva lista';

  @override
  String get listNameLabel => 'Nombre de la lista';

  @override
  String get listNameRequired => 'Escribe un nombre';

  @override
  String listItemsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count artículos pendientes',
      one: '1 artículo pendiente',
      zero: 'Todo listo',
    );
    return '$_temp0';
  }

  @override
  String get listDeleted => 'Lista eliminada';

  @override
  String get listEmptyItems => 'Tu lista está esperando su primer artículo.';

  @override
  String get itemAddHint => 'Añade un artículo';

  @override
  String get itemAdd => 'Añadir artículo';

  @override
  String get itemEdit => 'Editar artículo';

  @override
  String get itemNameLabel => 'Artículo';

  @override
  String get itemQuantityLabel => 'Cantidad (opcional)';

  @override
  String get itemRemoved => 'Artículo eliminado';

  @override
  String get clearChecked => 'Borrar marcados';

  @override
  String get clearedChecked => 'Artículos marcados borrados';

  @override
  String get listOptions => 'Opciones de la lista';

  @override
  String get receiptsTitle => 'Recibos';

  @override
  String get receiptsEmptyTitle => 'Todavía no hay recibos';

  @override
  String get receiptsEmptyBody =>
      'Guarda los recibos para controlar tus gastos y tener prueba de compra para las garantías.';

  @override
  String get receiptNew => 'Nuevo recibo';

  @override
  String get receiptEdit => 'Editar recibo';

  @override
  String get receiptMerchantLabel => 'Tienda o comercio';

  @override
  String get receiptMerchantRequired => 'Indica dónde lo compraste';

  @override
  String get receiptAmountLabel => 'Importe';

  @override
  String receiptAmountInvalid(String example) {
    return 'Escribe un importe como $example';
  }

  @override
  String get receiptCurrencyLabel => 'Moneda';

  @override
  String get receiptDateLabel => 'Fecha de compra';

  @override
  String get receiptCategoryLabel => 'Categoría';

  @override
  String get receiptNoteLabel => 'Nota (opcional)';

  @override
  String get receiptWarrantyLabel => 'Garantía hasta';

  @override
  String get receiptNoWarranty => 'Sin garantía';

  @override
  String receiptPhoto(String merchant) {
    return 'Foto del recibo de $merchant';
  }

  @override
  String get receiptDeleted => 'Recibo eliminado';

  @override
  String get receiptThisMonth => 'Este mes';

  @override
  String get receiptSearchHint => 'Buscar recibos';

  @override
  String get receiptNoResults =>
      'No hay recibos que coincidan con tu búsqueda.';

  @override
  String receiptWarrantyUntil(String date) {
    return 'Garantía hasta $date';
  }

  @override
  String get receiptWarrantyExpired => 'Garantía caducada';

  @override
  String get rcGroceries => 'Alimentación';

  @override
  String get rcHousehold => 'Hogar';

  @override
  String get rcElectronics => 'Electrónica';

  @override
  String get rcClothing => 'Ropa';

  @override
  String get rcHealth => 'Salud';

  @override
  String get rcTransport => 'Transporte';

  @override
  String get rcEatingOut => 'Restaurantes';

  @override
  String get rcSchool => 'Colegio';

  @override
  String get rcOther => 'Otros';

  @override
  String get moreTitle => 'Más';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsName => 'Tu nombre';

  @override
  String get settingsNameNotSet => 'Sin definir';

  @override
  String get settingsMode => 'Modo';

  @override
  String get settingsCurrency => 'Moneda predeterminada';

  @override
  String get settingsAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Igual que el teléfono';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsAccessibility => 'Accesibilidad';

  @override
  String get settingsLargeText => 'Texto más grande';

  @override
  String get settingsLargeTextDesc =>
      'Hace que todo el texto y los botones sean más grandes.';

  @override
  String get settingsHighContrast => 'Alto contraste';

  @override
  String get settingsHighContrastDesc =>
      'Colores más intensos y fáciles de leer.';

  @override
  String get settingsConfirmDelete => 'Preguntar antes de eliminar';

  @override
  String get settingsConfirmDeleteDesc =>
      'Muestra una confirmación antes de eliminar algo.';

  @override
  String get settingsSafety => 'Seguridad';

  @override
  String get settingsEmergency => 'Contacto de emergencia';

  @override
  String get emergencyNameLabel => 'Nombre';

  @override
  String get emergencyPhoneLabel => 'Número de teléfono';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get aboutBody =>
      'Todo se guarda en este dispositivo. Sin cuenta, sin anuncios, sin seguimiento.';

  @override
  String get aboutFormats =>
      'Las fechas usan el orden día-mes-año y las semanas empiezan en lunes.';

  @override
  String get modeStudent => 'Estudiante';

  @override
  String get modeStudentDesc =>
      'Deberes, exámenes, listas escolares y gastos sencillos.';

  @override
  String get modeEveryday => 'Cotidiano';

  @override
  String get modeEverydayDesc =>
      'Recibos, tareas del hogar, facturas, suscripciones y compra.';

  @override
  String get modeSimple => 'Sencillo';

  @override
  String get modeSimpleDesc =>
      'Texto y botones más grandes, recordatorios de medicinas y citas, contacto de emergencia.';

  @override
  String get onbWelcomeTitle => 'Bienvenido a KeepAll';

  @override
  String get onbWelcomeBody =>
      'Tus cosas de cada día, todas en un solo lugar tranquilo.';

  @override
  String get onbNext => 'Siguiente';

  @override
  String get onbBack => 'Atrás';

  @override
  String get onbStart => 'Empezar';

  @override
  String get onbModeTitle => '¿Cómo vas a usar KeepAll?';

  @override
  String get onbModeBody => 'Puedes cambiarlo cuando quieras en Más.';

  @override
  String get onbNameTitle => '¿Cómo te llamamos?';

  @override
  String get onbNameHint => 'Tu nombre (opcional)';

  @override
  String get onbCurrencyTitle => '¿Qué moneda usas?';

  @override
  String onbStep(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get navSpending => 'Gastos';

  @override
  String get spendingTitle => 'Gastos';

  @override
  String get photoAdd => 'Añadir foto';

  @override
  String get photoTake => 'Hacer foto';

  @override
  String get photoChoose => 'Elegir de la galería';

  @override
  String get photoRemove => 'Quitar foto';

  @override
  String get photoError =>
      'No se ha podido añadir la foto. Inténtalo de nuevo.';

  @override
  String get homeDocuments => 'Documentos';

  @override
  String homeDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
      zero: 'Ninguno guardado',
    );
    return '$_temp0';
  }

  @override
  String homeDocsExpiring(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count caducan pronto',
      one: '1 caduca pronto',
    );
    return '$_temp0';
  }

  @override
  String get docsTitle => 'Documentos';

  @override
  String get docsEmptyTitle => 'Todavía no hay documentos';

  @override
  String get docsEmptyBody =>
      'Guarda tu pasaporte, DNI, seguro y más. KeepAll te avisa antes de que caduquen.';

  @override
  String get docNew => 'Nuevo documento';

  @override
  String get docEdit => 'Editar documento';

  @override
  String get docTypeLabel => 'Tipo';

  @override
  String get docTitleLabel => 'Nombre';

  @override
  String get docNumberLabel => 'Número de documento (opcional)';

  @override
  String get docExpiryLabel => 'Caduca el';

  @override
  String get docNoExpiry => 'Sin fecha de caducidad';

  @override
  String get docExpired => 'Caducado';

  @override
  String docExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Caduca en $days días',
      one: 'Caduca mañana',
      zero: 'Caduca hoy',
    );
    return '$_temp0';
  }

  @override
  String docValidUntil(String date) {
    return 'Válido hasta $date';
  }

  @override
  String docExpiresOn(String date) {
    return 'Caduca el $date';
  }

  @override
  String get docRemindLabel => 'Recordatorio';

  @override
  String get docRemindNone => 'Sin recordatorio';

  @override
  String docRemindBefore(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días antes',
      one: '1 día antes',
    );
    return '$_temp0';
  }

  @override
  String get docRemindNeedsDate =>
      'Añade una fecha de caducidad para recibir un recordatorio.';

  @override
  String docPhoto(String title) {
    return 'Foto de $title';
  }

  @override
  String get docDeleted => 'Documento eliminado';

  @override
  String get docTypePassport => 'Pasaporte';

  @override
  String get docTypeIdCard => 'DNI';

  @override
  String get docTypeDrivingLicence => 'Carné de conducir';

  @override
  String get docTypeInsurance => 'Seguro';

  @override
  String get docTypeVehicle => 'Coche / vehículo';

  @override
  String get docTypeHealth => 'Tarjeta sanitaria';

  @override
  String get docTypeContract => 'Contrato';

  @override
  String get docTypeWarranty => 'Garantía';

  @override
  String get docTypeOther => 'Otro';

  @override
  String get moreOrganise => 'Organizar';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Igual que el teléfono';

  @override
  String get listShare => 'Compartir lista';

  @override
  String get listCopied => 'Lista copiada al portapapeles';

  @override
  String get backupTitle => 'Copia de seguridad';

  @override
  String get backupCreate => 'Crear copia de seguridad';

  @override
  String get backupCreateDesc =>
      'Guarda todos tus datos y fotos en un archivo.';

  @override
  String get backupRestore => 'Restaurar copia de seguridad';

  @override
  String get backupRestoreDesc =>
      'Sustituye todo por un archivo de copia de seguridad.';

  @override
  String get backupCreated => 'Copia de seguridad guardada';

  @override
  String get backupFailed => 'Algo ha ido mal. Inténtalo de nuevo.';

  @override
  String get backupInvalid =>
      'Este archivo no es una copia de seguridad de KeepAll.';

  @override
  String get backupTooNew =>
      'Esta copia de seguridad se hizo con una versión más reciente de KeepAll. Actualiza la app primero.';

  @override
  String get backupRestoreConfirmTitle => '¿Restaurar copia de seguridad?';

  @override
  String backupContains(int tasks, int lists, int receipts, int documents) {
    return 'Tareas: $tasks\nListas: $lists\nRecibos: $receipts\nDocumentos: $documents';
  }

  @override
  String get backupRestoreWarning =>
      'Todo lo que hay ahora en la app se sustituirá.';

  @override
  String get backupRestoreAction => 'Restaurar';

  @override
  String get backupRestored => 'Copia de seguridad restaurada';

  @override
  String get modeStudentShort => 'Colegio, exámenes y dinero';

  @override
  String get modeEverydayShort => 'Hogar y vida diaria';

  @override
  String get modeSimpleShort => 'Más grande y más fácil';

  @override
  String get homeYourDay => 'Tu día';

  @override
  String homeYourDayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asuntos pendientes',
      one: '1 asunto pendiente',
      zero: 'Nada pendiente',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Ver';

  @override
  String receiptMonthSpending(String month) {
    return 'Gastos de $month';
  }

  @override
  String receiptCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recibos',
      one: '1 recibo',
      zero: 'Ningún recibo',
    );
    return '$_temp0';
  }

  @override
  String get docSoon => 'Caduca pronto';

  @override
  String get tasksAllDoneBody => 'Disfruta del resto del día.';

  @override
  String get settingsPalette => 'Tema de color';

  @override
  String get paletteDeepOcean => 'Océano profundo';

  @override
  String get paletteMatchaHoney => 'Matcha y miel';

  @override
  String get paletteSunsetPop => 'Atardecer';

  @override
  String get paletteMidnightCandy => 'Caramelo de medianoche';

  @override
  String get paletteSoftPastel => 'Pastel suave';

  @override
  String get paletteAlwaysDark => 'Siempre oscuro';

  @override
  String get paletteCreamCocoa => 'Crema y cacao';

  @override
  String get paletteNordicSnow => 'Nieve nórdica';

  @override
  String get paletteSkySunshine => 'Cielo y sol';

  @override
  String get paletteLavenderNight => 'Noche de lavanda';

  @override
  String get paletteLemonCharcoal => 'Limón y carbón';

  @override
  String get currencySearchHint => 'Busca una moneda o un país';

  @override
  String get currencyPopular => 'Populares';

  @override
  String get currencyAll => 'Todas las monedas';

  @override
  String get currencyNoResults => 'No se encontró ninguna moneda';

  @override
  String get currencyMore => 'Más monedas';

  @override
  String get receiptDateFuture => 'La fecha de compra no puede ser futura.';

  @override
  String get homeUpcomingTasks => 'Próximas tareas';

  @override
  String get taskPastDateTime =>
      'La fecha y la hora no pueden ser en el pasado.';

  @override
  String get reminderOnTimeTitle => 'Permitir recordatorios puntuales';

  @override
  String get reminderOnTimeBody =>
      'Android puede retrasar los recordatorios mientras el móvil está en reposo. Para recibirlos a la hora exacta, aunque KeepAll esté cerrada, activa «Alarmas y recordatorios» para KeepAll en la siguiente pantalla.';

  @override
  String get reminderOnTimeAllow => 'Permitir';

  @override
  String get reminderOnTimeLater => 'Ahora no';
}
