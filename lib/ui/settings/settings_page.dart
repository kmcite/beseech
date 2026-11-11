import 'package:beseech/business/configuration.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/ui/widgets/beseech_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<ConfigurationController>();
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: BeseechSpace.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Settings', style: context.sectionTitle),
            BeseechSpace.gapMd,
            BeseechSection(
              title: 'Appearance',
              child: BeseechThemeToggle(
                isDark: config.dark,
                onSelectLight: config.toggleDark,
                onSelectDark: config.toggleDark,
              ),
            ),
            BeseechSpace.gapMd,
            BeseechSection(
              title: 'Data',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Reset removes every logged prayer and clears your profile.',
                    style: context.muted,
                  ),
                  BeseechSpace.gapSm,
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      foregroundColor: scheme.error,
                    ),
                    onPressed: () => _confirmReset(context, config),
                    child: const Text('Reset all data'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    ConfigurationController config,
  ) async {
    final agreed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset everything?'),
        content: const Text(
          'This cannot be undone. All prayer logs and profile data will be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (agreed == true) await config.restoreApplication();
  }
}
