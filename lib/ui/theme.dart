import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/settings.dart';
import 'design.dart';

/// Status bar and Android navigation bar colours for [c]: transparent bars
/// with icons that read on the page background, so screens without an app
/// bar (Home) match the chosen palette too.
SystemUiOverlayStyle systemOverlayStyleFor(AppColors c) {
  final darkPage = ThemeData.estimateBrightnessForColor(c.background) == Brightness.dark;
  final icons = darkPage ? Brightness.light : Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: icons,
    statusBarBrightness: darkPage ? Brightness.dark : Brightness.light, // iOS
    systemNavigationBarColor: c.background,
    systemNavigationBarIconBrightness: icons,
    systemNavigationBarDividerColor: c.background,
  );
}

ThemeData buildTheme({
  required Brightness brightness,
  required bool highContrast,
  required bool bigTargets,
  ColorPalette palette = ColorPalette.creamCocoa,
}) {
  if (paletteAlwaysDark(palette)) brightness = Brightness.dark;
  final c = highContrast ? AppColors.contrast(brightness) : AppColors.of(palette, brightness);

  final scheme = ColorScheme.fromSeed(seedColor: c.primary, brightness: brightness).copyWith(
    primary: c.primary,
    onPrimary: c.onPrimary,
    primaryContainer: c.sage,
    onPrimaryContainer: c.text,
    secondary: c.primary,
    onSecondary: c.onPrimary,
    secondaryContainer: c.sage,
    onSecondaryContainer: c.text,
    tertiaryContainer: c.butter,
    onTertiaryContainer: c.text,
    surface: c.background,
    onSurface: c.text,
    onSurfaceVariant: c.textMuted,
    surfaceContainerLowest: c.card,
    surfaceContainerLow: c.card,
    surfaceContainer: c.card,
    surfaceContainerHigh: c.card,
    surfaceContainerHighest: highContrast ? c.card : Color.alphaBlend(c.border.withValues(alpha: 0.5), c.card),
    surfaceDim: c.background,
    surfaceBright: c.card,
    // Nothing in the app should show the seed's derived hues: pin the rest of
    // the scheme to palette colours so every Material widget follows suit.
    surfaceTint: c.primary,
    tertiary: c.primary,
    onTertiary: c.onPrimary,
    inverseSurface: c.text,
    onInverseSurface: c.background,
    inversePrimary: Color.lerp(c.primary, c.background, 0.4)!,
    primaryFixed: c.sage,
    primaryFixedDim: c.sage,
    onPrimaryFixed: c.text,
    onPrimaryFixedVariant: c.text,
    secondaryFixed: c.sage,
    secondaryFixedDim: c.sage,
    onSecondaryFixed: c.text,
    onSecondaryFixedVariant: c.text,
    tertiaryFixed: c.butter,
    tertiaryFixedDim: c.butter,
    onTertiaryFixed: c.text,
    onTertiaryFixedVariant: c.text,
    outline: highContrast ? c.border : c.textMuted,
    outlineVariant: c.border,
    error: c.danger,
    onError: highContrast ? c.background : Colors.white,
    errorContainer: c.dangerTint,
    onErrorContainer: c.text,
  );

  // Snackbars and tooltips are "inverse" surfaces: text colour as the
  // background, page colour as the text, so they look right in every palette.
  final inverseBg = c.text;
  final inverseFg = c.background;
  final inverseAction = highContrast ? c.background : Color.lerp(c.primary, c.background, 0.35)!;

  // Build from the palette's scheme so every derived colour (dropdown menus
  // use canvasColor, plus hover/focus/highlight colours) follows the palette
  // instead of Flutter's default purple-pink.
  final base = ThemeData(colorScheme: scheme, useMaterial3: true, fontFamily: 'Nunito');
  // Include font sizes: component themes (app bar, list tiles, dialogs) use
  // these styles directly, before MaterialApp would add the sizes.
  final merged = Typography.englishLike2021.merge(base.textTheme).apply(bodyColor: c.text, displayColor: c.text);
  final text = merged.copyWith(
    headlineMedium: merged.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: c.text),
    headlineSmall: merged.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: c.text),
    titleLarge: merged.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: c.text),
    titleMedium: merged.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: c.text),
    titleSmall: merged.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: c.text),
    labelLarge: merged.labelLarge?.copyWith(fontWeight: FontWeight.w700),
  );

  final minTarget = bigTargets ? const Size(64, 56) : const Size(48, 48);
  final buttonPadding = bigTargets
      ? const EdgeInsets.symmetric(horizontal: 28, vertical: 18)
      : const EdgeInsets.symmetric(horizontal: 22, vertical: 14);
  final pillShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(18));
  final inputRadius = BorderRadius.circular(16);

  return base.copyWith(
    colorScheme: scheme,
    textTheme: text,
    extensions: [c],
    scaffoldBackgroundColor: c.background,
    canvasColor: c.card,
    cardColor: c.card,
    dividerColor: c.border,
    hintColor: c.textMuted,
    disabledColor: c.textMuted.withValues(alpha: 0.5),
    unselectedWidgetColor: c.textMuted,
    // Icons without an explicit colour (chevrons, form prefixes) use the
    // palette's text colour instead of Flutter's fixed black/white.
    iconTheme: IconThemeData(color: c.text),
    primaryIconTheme: IconThemeData(color: c.onPrimary),
    hoverColor: c.primary.withValues(alpha: 0.06),
    focusColor: c.primary.withValues(alpha: 0.12),
    highlightColor: c.primary.withValues(alpha: 0.10),
    splashColor: c.primary.withValues(alpha: 0.12),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(c.card),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(c.card),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    ),
    visualDensity: bigTargets ? VisualDensity.comfortable : VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    splashFactory: InkSparkle.splashFactory,
    appBarTheme: AppBarTheme(
      backgroundColor: c.background,
      surfaceTintColor: Colors.transparent,
      foregroundColor: c.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: text.headlineSmall,
      iconTheme: IconThemeData(color: c.text),
      actionsIconTheme: IconThemeData(color: c.text),
      systemOverlayStyle: systemOverlayStyleFor(c),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: c.card,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardRadius),
        side: BorderSide(color: c.border, width: highContrast ? 2 : 1),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: minTarget,
        padding: buttonPadding,
        shape: pillShape,
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        textStyle: text.labelLarge?.copyWith(fontSize: bigTargets ? 18 : 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: minTarget,
        padding: buttonPadding,
        shape: pillShape,
        foregroundColor: c.text,
        side: BorderSide(color: highContrast ? c.border : c.textMuted.withValues(alpha: 0.5), width: highContrast ? 2 : 1),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: minTarget, foregroundColor: c.primary, shape: pillShape),
    ),
    iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(minimumSize: minTarget)),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: c.primary,
      foregroundColor: c.onPrimary,
      elevation: highContrast ? 0 : 1,
      focusElevation: highContrast ? 0 : 1,
      hoverElevation: highContrast ? 0 : 2,
      highlightElevation: highContrast ? 0 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      extendedTextStyle: text.labelLarge?.copyWith(fontSize: 16),
      sizeConstraints: bigTargets ? const BoxConstraints.tightFor(width: 72, height: 72) : null,
      extendedSizeConstraints: BoxConstraints(minHeight: bigTargets ? 72 : 56),
    ),
    listTileTheme: ListTileThemeData(
      minVerticalPadding: bigTargets ? 14 : 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      iconColor: c.text,
      titleTextStyle: text.titleMedium,
      subtitleTextStyle: text.bodyMedium?.copyWith(color: c.textMuted),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.card,
      border: OutlineInputBorder(borderRadius: inputRadius, borderSide: BorderSide(color: c.border)),
      enabledBorder: OutlineInputBorder(
        borderRadius: inputRadius,
        borderSide: BorderSide(color: highContrast ? c.border : c.border, width: highContrast ? 2 : 1),
      ),
      focusedBorder: OutlineInputBorder(borderRadius: inputRadius, borderSide: BorderSide(color: c.primary, width: 2)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: highContrast ? c.border : c.border),
      backgroundColor: c.card,
      selectedColor: highContrast ? c.text : c.sage,
      labelStyle: text.labelLarge?.copyWith(color: c.text),
      secondaryLabelStyle: text.labelLarge?.copyWith(color: highContrast ? c.background : c.text),
      checkmarkColor: highContrast ? c.background : c.text,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: const CircleBorder(),
      side: BorderSide(color: c.textMuted, width: 2),
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : Colors.transparent),
      checkColor: WidgetStatePropertyAll(c.onPrimary),
      visualDensity: bigTargets ? const VisualDensity(horizontal: 1, vertical: 1) : null,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.onPrimary : c.textMuted),
      // Black & white mode: an "off" switch is an outlined empty track with a
      // black thumb, so it never becomes one solid black shape.
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? c.primary : (highContrast ? c.background : c.border),
      ),
      trackOutlineColor: highContrast ? WidgetStatePropertyAll(c.border) : null,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.primary,
      // Black & white mode has no tint, so the empty part of the bar is a
      // light grey (a shade of the text colour, not a palette colour).
      linearTrackColor: highContrast ? c.text.withValues(alpha: 0.2) : c.sage,
      linearMinHeight: 8,
      borderRadius: BorderRadius.circular(8),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: highContrast ? BorderSide(color: c.border, width: 2) : BorderSide.none,
      ),
      titleTextStyle: text.titleLarge,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      dragHandleColor: c.textMuted,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        side: highContrast ? BorderSide(color: c.border, width: 2) : BorderSide.none,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: c.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: inverseBg,
      contentTextStyle: text.bodyLarge?.copyWith(color: inverseFg),
      actionTextColor: inverseAction,
      closeIconColor: inverseFg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(color: inverseBg, borderRadius: BorderRadius.circular(10)),
      textStyle: text.bodyMedium?.copyWith(color: inverseFg),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: c.primary,
      selectionColor: c.primary.withValues(alpha: 0.35),
      selectionHandleColor: c.primary,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: c.card,
      surfaceTintColor: Colors.transparent,
      headerBackgroundColor: c.card,
      headerForegroundColor: c.text,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: highContrast ? BorderSide(color: c.border, width: 2) : BorderSide.none,
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: c.card,
      dialBackgroundColor: highContrast ? c.background : c.sage,
      dialHandColor: c.primary,
      hourMinuteColor: WidgetStateColor.resolveWith(
        (s) => s.contains(WidgetState.selected) ? (highContrast ? c.text : c.sage) : scheme.surfaceContainerHighest,
      ),
      hourMinuteTextColor: WidgetStateColor.resolveWith(
        (s) => s.contains(WidgetState.selected) && highContrast ? c.background : c.text,
      ),
      dayPeriodColor: WidgetStateColor.resolveWith(
        (s) => s.contains(WidgetState.selected) ? (highContrast ? c.text : c.sage) : c.card,
      ),
      dayPeriodTextColor: WidgetStateColor.resolveWith(
        (s) => s.contains(WidgetState.selected) && highContrast ? c.background : c.text,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: highContrast ? BorderSide(color: c.border, width: 2) : BorderSide.none,
      ),
    ),
    dividerTheme: DividerThemeData(color: c.border, space: 1),
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );
}
