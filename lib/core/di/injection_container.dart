import 'package:get_it/get_it.dart';
import 'package:waqti/app/cubit/app_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerFactory<AppCubit>(() => AppCubit());
}
