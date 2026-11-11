import 'package:beseech/business/information.dart';
import 'package:beseech/business/prayers.dart';
import 'package:beseech/domain/models/age_vysor.dart';
import 'package:beseech/ui/design/beseech_design.dart';
import 'package:beseech/ui/formatting.dart';
import 'package:beseech/ui/widgets/beseech_components.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_database/app/liquid_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<InformationController>();
    final prayers = context.watch<PrayersController>();
    final ledger = prayers.ledger(profile.user);
    final user = profile.user;
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: BeseechSpace.page,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('You', style: context.sectionTitle),
              Text(
                'Used to estimate remaining prayers since obligation',
                style: context.muted,
              ),
              BeseechSpace.gapMd,
              BeseechSection(
                title: 'Identity',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BeseechFieldLabel('Name'),
                    TextFormField(
                      initialValue: user.name,
                      onChanged: profile.setName,
                      style: context.bodyStrong,
                      decoration: const InputDecoration(
                        hintText: 'Your name',
                      ),
                    ),
                    BeseechSpace.gapLg,
                    LiquidSurface(
                      variant: LiquidVariant.chip,
                      highlight: true,
                      child: Text(
                        user.ageVysor.format(profile.age),
                        textAlign: TextAlign.center,
                        style: context.sectionTitle.copyWith(
                          color: scheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              BeseechSpace.gapMd,
              BeseechSection(
                title: 'Dates',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BeseechFieldLabel('Date of birth'),
                    FilledButton.tonal(
                      onPressed: () => _pickDate(
                        context,
                        initial: user.dateOfBirth,
                        onPicked: profile.setDateOfBirth,
                      ),
                      child: Text(user.dateOfBirth.humanReadable),
                    ),
                    BeseechSpace.gapMd,
                    LiquidToggleRow(
                      title: 'I know my puberty date',
                      subtitle: 'Otherwise we estimate from birth + 13 years',
                      value: user.knowsPubertyDate,
                      onChanged: profile.setKnowsPubertyDate,
                    ),
                    if (user.knowsPubertyDate) ...[
                      BeseechSpace.gapSm,
                      const BeseechFieldLabel('Puberty / obligation start'),
                      FilledButton.tonal(
                        onPressed: () => _pickDate(
                          context,
                          initial: user.dateOfPuberty,
                          onPicked: profile.setDateOfPuberty,
                        ),
                        child: Text(user.dateOfPuberty.humanReadable),
                      ),
                    ],
                    BeseechSpace.gapSm,
                    Text(
                      'Obligation from ${user.prayerObligationStart.humanReadable}',
                      style: context.muted,
                    ),
                  ],
                ),
              ),
              BeseechSpace.gapMd,
              BeseechSection(
                title: 'Age display',
                child: Wrap(
                  spacing: BeseechSpace.xs,
                  runSpacing: BeseechSpace.xs,
                  children: [
                    for (final unit in AgeVysor.values)
                      BeseechChoiceChip(
                        label: unit.name.toUpperCase(),
                        selected: unit == user.ageVysor,
                        onTap: unit == user.ageVysor
                            ? null
                            : () => profile.setAgeVysor(unit),
                      ),
                  ],
                ),
              ),
              BeseechSpace.gapMd,
              BeseechSection(
                title: 'Lifetime snapshot',
                child: Column(
                  children: [
                    _FactRow(
                      label: 'Days under obligation',
                      value: '${ledger.obligationDays}',
                    ),
                    _FactRow(
                      label: 'Prayers logged (ada)',
                      value: '${ledger.lifetimeAda}',
                    ),
                    _FactRow(
                      label: 'Remaining estimate',
                      value: '${ledger.remainingPrayers}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initial,
    required Future<void> Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) await onPicked(picked);
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: BeseechSpace.xs),
      child: Row(
        children: [
          Expanded(child: Text(label, style: context.muted)),
          Text(
            value,
            style: context.bodyStrong.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
