import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/repositories/weather_repository.dart';
class UnMarkFavouriteWeather implements UseCase<List<Weather>, Weather> {
  final WeatherRepository weatherRepository;
  UnMarkFavouriteWeather(this.weatherRepository);

  @override
  Future<Either<Failure, List<Weather>>> call(Weather params) async {
    return await weatherRepository.unMarkFavouriteWeather(weather: params);
  }
}
