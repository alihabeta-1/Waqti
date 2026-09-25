import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:waqti/app/cubit/app_cubit.dart';
import 'package:waqti/app/cubit/app_state.dart';
import 'package:waqti/core/constants/app_assets.dart';
import 'package:waqti/features/booking/presentation/widgets/header_action.dart';
import 'package:waqti/l10n/app_localizations.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(AppAssets.waqtiLogo),
          ),

          SizedBox(width: 10.w),

          Text(
            l10n.appName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),

          const Spacer(),

          BlocBuilder<AppCubit, AppState>(
            buildWhen: (previous, current) => previous.locale != current.locale,
            builder: (context, state) {
              return HeaderAction(
                label: state.locale.languageCode == 'ar' ? 'EN' : 'AR',
                icon: Icons.language_rounded,
                onTap: () {
                  context.read<AppCubit>().toggleLanguage();
                },
              );
            },
          ),

          SizedBox(width: 8.w),

          BlocBuilder<AppCubit, AppState>(
            buildWhen: (previous, current) =>
                previous.themeMode != current.themeMode,
            builder: (context, state) {
              final isDark = state.themeMode == ThemeMode.dark;

              return HeaderAction(
                icon: isDark
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                onTap: () {
                  context.read<AppCubit>().toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
