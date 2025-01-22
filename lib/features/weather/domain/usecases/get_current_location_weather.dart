import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/repositories/weather_repository.dart';

class GetCurrentLocationWeather implements UseCase<Weather, LocationParams> {
  final WeatherRepository weatherRepository;

  GetCurrentLocationWeather(this.weatherRepository);

  @override
  Future<Either<Failure, Weather>> call(LocationParams params) async {
    return await weatherRepository.getCurrentLocationWeather(
        latitude: params.latitude, longitude: params.longitude);
  }
}

class LocationParams {
  final String latitude;
  final String longitude;

  LocationParams({
    required this.latitude,
    required this.longitude,
  });
}
