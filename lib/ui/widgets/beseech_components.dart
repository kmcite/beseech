import 'package:beseech/ui/design/beseech_design.dart';
import 'package:flutter/material.dart';
import 'package:shared_database/app/liquid_theme.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class BeseechSection extends StatelessWidget {
  const BeseechSection({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding,
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return LiquidSurface(
      padding: padding ?? BeseechSpace.cardInset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            LiquidSectionHeader(title: title!, trailing: trailing),
          ],
          child,
        ],
      ),
    );
  }
}

class BeseechFieldLabel extends StatelessWidget {
  const BeseechFieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: BeseechSpace.xs),
      child: Text(text, style: context.fieldLabel),
    );
  }
}

class BeseechTopActions extends StatelessWidget {
  const BeseechTopActions({super.key, required this.actions});

  final List<BeseechTopAction> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: BeseechSpace.sm),
      child: LiquidSurface(
        variant: LiquidVariant.chrome,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              IconButton(
                tooltip: actions[i].tooltip,
                onPressed: actions[i].onPressed,
                icon: Icon(actions[i].icon),
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  foregroundColor: scheme.onSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(LiquidTheme.radiusSm),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BeseechTopAction {
  const BeseechTopAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
}

class BeseechThemeToggle extends StatelessWidget {
  const BeseechThemeToggle({
    super.key,
    required this.isDark,
    required this.onSelectLight,
    required this.onSelectDark,
  });

  final bool isDark;
  final VoidCallback onSelectLight;
  final VoidCallback onSelectDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ThemeOption(
            selected: !isDark,
            icon: Icons.light_mode_rounded,
            label: 'Light',
            onTap: isDark ? onSelectLight : null,
          ),
        ),
        BeseechSpace.gapSm,
        Expanded(
          child: _ThemeOption(
            selected: isDark,
            icon: Icons.dark_mode_rounded,
            label: 'Dark',
            onTap: !isDark ? onSelectDark : null,
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LiquidSurface(
      variant: LiquidVariant.chip,
      highlight: selected,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? scheme.primary : scheme.onSurfaceVariant,
          ),
          const SizedBox(width: BeseechSpace.xs),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? scheme.primary : scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class BeseechChoiceChip extends StatelessWidget {
  const BeseechChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return LiquidSurface(
      variant: LiquidVariant.chip,
      highlight: selected,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
          color: selected ? scheme.primary : scheme.onSurface,
        ),
      ),
    );
  }
}

class BeseechDetailRow extends StatelessWidget {
  const BeseechDetailRow({
    super.key,
    required this.title,
    required this.trailing,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String trailing;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BeseechSpace.xs),
      child: Row(
        children: [
          Expanded(child: Text(title, style: context.bodyStrong)),
          Icon(icon, size: 20, color: tone),
          const SizedBox(width: BeseechSpace.xs),
          Text(
            trailing,
            style: context.bodyStrong.copyWith(
              color: tone,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class BeseechPrimaryButton extends StatelessWidget {
  const BeseechPrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class BeseechSummaryStat extends StatelessWidget {
  const BeseechSummaryStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LiquidSurface(
        variant: LiquidVariant.chip,
        padding: const EdgeInsets.symmetric(
          horizontal: BeseechSpace.sm,
          vertical: BeseechSpace.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: tone, size: 22),
            const SizedBox(height: BeseechSpace.sm),
            Text(value, style: context.statValue.copyWith(color: tone)),
            Text(label, style: context.statLabel),
          ],
        ),
      ),
    );
  }
}
