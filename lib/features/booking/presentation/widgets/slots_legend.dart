import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/presentation/widgets/legend_item.dart';
import 'package:waqti/l10n/app_localizations.dart';

class SlotsLegend extends StatelessWidget {
  const SlotsLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 14.w,
      runSpacing: 8.h,
      children: [
        LegendItem(
          label: l10n.available,
          color: const Color(0xFF10B981),
        ),
        LegendItem(
          label: l10n.selected,
          color: colorScheme.primary,
        ),
        LegendItem(
          label: l10n.booked,
          color: const Color(0xFFF59E0B),
        ),
        LegendItem(
          label: l10n.unavailable,
          color: Theme.of(context).disabledColor,
        ),
      ],
    );
  }
}
