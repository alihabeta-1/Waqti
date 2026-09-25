import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/app/cubit/app_cubit.dart';
import 'package:waqti/app/cubit/app_state.dart';
import 'package:waqti/app/theme/app_theme.dart';
import 'package:waqti/core/di/injection_container.dart';
import 'package:waqti/features/splash/presentation/views/splash_View.dart';
import 'package:waqti/l10n/app_localizations.dart';

class WaqtiApp extends StatelessWidget {
  const WaqtiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,

                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: state.themeMode,

                locale: state.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,

                home: const SplashView(),
              );
            },
          );
        },
      ),
    );
  }
}
