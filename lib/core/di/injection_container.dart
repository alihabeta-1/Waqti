import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waqti/app/cubit/app_cubit.dart';
import 'package:waqti/app/data/app_preferences.dart';
import 'package:waqti/core/time/time_provider.dart';
import 'package:waqti/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:waqti/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:waqti/features/booking/domain/repositories/booking_repository.dart';
import 'package:waqti/features/booking/domain/services/booking_validator.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<BookingLocalDataSource>(
    () => BookingLocalDataSourceImpl(
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerLazySingleton<BookingRepository>(
    () =>
        BookingRepositoryImpl(localDataSource: getIt<BookingLocalDataSource>()),
  );

  getIt.registerLazySingleton<BookingValidator>(
    () => BookingValidator(timeProvider: getIt<TimeProvider>()),
  );
  getIt.registerFactory<AppCubit>(
    () => AppCubit(preferences: getIt<AppPreferences>()),
  );

  getIt.registerFactory<BookingCubit>(
    () => BookingCubit(
      repository: getIt<BookingRepository>(),
      validator: getIt<BookingValidator>(),
    ),
  );

  getIt.registerLazySingleton<AppPreferences>(
    () => AppPreferences(sharedPreferences: getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<TimeProvider>(() => const SystemTimeProvider());
}
