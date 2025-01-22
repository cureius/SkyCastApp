import 'package:sky_cast/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';

abstract interface class WeatherRepository {
  Future<Either<Failure, List<Weather>>> getAllWeather();

  Future<Either<Failure, Weather>> getWeather({required String query});

  Future<Either<Failure, Weather>> getCurrentLocationWeather({
    required String latitude,
    required String longitude,
  });

  Future<Either<Failure, List<Weather>>> markFavouriteWeather(
      {required Weather weather});

  Future<Either<Failure, List<Weather>>> unMarkFavouriteWeather(
      {required Weather weather});

  Future<Either<Failure, List<Weather>>> deleteWeather(
      {required Weather weather});
}
