import 'package:sky_cast/core/error/exceptions.dart';
import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/network/connection_checker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:sky_cast/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:sky_cast/features/weather/data/models/weather_model.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/repositories/weather_repository.dart';
import 'dart:developer' as developer;

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource weatherRemoteDataSource;
  final WeatherLocalDataSource weatherLocalDataSource;
  final ConnectionChecker connectionChecker;

  WeatherRepositoryImpl(
    this.weatherRemoteDataSource,
    this.weatherLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, List<Weather>>> getAllWeather() async {
    try {
      final weathers = weatherLocalDataSource.loadWeathers();
      if (weathers != null) {
        final weatherList =
            weathers.map((weatherModel) => weatherModel as Weather).toList();
        return right(weatherList);
      } else {
        return left(Failure("Empty List"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Weather>> getWeather({required String query}) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final weather = weatherLocalDataSource.loadWeather(query: query);
        if (weather != null) {
          return right(weather);
        } else {
          return left(Failure("Weather not found!"));
        }
      }
      final weather = await weatherRemoteDataSource.getWeather(query: query);
      final oldWeather = weatherLocalDataSource.loadWeather(query: query);
      if (oldWeather != null) {
        weatherLocalDataSource.addWeather(
            weather: weather.copyWith(isFavourite: oldWeather.isFavourite));
        return right(weather.copyWith(isFavourite: oldWeather.isFavourite));
      } else {
        weatherLocalDataSource.addWeather(weather: weather);
        return right(weather);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> markFavouriteWeather(
      {required Weather weather}) async {
    try {
      final weathers = weatherLocalDataSource.markFavouriteWeather(
          weather: weather as WeatherModel);
      if (weathers != null) {
        final weatherList =
            weathers.map((weatherModel) => weatherModel as Weather).toList();
        return right(weatherList);
      } else {
        return left(Failure("Empty List"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> unMarkFavouriteWeather(
      {required Weather weather}) async {
    try {
      final weathers = weatherLocalDataSource.unMarkFavouriteWeather(
          weather: weather as WeatherModel);
      if (weathers != null) {
        final weatherList =
            weathers.map((weatherModel) => weatherModel as Weather).toList();
        return right(weatherList);
      } else {
        return left(Failure("Empty List"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Weather>>> deleteWeather(
      {required Weather weather}) async {
    try {
      final weathers = weatherLocalDataSource.deleteWeather(
          weather: weather as WeatherModel);
      if (weathers != null) {
        final weatherList =
            weathers.map((weatherModel) => weatherModel as Weather).toList();
        return right(weatherList);
      } else {
        return left(Failure("Empty List"));
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Weather>> getCurrentLocationWeather(
      {required String latitude, required String longitude}) async {
    try {
      // Offline
      if (!await (connectionChecker.isConnected)) {
        final weather = weatherLocalDataSource.loadCurrentLocationWeather(
            latitude: latitude, longitude: longitude);
        if (weather != null) {
          return right(weather);
        } else {
          return left(Failure("Weather not found!"));
        }
      }
      final weather = await weatherRemoteDataSource.getCurrentLocationWeather(
          latitude: latitude, longitude: longitude);
      weatherLocalDataSource.addCurrentLocationWeather(weather: weather);
      return right(weather);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
