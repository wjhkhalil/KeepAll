import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/settings.dart';

/// LifeKeeper's look: a clean neutral base (≈70%), soft pastel tints (≈20%) and a
/// few stronger accents (≈10%). "Soft Pastel Planner" + "Modern Soft Nature".
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.card,
    required this.primary,
    required this.onPrimary,
    required this.text,
    required this.textMuted,
    required this.border,
    required this.lavender,
    required this.peach,
    required this.sage,
    required this.butter,
    required this.blue,
    required this.clay,
    required this.danger,
    required this.dangerTint,
    required this.warning,
    required this.warningTint,
    required this.success,
    required this.shadow,
    required this.categories,
    required this.highContrast,
    this.inks = const {},
  });

  final Color background;
  final Color card;
  final Color primary;
  final Color onPrimary;
  final Color text;
  final Color textMuted;
  final Color border;
  final Color lavender;
  final Color peach;
  final Color sage;
  final Color butter;
  final Color blue;
  final Color clay;

  /// Strong accents: text/dots on top of the matching tint.
  final Color danger;
  final Color dangerTint;
  final Color warning;
  final Color warningTint;
  final Color success;
  final Color shadow;
  final Map<TaskCategory, Color> categories;
  final bool highContrast;

  /// Strong colour behind each tint in the bold palettes. Icon bubbles use it
  /// as a solid fill; empty for the pastel and high-contrast looks.
  final Map<Color, Color> inks;

  Color category(TaskCategory c) => categories[c]!;

  /// Colours for [palette]. The dark-by-design ones are always dark.
  static AppColors of(ColorPalette palette, Brightness brightness) {
    if (palette == ColorPalette.softPastel) return brightness == Brightness.dark ? dark : light;
    final spec = _palettes[palette]!;
    return spec.alwaysDark || brightness == Brightness.dark ? spec.dark() : spec.light();
  }

  static const light = AppColors(
    background: Color(0xFFFAF8F2),
    card: Color(0xFFFFFFFF),
    primary: Color(0xFF5E6E6B),
    onPrimary: Color(0xFFFFFFFF),
    text: Color(0xFF303633),
    textMuted: Color(0xFF66706C),
    border: Color(0xFFE8E4DA),
    lavender: Color(0xFFDCD7F7),
    peach: Color(0xFFF7D8C8),
    sage: Color(0xFFD8E8DD),
    butter: Color(0xFFF6E9B8),
    blue: Color(0xFFD7E7F5),
    clay: Color(0xFFD9B8A8),
    danger: Color(0xFFA23B3F),
    dangerTint: Color(0xFFF4D0D5),
    warning: Color(0xFF8A5B00),
    warningTint: Color(0xFFF6E9B8),
    success: Color(0xFF3F7A5A),
    shadow: Color(0x14303633),
    highContrast: false,
    categories: {
      TaskCategory.general: Color(0xFFDDE3E1),
      TaskCategory.study: Color(0xFFD8D2F0),
      TaskCategory.exam: Color(0xFFF4D0D5),
      TaskCategory.home: Color(0xFFD8E8D8),
      TaskCategory.appointment: Color(0xFFD5E5F2),
      TaskCategory.medicine: Color(0xFFF3D7C8),
      TaskCategory.document: Color(0xFFE6DCCB),
      TaskCategory.subscription: Color(0xFFD8D4E8),
      TaskCategory.bill: Color(0xFFF2E3B7),
    },
  );

  static const dark = AppColors(
    background: Color(0xFF171918),
    card: Color(0xFF222624),
    primary: Color(0xFFB8C8C2),
    onPrimary: Color(0xFF1B2220),
    text: Color(0xFFF4F4F0),
    textMuted: Color(0xFFB4BAB6),
    border: Color(0xFF333836),
    lavender: Color(0xFF514B68),
    peach: Color(0xFF634A42),
    sage: Color(0xFF405248),
    butter: Color(0xFF625B3E),
    blue: Color(0xFF425466),
    clay: Color(0xFF6A5046),
    danger: Color(0xFFF2A7AC),
    dangerTint: Color(0xFF5A3439),
    warning: Color(0xFFF0CF7A),
    warningTint: Color(0xFF625B3E),
    success: Color(0xFF9CD3B1),
    shadow: Color(0x33000000),
    highContrast: false,
    categories: {
      TaskCategory.general: Color(0xFF3A403E),
      TaskCategory.study: Color(0xFF4B4663),
      TaskCategory.exam: Color(0xFF634550),
      TaskCategory.home: Color(0xFF405248),
      TaskCategory.appointment: Color(0xFF425466),
      TaskCategory.medicine: Color(0xFF634A42),
      TaskCategory.document: Color(0xFF574F42),
      TaskCategory.subscription: Color(0xFF4A4760),
      TaskCategory.bill: Color(0xFF625B3E),
    },
  );

  /// A separate accessible treatment: strictly black and white (white on
  /// black in dark mode), strong outlines, no pastels and no palette colours
  /// at all. Accents such as "primary", "danger" and "success" are the text
  /// colour, so buttons and pills are filled or outlined in black/white and
  /// meaning is carried by icons and text only.
  static AppColors contrast(Brightness b) {
    final dark = b == Brightness.dark;
    final bg = dark ? Colors.black : Colors.white;
    final fg = dark ? Colors.white : Colors.black;
    return AppColors(
      background: bg,
      card: bg,
      primary: fg,
      onPrimary: bg,
      text: fg,
      textMuted: fg,
      border: fg,
      lavender: bg,
      peach: bg,
      sage: bg,
      butter: bg,
      blue: bg,
      clay: bg,
      danger: fg,
      dangerTint: bg,
      warning: fg,
      warningTint: bg,
      success: fg,
      shadow: Colors.transparent,
      highContrast: true,
      categories: {for (final c in TaskCategory.values) c: bg},
    );
  }

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) => t < 0.5 || other == null ? this : other;
}

/// A bold palette: a main colour plus six strong hues. Tints, dark-mode
/// colours and category colours are all derived from these.
class _PaletteSpec {
  const _PaletteSpec({
    required this.primary,
    required this.purple,
    required this.pink,
    required this.green,
    required this.yellow,
    required this.blue,
    required this.orange,
    required this.background,
    required this.text,
    this.alwaysDark = false,
    this.card = Colors.white,
  });

  final Color primary, purple, pink, green, yellow, blue, orange;
  final Color background, text, card;
  final bool alwaysDark;

  static const _darkBase = Color(0xFF14141B);

  AppColors light() => _build(
    background: background,
    card: card,
    text: text,
    primary: primary,
    tint: (hue) => Color.lerp(Colors.white, hue, 0.24)!,
    ink: (hue) => hue,
    dark: false,
  );

  AppColors dark() {
    // Midnight Candy is dark by design and keeps its own navy base.
    final bg = alwaysDark ? background : Color.lerp(_darkBase, primary, 0.06)!;
    final cardColor = alwaysDark ? card : Color.lerp(const Color(0xFF1E1E27), primary, 0.08)!;
    return _build(
      background: bg,
      card: cardColor,
      text: alwaysDark ? text : const Color(0xFFF4F2F8),
      primary: alwaysDark ? primary : Color.lerp(primary, Colors.white, 0.18)!,
      tint: (hue) => Color.lerp(cardColor, hue, 0.36)!,
      ink: (hue) => alwaysDark ? hue : Color.lerp(hue, Colors.white, 0.12)!,
      dark: true,
    );
  }

  AppColors _build({
    required Color background,
    required Color card,
    required Color text,
    required Color primary,
    required Color Function(Color) tint,
    required Color Function(Color) ink,
    required bool dark,
  }) {
    final hues = <Color, Color>{
      for (final hue in [this.primary, purple, pink, green, yellow, blue, orange]) tint(hue): ink(hue),
    };
    final neutral = Color.lerp(card, text, dark ? 0.16 : 0.08)!;
    hues[neutral] = Color.lerp(text, background, 0.35)!;
    final base = dark ? AppColors.dark : AppColors.light;
    return AppColors(
      background: background,
      card: card,
      primary: primary,
      onPrimary: _on(primary),
      text: text,
      textMuted: Color.lerp(text, background, dark ? 0.32 : 0.4)!,
      border: Color.lerp(card, text, dark ? 0.16 : 0.1)!,
      lavender: tint(purple),
      peach: tint(pink),
      sage: tint(this.primary),
      butter: tint(yellow),
      blue: tint(blue),
      clay: tint(orange),
      danger: base.danger,
      dangerTint: base.dangerTint,
      warning: base.warning,
      warningTint: base.warningTint,
      success: base.success,
      shadow: dark ? const Color(0x40000000) : text.withValues(alpha: 0.10),
      highContrast: false,
      inks: hues,
      categories: {
        TaskCategory.general: neutral,
        TaskCategory.study: tint(purple),
        TaskCategory.exam: tint(pink),
        TaskCategory.home: tint(green),
        TaskCategory.appointment: tint(blue),
        TaskCategory.medicine: tint(orange),
        TaskCategory.document: tint(yellow),
        TaskCategory.subscription: tint(purple),
        TaskCategory.bill: tint(orange),
      },
    );
  }
}

/// White or near-black, whichever reads better on [color].
Color _on(Color color) =>
    ThemeData.estimateBrightnessForColor(color) == Brightness.dark ? Colors.white : const Color(0xFF1A1A22);

const _palettes = {
  ColorPalette.deepOcean: _PaletteSpec(
    primary: Color(0xFF2F5BFF),
    purple: Color(0xFF7C5CFF),
    pink: Color(0xFFFF6B57),
    green: Color(0xFF00A878),
    yellow: Color(0xFFF5A300),
    blue: Color(0xFF2F5BFF),
    orange: Color(0xFFFF8A3D),
    background: Color(0xFFF3F7FF),
    text: Color(0xFF0F1B3D),
  ),
  ColorPalette.matchaHoney: _PaletteSpec(
    primary: Color(0xFF2E9B4F),
    purple: Color(0xFF8E5CC7),
    pink: Color(0xFFE5484D),
    green: Color(0xFF2E9B4F),
    yellow: Color(0xFFF4B400),
    blue: Color(0xFF0E8FB5),
    orange: Color(0xFFE08A00),
    background: Color(0xFFF4F8F1),
    text: Color(0xFF17261A),
  ),
  ColorPalette.sunsetPop: _PaletteSpec(
    primary: Color(0xFFFF5A36),
    purple: Color(0xFF3B2F8F),
    pink: Color(0xFFFF3D7F),
    green: Color(0xFF16A34A),
    yellow: Color(0xFFF2B600),
    blue: Color(0xFF2F7DE1),
    orange: Color(0xFFFF5A36),
    background: Color(0xFFFFF7F2),
    text: Color(0xFF231A3F),
  ),
  ColorPalette.midnightCandy: _PaletteSpec(
    primary: Color(0xFFFF4FA3),
    purple: Color(0xFF8B7BFF),
    pink: Color(0xFFFF4FA3),
    green: Color(0xFF3DDC84),
    yellow: Color(0xFFFFC53D),
    blue: Color(0xFF2EE6D6),
    orange: Color(0xFFFF8A4C),
    background: Color(0xFF12142B),
    card: Color(0xFF1D2042),
    text: Color(0xFFF1F0FF),
    alwaysDark: true,
  ),
  ColorPalette.creamCocoa: _PaletteSpec(
    primary: Color(0xFF7A4B32),
    purple: Color(0xFFA0674B),
    pink: Color(0xFFC8553D),
    green: Color(0xFF6F8F5E),
    yellow: Color(0xFFE3A857),
    blue: Color(0xFF5B7C99),
    orange: Color(0xFFD07A3A),
    background: Color(0xFFF7F0E6),
    card: Color(0xFFFFFDF9),
    text: Color(0xFF3B2A22),
  ),
  ColorPalette.nordicSnow: _PaletteSpec(
    primary: Color(0xFF3E7CB1),
    purple: Color(0xFF6C7FA8),
    pink: Color(0xFF7A8B9C),
    green: Color(0xFF5AA89A),
    yellow: Color(0xFFC9A66B),
    blue: Color(0xFF3E7CB1),
    orange: Color(0xFFB98A6B),
    background: Color(0xFFF3F5F7),
    text: Color(0xFF1F2A36),
  ),
  ColorPalette.skySunshine: _PaletteSpec(
    primary: Color(0xFF1E88E5),
    purple: Color(0xFF7E6FE0),
    pink: Color(0xFFF2665A),
    green: Color(0xFF27A55A),
    yellow: Color(0xFFFFCB2E),
    blue: Color(0xFF1E88E5),
    orange: Color(0xFFF2A900),
    background: Color(0xFFEDF6FF),
    text: Color(0xFF16304A),
  ),
  ColorPalette.lavenderNight: _PaletteSpec(
    primary: Color(0xFFB79CFF),
    purple: Color(0xFFB79CFF),
    pink: Color(0xFFFF8FAB),
    green: Color(0xFF7FD8BE),
    yellow: Color(0xFFFFD27F),
    blue: Color(0xFF8EC5FF),
    orange: Color(0xFFFFB38A),
    background: Color(0xFF1F1A2E),
    card: Color(0xFF2A2440),
    text: Color(0xFFF2EEFA),
    alwaysDark: true,
  ),
  ColorPalette.lemonCharcoal: _PaletteSpec(
    primary: Color(0xFFFFE14D),
    purple: Color(0xFFB18CFF),
    pink: Color(0xFFFF6B6B),
    green: Color(0xFF5EE0A0),
    yellow: Color(0xFFFFE14D),
    blue: Color(0xFF6BB8FF),
    orange: Color(0xFFFFA24C),
    background: Color(0xFF18191C),
    card: Color(0xFF24262B),
    text: Color(0xFFF5F5F2),
    alwaysDark: true,
  ),
};

/// The colours shown as dots in the palette picker: main colour and two hues.
List<Color> paletteSwatch(ColorPalette p) {
  if (p == ColorPalette.softPastel) {
    return [AppColors.light.primary, AppColors.light.peach, AppColors.light.lavender];
  }
  final s = _palettes[p]!;
  // First three different colours, so no dot repeats the main colour.
  return {s.primary, s.yellow, s.green, s.pink, s.blue}.take(3).toList();
}

/// The dark-by-design palettes ignore the light/dark setting.
bool paletteAlwaysDark(ColorPalette p) => _palettes[p]?.alwaysDark ?? false;

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  /// True when the user asked the OS for less motion.
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;
}

const cardRadius = 22.0;

/// White rounded card with a very soft shadow and optional pastel [tint].
/// Scales down slightly while pressed.
class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.tint,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.radius = cardRadius,
    this.semanticLabel,
  });

  final Widget child;
  final Color? tint;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;

  /// When set, the card is announced as one button with this label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: c.highContrast ? BorderSide(color: c.border, width: 2) : BorderSide(color: c.border.withValues(alpha: 0.6)),
    );
    Widget card = Material(
      color: tint ?? c.card,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: onTap == null
          ? Padding(padding: padding, child: child)
          : InkWell(
              onTap: onTap,
              child: Padding(padding: padding, child: child),
            ),
    );
    if (!c.highContrast) {
      card = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: c.shadow, blurRadius: 14, offset: const Offset(0, 4))],
        ),
        child: card,
      );
    }
    if (onTap != null) card = Pressable(child: card);
    if (semanticLabel != null) {
      card = Semantics(button: onTap != null, label: semanticLabel, excludeSemantics: true, onTap: onTap, child: card);
    }
    return Padding(padding: margin, child: card);
  }
}

/// Slight scale-down while a finger is on the widget.
class Pressable extends StatefulWidget {
  const Pressable({super.key, required this.child});

  final Widget child;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down && !context.reduceMotion ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}

/// Icon on a soft pastel circle.
class IconBubble extends StatelessWidget {
  const IconBubble({super.key, required this.icon, required this.color, this.size = 44});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final ink = c.inks[color];
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: ink ?? color,
          shape: BoxShape.circle,
          border: c.highContrast ? Border.all(color: c.border, width: 1.5) : null,
        ),
        child: Icon(icon, size: size * 0.52, color: ink == null ? c.text : _on(ink)),
      ),
    );
  }
}

/// Small rounded label with a coloured dot, e.g. "● Expires soon".
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color, required this.tint, this.icon});

  final String label;
  final Color color;
  final Color tint;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(999),
        border: c.highContrast ? Border.all(color: color, width: 1.5) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: 14, color: color)
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section title shown as a small rounded pill ("● TODAY").
class SectionPill extends StatelessWidget {
  const SectionPill(this.text, {super.key, this.dot, this.tint});

  final String text;
  final Color? dot;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: StatusPill(label: text.toUpperCase(), color: dot ?? c.text, tint: tint ?? c.sage),
        ),
      ),
    );
  }
}

/// Small friendly illustration: an emoji on a soft circle.
class TinyIllustration extends StatelessWidget {
  const TinyIllustration(this.emoji, {super.key, this.color, this.size = 96});

  final String emoji;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color ?? c.sage,
          shape: BoxShape.circle,
          border: c.highContrast ? Border.all(color: c.border, width: 2) : null,
        ),
        // Emoji ignore text scaling so the illustration keeps its size.
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.45),
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}

/// The LifeKeeper logo (same picture as the app icon), with rounded corners.
/// In high contrast it is shown in grey tones with an outline, so that mode
/// stays black and white.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 96});

  /// Path of the logo asset (made by tool/generate_icons.py).
  static const asset = 'assets/Icon/app_logo.png';

  final double size;

  // Standard luminance weights: turns the colourful logo into greys.
  static const _greyscale = ColorFilter.matrix([
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget logo = Image.asset(asset, width: size, height: size, filterQuality: FilterQuality.medium);
    if (c.highContrast) {
      logo = Container(
        foregroundDecoration: BoxDecoration(
          border: Border.all(color: c.border, width: 2),
          borderRadius: BorderRadius.circular(size * 0.225),
        ),
        child: ColorFiltered(colorFilter: _greyscale, child: logo),
      );
    }
    return ExcludeSemantics(child: logo);
  }
}

/// Empty screen with a tiny illustration, a friendly message and an
/// optional action button.
class FriendlyEmptyState extends StatelessWidget {
  const FriendlyEmptyState({
    super.key,
    required this.emoji,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
    this.color,
  });

  final String emoji;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.colors;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(32, 32, 32, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TinyIllustration(emoji, color: color),
            const SizedBox(height: 20),
            Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            if (body != null) ...[
              const SizedBox(height: 8),
              Text(
                body!,
                style: theme.textTheme.bodyLarge?.copyWith(color: c.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.add_rounded), label: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Plays a small bounce whenever [trigger] becomes true.
class BounceOnTrue extends StatefulWidget {
  const BounceOnTrue({super.key, required this.trigger, required this.child});

  final bool trigger;
  final Widget child;

  @override
  State<BounceOnTrue> createState() => _BounceOnTrueState();
}

class _BounceOnTrueState extends State<BounceOnTrue> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
  late final _scale = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 40),
    TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 60),
  ]).animate(_controller);

  @override
  void didUpdateWidget(BounceOnTrue old) {
    super.didUpdateWidget(old);
    if (widget.trigger && !old.trigger && !context.reduceMotion) _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _scale, child: widget.child);
}

/// Slides and fades a new row in once, the first time it appears.
class SlideIn extends StatelessWidget {
  const SlideIn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.reduceMotion) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (_, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, (1 - t) * 12), child: child),
      ),
      child: child,
    );
  }
}

class PillNavItem {
  const PillNavItem({required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Floating, rounded bottom navigation. The selected item gets a soft pill
/// behind it. Items stay at least 64×56 in Simple mode.
class FloatingPillNav extends StatelessWidget {
  const FloatingPillNav({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
    this.large = false,
  });

  final List<PillNavItem> items;
  final int selected;
  final ValueChanged<int> onSelect;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final theme = Theme.of(context);
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: c.highContrast ? c.border : c.border.withValues(alpha: 0.7),
            width: c.highContrast ? 2 : 1,
          ),
          boxShadow: c.highContrast ? null : [BoxShadow(color: c.shadow, blurRadius: 20, offset: const Offset(0, 6))],
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          children: [
            for (var i = 0; i < items.length; i++)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: i == selected,
                  label: items[i].label,
                  excludeSemantics: true,
                  onTap: () => onSelect(i),
                  child: InkWell(
                    key: ValueKey('nav-$i'),
                    borderRadius: BorderRadius.circular(26),
                    onTap: () => onSelect(i),
                    child: AnimatedContainer(
                      duration: context.reduceMotion ? Duration.zero : const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      constraints: BoxConstraints(minHeight: large ? 64 : 56),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                      decoration: BoxDecoration(
                        color: i == selected ? (c.highContrast ? c.text : c.sage) : Colors.transparent,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            i == selected ? items[i].selectedIcon : items[i].icon,
                            size: large ? 28 : 24,
                            color: i == selected && c.highContrast ? c.background : c.text,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            items[i].label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: i == selected ? FontWeight.w800 : FontWeight.w600,
                              color: i == selected && c.highContrast ? c.background : c.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Round check button. When ticked it fills and bounces, then reports the
/// change a moment later so the user sees the tick before the row moves.
class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({super.key, required this.checked, required this.onChanged, required this.label, this.size = 26});

  final bool checked;
  final VoidCallback onChanged;

  /// Screen-reader label, e.g. "Mark as done".
  final String label;
  final double size;

  @override
  State<AnimatedCheck> createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck> {
  bool? _pending;

  bool get _checked => _pending ?? widget.checked;

  @override
  void didUpdateWidget(AnimatedCheck old) {
    super.didUpdateWidget(old);
    if (old.checked != widget.checked) _pending = null;
  }

  Future<void> _tap() async {
    if (_pending != null) return;
    setState(() => _pending = !widget.checked);
    if (!context.reduceMotion) await Future<void>.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;
    widget.onChanged();
    // If the row stays (e.g. undo), drop the local state.
    if (mounted) setState(() => _pending = null);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final checked = _checked;
    return Semantics(
      checked: checked,
      label: widget.label,
      button: true,
      excludeSemantics: true,
      onTap: _tap,
      child: InkResponse(
        onTap: _tap,
        radius: 26,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: BounceOnTrue(
              trigger: checked,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: checked ? c.primary : Colors.transparent,
                  border: Border.all(color: checked ? c.primary : c.textMuted, width: 2),
                ),
                child: checked ? Icon(Icons.check_rounded, size: widget.size * 0.7, color: c.onPrimary) : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text that always takes up exactly [lines] lines, so cards that show it
/// keep the same height whether the text is short or long. Longer text is
/// cut with "…" (screen readers still get the full text).
class FixedLinesText extends StatelessWidget {
  const FixedLinesText(this.text, {super.key, required this.lines, this.style, this.center = false});

  final String text;
  final int lines;
  final TextStyle? style;

  /// Centre shorter text vertically inside the reserved space.
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: center ? AlignmentDirectional.centerStart : AlignmentDirectional.topStart,
      children: [
        // Invisible placeholder that reserves the height of [lines] lines.
        ExcludeSemantics(
          child: Opacity(
            opacity: 0,
            child: Text('${'\n' * (lines - 1)} ', style: style, maxLines: lines),
          ),
        ),
        Text(text, style: style, maxLines: lines, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
