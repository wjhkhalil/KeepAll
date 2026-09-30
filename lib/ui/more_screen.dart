import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../state/app_data.dart';
import '../state/settings.dart';
import 'backup_actions.dart';
import 'currency_picker.dart';
import 'design.dart';
import 'home_screen.dart';
import 'labels.dart';
import 'shell.dart';
import 'widgets.dart';

/// The owner's published privacy policy (required by Google Play).
const privacyPolicyUrl = 'https://www.freeprivacypolicy.com/live/4ce57630-abc0-4fd4-81dd-63c0603e1a5b';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key, required this.onOpen});

  /// Opens a section (documents, lists, receipts) as its own page or tab.
  final void Function(AppTab tab) onOpen;

  /// Opens the policy in the phone's browser rather than inside the app, so
  /// people can read it in a familiar place and come back with Back.
  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final ok = await launchUrl(Uri.parse(privacyPolicyUrl), mode: LaunchMode.externalApplication)
        .catchError((_) => false);
    if (!ok && context.mounted) showMessage(context, context.l10n.linkFailed);
  }

  Future<void> _editName(BuildContext context, Settings settings) async {
    final l = context.l10n;
    final values = await showTextFieldsDialog(
      context,
      title: l.settingsName,
      fields: [
        DialogField(label: l.onbNameHint, initial: settings.name, capitalization: TextCapitalization.words),
      ],
    );
    if (values != null) await settings.setName(values.first);
  }

  Future<void> _editEmergency(BuildContext context, Settings settings) async {
    final l = context.l10n;
    final values = await showTextFieldsDialog(
      context,
      title: l.settingsEmergency,
      fields: [
        DialogField(
          label: l.emergencyNameLabel,
          initial: settings.emergencyName,
          capitalization: TextCapitalization.words,
        ),
        DialogField(
          label: l.emergencyPhoneLabel,
          initial: settings.emergencyPhone,
          hint: '+44 20 7946 0000',
          keyboardType: TextInputType.phone,
          capitalization: TextCapitalization.none,
        ),
      ],
    );
    if (values != null) await settings.setEmergencyContact(values[0], values[1]);
  }

  Future<T?> _choose<T>(BuildContext context, String title, List<T> options, T current, String Function(T) label,
      {String Function(T)? description}) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(title),
        children: [
          RadioGroup<T>(
            groupValue: current,
            onChanged: (v) => Navigator.pop(ctx, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final o in options)
                  RadioListTile<T>(
                    value: o,
                    title: Text(label(o)),
                    subtitle: description == null ? null : Text(description(o)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A section: small heading + its rows grouped in one rounded card.
  List<Widget> _group(BuildContext context, String title, List<Widget> rows) {
    final c = context.colors;
    return [
      Semantics(
        header: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: c.textMuted, letterSpacing: 1.1),
          ),
        ),
      ),
      SoftCard(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            for (var i = 0; i < rows.length; i++) ...[
              if (i > 0) Divider(indent: 70, endIndent: 16, color: c.border),
              rows[i],
            ],
          ],
        ),
      ),
    ];
  }

  /// Bottom sheet listing the colour themes, each with its colour dots.
  /// Picking one repaints the app straight away.
  Future<void> _choosePalette(BuildContext context, Settings settings) async {
    final l = context.l10n;
    final picked = await showModalBottomSheet<ColorPalette>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(l.settingsPalette, style: Theme.of(ctx).textTheme.titleLarge),
                ),
              ),
              for (final p in ColorPalette.values)
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  minTileHeight: 72, // same height with or without the "always dark" note
                  leading: _PaletteDots(colors: paletteSwatch(p)),
                  title: Text(paletteLabel(l, p)),
                  subtitle: paletteAlwaysDark(p) ? Text(l.paletteAlwaysDark) : null,
                  trailing: p == settings.palette
                      ? Icon(Icons.check_circle_rounded, color: Theme.of(ctx).colorScheme.primary)
                      : null,
                  selected: p == settings.palette,
                  onTap: () => Navigator.pop(ctx, p),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) await settings.setPalette(picked);
  }

  String _themeLabel(BuildContext context, ThemeMode m) => switch (m) {
    ThemeMode.system => context.l10n.themeSystem,
    ThemeMode.light => context.l10n.themeLight,
    ThemeMode.dark => context.l10n.themeDark,
  };

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = context.watch<Settings>();
    final data = context.watch<AppData>();
    final inBar = tabsFor(s.mode);
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l.moreTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          ..._group(context, l.moreOrganise, [
              ListTile(
                leading: IconBubble(icon: Icons.folder_rounded, color: c.blue, size: 38),
                title: Text(l.docsTitle),
                subtitle: Text(l.homeDocsCount(data.documents.length)),
                trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
                onTap: () => onOpen(AppTab.documents),
              ),
              if (!inBar.contains(AppTab.lists))
                ListTile(
                  leading: IconBubble(icon: Icons.shopping_cart_rounded, color: c.blue, size: 38),
                  title: Text(l.listsTitle),
                  subtitle: Text(l.homeShoppingCount(data.shoppingItemsRemaining)),
                  trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
                  onTap: () => onOpen(AppTab.lists),
                ),
              if (!inBar.contains(AppTab.receipts))
                ListTile(
                  leading: IconBubble(icon: Icons.receipt_long_rounded, color: c.blue, size: 38),
                  title: Text(l.receiptsTitle),
                  subtitle: Text(l.homeReceiptsCount(data.receipts.length)),
                  trailing: Icon(Icons.chevron_right_rounded, color: c.textMuted),
                  onTap: () => onOpen(AppTab.receipts),
                ),
          ]),
          ..._group(context, l.settingsGeneral, [
              ListTile(
                leading: IconBubble(icon: Icons.person_outline, color: c.sage, size: 38),
                title: Text(l.settingsName),
                subtitle: Text(s.name.isEmpty ? l.settingsNameNotSet : s.name),
                onTap: () => _editName(context, s),
              ),
              ListTile(
                leading: IconBubble(icon: modeIcon(s.mode), color: c.sage, size: 38),
                title: Text(l.settingsMode),
                subtitle: Text(modeLabel(l, s.mode)),
                onTap: () async {
                  final m = await _choose(context, l.settingsMode, UserMode.values, s.mode, (m) => modeLabel(l, m),
                      description: (m) => modeDescription(l, m));
                  if (m != null && m != s.mode) await s.setMode(m);
                },
              ),
              ListTile(
                leading: IconBubble(icon: Icons.payments_rounded, color: c.sage, size: 38),
                title: Text(l.settingsCurrency),
                subtitle: Text('${s.currency.code} · ${currencyName(l, s.currency)}'),
                onTap: () async {
                  final c = await pickCurrency(context, selected: s.currency);
                  if (c != null) await s.setCurrency(c);
                },
              ),
              ListTile(
                leading: IconBubble(icon: Icons.language, color: c.sage, size: 38),
                title: Text(l.settingsLanguage),
                subtitle: Text(s.language == null ? l.languageSystem : languageName(s.language!)),
                onTap: () async {
                  // '' stands for "match phone" because null means "cancelled".
                  final choice = await _choose<String>(
                    context,
                    l.settingsLanguage,
                    ['', ...supportedLanguages],
                    s.language ?? '',
                    (c) => c.isEmpty ? l.languageSystem : languageName(c),
                  );
                  if (choice != null) await s.setLanguage(choice.isEmpty ? null : choice);
                },
              ),
          ]),
          ..._group(context, l.settingsAppearance, [
              ListTile(
                leading: IconBubble(icon: Icons.palette_rounded, color: c.peach, size: 38),
                title: Text(l.settingsPalette),
                subtitle: Text(paletteLabel(l, s.palette)),
                // In black & white mode the palette is not applied, so its
                // colour dots would be the only coloured thing on the screen.
                trailing: c.highContrast
                    ? null
                    : ExcludeSemantics(child: _PaletteDots(colors: paletteSwatch(s.palette), size: 16)),
                onTap: () => _choosePalette(context, s),
              ),
              ListTile(
                leading: IconBubble(icon: Icons.dark_mode_rounded, color: c.lavender, size: 38),
                title: Text(l.settingsTheme),
                subtitle: Text(_themeLabel(context, s.themeMode)),
                onTap: () async {
                  final t = await _choose(context, l.settingsTheme, ThemeMode.values, s.themeMode,
                      (t) => _themeLabel(context, t));
                  if (t != null) await s.setThemeMode(t);
                },
              ),
          ]),
          ..._group(context, l.settingsAccessibility, [
              SwitchListTile(
                secondary: IconBubble(icon: Icons.text_increase, color: c.peach, size: 38),
                title: Text(l.settingsLargeText),
                subtitle: Text(l.settingsLargeTextDesc),
                value: s.largeText,
                onChanged: s.setLargeText,
              ),
              SwitchListTile(
                secondary: IconBubble(icon: Icons.contrast, color: c.peach, size: 38),
                title: Text(l.settingsHighContrast),
                subtitle: Text(l.settingsHighContrastDesc),
                value: s.highContrast,
                onChanged: s.setHighContrast,
              ),
              SwitchListTile(
                secondary: IconBubble(icon: Icons.help_outline, color: c.peach, size: 38),
                title: Text(l.settingsConfirmDelete),
                subtitle: Text(l.settingsConfirmDeleteDesc),
                value: s.confirmDelete,
                onChanged: s.setConfirmDelete,
              ),
          ]),
          ..._group(context, l.settingsSafety, [
              ListTile(
                leading: IconBubble(icon: Icons.sos_rounded, color: c.dangerTint, size: 38),
                title: Text(l.settingsEmergency),
                subtitle: Text(
                  s.hasEmergencyContact
                      ? [s.emergencyName, s.emergencyPhone].where((e) => e.isNotEmpty).join(' · ')
                      : l.settingsNameNotSet,
                ),
                onTap: () => _editEmergency(context, s),
              ),
          ]),
          ..._group(context, l.backupTitle, [
              ListTile(
                leading: IconBubble(icon: Icons.backup_rounded, color: c.butter, size: 38),
                title: Text(l.backupCreate),
                subtitle: Text(l.backupCreateDesc),
                onTap: () => createBackup(context),
              ),
              ListTile(
                leading: IconBubble(icon: Icons.settings_backup_restore, color: c.butter, size: 38),
                title: Text(l.backupRestore),
                subtitle: Text(l.backupRestoreDesc),
                onTap: () => restoreBackup(context),
              ),
          ]),
          ..._group(context, l.settingsAbout, [
              ListTile(
                leading: const AppLogo(size: 44),
                title: Text(l.appTitle),
                subtitle: Text('${l.aboutBody}\n${l.aboutFormats}'),
                isThreeLine: true,
              ),
              ListTile(
                key: const Key('privacy-policy'),
                leading: IconBubble(icon: Icons.privacy_tip_rounded, color: c.sage, size: 38),
                title: Text(l.privacyPolicy),
                subtitle: Text(l.privacyPolicyDesc),
                trailing: const Icon(Icons.open_in_new_rounded),
                onTap: () => _openPrivacyPolicy(context),
              ),
          ]),
        ],
      ),
    );
  }
}

/// Three overlapping colour dots previewing a palette.
class _PaletteDots extends StatelessWidget {
  const _PaletteDots({required this.colors, this.size = 22});

  final List<Color> colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ring = context.colors.card;
    return ExcludeSemantics(
      child: SizedBox(
        width: size + (colors.length - 1) * size * 0.65,
        height: size,
        child: Stack(
          children: [
            for (var i = 0; i < colors.length; i++)
              Positioned(
                left: i * size * 0.65,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: colors[i],
                    shape: BoxShape.circle,
                    border: Border.all(color: ring, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
