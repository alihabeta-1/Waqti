import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waqti/features/booking/domain/entities/slot_status.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/presentation/widgets/slot_status_label.dart';
import 'package:waqti/l10n/app_localizations.dart';

class TimeSlotTile extends StatelessWidget {
  const TimeSlotTile({
    super.key,
    required this.slot,
    required this.isSelected,
    required this.isValidStartTime,
    required this.hasDuration,
    required this.onTap,
  });

  final TimeSlot slot;
  final bool isSelected;
  final bool isValidStartTime;
  final bool hasDuration;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isBooked = slot.status == SlotStatus.booked;
    final isUnavailable =
        slot.status == SlotStatus.unavailable;

    final canSelect =
        hasDuration &&
        slot.status == SlotStatus.available &&
        isValidStartTime;

    final backgroundColor = _getBackgroundColor(
      context: context,
      isBooked: isBooked,
      isUnavailable: isUnavailable,
      isSelected: isSelected,
      canSelect: canSelect,
    );

    final borderColor = _getBorderColor(
      context: context,
      isBooked: isBooked,
      isUnavailable: isUnavailable,
      isSelected: isSelected,
      canSelect: canSelect,
    );

    final statusColor = _getStatusColor(
      context: context,
      isBooked: isBooked,
      isUnavailable: isUnavailable,
      isSelected: isSelected,
      canSelect: canSelect,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canSelect ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 12.h,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat(
                  'hh:mm a',
                  Localizations.localeOf(
                    context,
                  ).languageCode,
                ).format(slot.start),
                maxLines: 1,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _getTimeColor(
                        context: context,
                        isBooked: isBooked,
                        isUnavailable: isUnavailable,
                        canSelect: canSelect,
                        isSelected: isSelected,
                      ),
                    ),
              ),

              SizedBox(height: 6.h),

              SlotStatusLabel(
                label: _getStatusLabel(
                  l10n: l10n,
                  isBooked: isBooked,
                  isUnavailable: isUnavailable,
                  isSelected: isSelected,
                  canSelect: canSelect,
                  hasDuration: hasDuration,
                ),
                color: statusColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusLabel({
    required AppLocalizations l10n,
    required bool isBooked,
    required bool isUnavailable,
    required bool isSelected,
    required bool canSelect,
    required bool hasDuration,
  }) {
    if (isSelected) {
      return l10n.selected;
    }

    if (isBooked) {
      return l10n.booked;
    }

    if (isUnavailable) {
      return l10n.unavailable;
    }

    if (!hasDuration) {
      return l10n.selectDurationFirst;
    }

    if (!canSelect) {
      return l10n.notAvailableForDuration;
    }

    return l10n.available;
  }

  Color _getStatusColor({
    required BuildContext context,
    required bool isBooked,
    required bool isUnavailable,
    required bool isSelected,
    required bool canSelect,
  }) {
    if (isSelected) {
      return Theme.of(context).colorScheme.primary;
    }

    if (isBooked) {
      return const Color(0xFFF59E0B);
    }

    if (isUnavailable) {
      return Theme.of(context).disabledColor;
    }

    if (canSelect) {
      return const Color(0xFF10B981);
    }

    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  Color _getBackgroundColor({
    required BuildContext context,
    required bool isBooked,
    required bool isUnavailable,
    required bool isSelected,
    required bool canSelect,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isSelected) {
      return colorScheme.primary.withValues(alpha: 0.10);
    }

    if (isBooked) {
      return const Color(
        0xFFF59E0B,
      ).withValues(alpha: 0.08);
    }

    if (isUnavailable) {
      return colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.50,
      );
    }

    if (canSelect) {
      return const Color(
        0xFF10B981,
      ).withValues(alpha: 0.07);
    }

    return colorScheme.surface;
  }

  Color _getBorderColor({
    required BuildContext context,
    required bool isBooked,
    required bool isUnavailable,
    required bool isSelected,
    required bool canSelect,
  }) {
    if (isSelected) {
      return Theme.of(context).colorScheme.primary;
    }

    if (isBooked) {
      return const Color(
        0xFFF59E0B,
      ).withValues(alpha: 0.50);
    }

    if (canSelect) {
      return const Color(
        0xFF10B981,
      ).withValues(alpha: 0.40);
    }

    return Theme.of(context).dividerColor;
  }

  Color _getTimeColor({
    required BuildContext context,
    required bool isBooked,
    required bool isUnavailable,
    required bool canSelect,
    required bool isSelected,
  }) {
    if (isSelected || canSelect) {
      return Theme.of(context).colorScheme.onSurface;
    }

    if (isBooked || isUnavailable) {
      return Theme.of(context).disabledColor;
    }

    return Theme.of(context).colorScheme.onSurfaceVariant;
  }
}
