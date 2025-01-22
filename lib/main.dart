import 'package:flutter/material.dart';
import 'package:sky_cast/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:sky_cast/core/common/pages/root_screen.dart';
import 'package:sky_cast/core/theme/theme.dart';
import 'package:sky_cast/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sky_cast/features/auth/presentation/pages/login_page.dart';
import 'package:sky_cast/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:sky_cast/init_dependencies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<WeatherBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: AppTheme.lightThemeMode,
      darkTheme: AppTheme.darkThemeMode,
      themeMode: ThemeMode.system,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const RootScreen();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
