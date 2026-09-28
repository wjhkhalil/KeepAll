import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/money.dart';
import '../state/settings.dart';
import 'currency_picker.dart';
import 'design.dart';
import 'labels.dart';

/// First launch: welcome → pick a mode → name → currency.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _steps = 4;
  int _step = 0;
  UserMode _mode = UserMode.everyday;
  // Best guess from the phone's region (de_CH → CHF, en_US → USD).
  Currency _currency = currencyForRegion(WidgetsBinding.instance.platformDispatcher.locale.countryCode);
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_step < _steps - 1) {
      setState(() => _step++);
      return;
    }
    await context.read<Settings>().completeOnboarding(mode: _mode, name: _name.text, currency: _currency);
  }

  Widget _stepBody(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final title = theme.textTheme.headlineSmall;

    switch (_step) {
      case 0:
        return Column(
          key: const ValueKey(0),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const AppLogo(size: 140),
            const SizedBox(height: 32),
            Semantics(
              header: true,
              child: Text(l.onbWelcomeTitle, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 12),
            Text(
              l.onbWelcomeBody,
              style: theme.textTheme.titleMedium?.copyWith(color: context.colors.textMuted, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Language first, so the rest of set-up is readable.
            DropdownButtonFormField<String>(
              borderRadius: BorderRadius.circular(18),
              initialValue: Localizations.localeOf(context).languageCode,
              decoration: InputDecoration(labelText: l.settingsLanguage, prefixIcon: const Icon(Icons.language_rounded)),
              items: [
                for (final code in supportedLanguages) DropdownMenuItem(value: code, child: Text(languageName(code))),
              ],
              onChanged: (code) => context.read<Settings>().setLanguage(code),
            ),
          ],
        );
      case 1:
        return Column(
          key: const ValueKey(1),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text(l.onbModeTitle, style: title)),
            const SizedBox(height: 8),
            Text(l.onbModeBody, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 16),
            for (final m in UserMode.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ModeCard(mode: m, selected: _mode == m, onTap: () => setState(() => _mode = m)),
              ),
          ],
        );
      case 2:
        return Column(
          key: const ValueKey(2),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text(l.onbNameTitle, style: title)),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l.onbNameHint),
              onSubmitted: (_) => _next(),
            ),
          ],
        );
      default:
        return Column(
          key: const ValueKey(3),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text(l.onbCurrencyTitle, style: title)),
            const SizedBox(height: 8),
            RadioGroup<Currency>(
              groupValue: _currency,
              onChanged: (c) => setState(() => _currency = c ?? _currency),
              child: SoftCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    for (final c in [
                      if (!Currency.popular.contains(_currency)) _currency,
                      ...Currency.popular,
                    ])
                      RadioListTile<Currency>(
                        value: c,
                        title: Text(currencyName(l, c)),
                        secondary: Text(c.code, style: theme.textTheme.titleMedium),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final c = await pickCurrency(context, selected: _currency);
                if (c != null) setState(() => _currency = c);
              },
              icon: const Icon(Icons.public_rounded),
              label: Text(l.currencyMore),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    // Preview Simple mode's larger text as soon as it is picked.
    final previewScale = _mode == UserMode.simple && _step > 0 ? 1.3 : 1.0;
    final media = MediaQuery.of(context);

    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(media.textScaler.scale(1) * previewScale)),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Semantics(
                  label: l.onbStep(_step + 1, _steps),
                  child: ExcludeSemantics(
                    child: LinearProgressIndicator(
                      value: (_step + 1) / _steps,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _stepBody(context),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    if (_step > 0)
                      TextButton(onPressed: () => setState(() => _step--), child: Text(l.onbBack)),
                    const Spacer(),
                    FilledButton(
                      onPressed: _next,
                      child: Text(_step == 0 || _step == _steps - 1 ? l.onbStart : l.onbNext),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({required this.mode, required this.selected, required this.onTap});

  final UserMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final theme = Theme.of(context);
    final (emoji, tint) = switch (mode) {
      UserMode.student => ('📚', c.lavender),
      UserMode.everyday => ('🏡', c.peach),
      UserMode.simple => ('🌿', c.sage),
    };
    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      button: true,
      label: '${modeLabel(l, mode)}. ${modeDescription(l, mode)}',
      excludeSemantics: true,
      onTap: onTap,
      child: Pressable(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            // Selected: soft pastel fill + outline + check.
            color: selected ? (c.highContrast ? c.card : tint) : c.card,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(color: selected ? c.primary : c.border, width: selected ? 2.5 : 1),
            boxShadow: c.highContrast ? null : [BoxShadow(color: c.shadow, blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: BorderRadius.circular(cardRadius),
              onTap: onTap,
              child: Padding(
                // The border is drawn inside the box, so make up for the
                // thinner unselected border to keep all cards the same size.
                padding: EdgeInsets.all(selected ? 16 : 17.5),
                child: Row(
                  children: [
                    TinyIllustration(emoji, color: selected ? c.card : tint, size: 56),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(modeLabel(l, mode),
                              style: theme.textTheme.titleLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          // Two reserved lines keep all three cards the same height.
                          FixedLinesText(
                            modeShort(l, mode),
                            lines: 2,
                            center: true,
                            style: theme.textTheme.bodyLarge?.copyWith(color: c.textMuted),
                          ),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: selected ? 1 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.check_circle_rounded, color: c.primary, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
