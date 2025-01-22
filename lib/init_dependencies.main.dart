part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initWeather();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton<Box>(() => Hive.box(name: 'weatherBox'),
      instanceName: 'weatherBox');
  serviceLocator.registerLazySingleton<Box>(
      () => Hive.box(name: 'currentWeatherBox'),
      instanceName: 'currentWeatherBox');

  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(
      serviceLocator(),
    ),
  );
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initWeather() {
  // Datasource
  serviceLocator
    ..registerFactory<WeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<WeatherLocalDataSource>(
      () => WeatherLocalDataSourceImpl(
        serviceLocator<Box>(instanceName: 'weatherBox'),
        serviceLocator<Box>(instanceName: 'currentWeatherBox'),
      ),
    )
    // Repository
    ..registerFactory<WeatherRepository>(
      () => WeatherRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Use-cases
    ..registerFactory(
      () => GetAllWeathers(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetWeather(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SearchCityWeather(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetCurrentLocationWeather(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => MarkFavouriteWeather(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UnMarkFavouriteWeather(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteWeather(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => WeatherBloc(
        getAllWeathers: serviceLocator(),
        getWeather: serviceLocator(),
        markFavouriteWeather: serviceLocator(),
        unMarkFavouriteWeather: serviceLocator(),
        deleteWeather: serviceLocator(),
        getCurrentLocationWeather: serviceLocator(),
        searchCityWeather: serviceLocator(),
      ),
    );
}
