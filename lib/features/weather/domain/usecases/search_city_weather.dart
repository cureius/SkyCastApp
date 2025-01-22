import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/repositories/weather_repository.dart';

class SearchCityWeather implements UseCase<Weather, SearchParams> {
  final WeatherRepository weatherRepository;
  SearchCityWeather(this.weatherRepository);

  @override
  Future<Either<Failure, Weather>> call(SearchParams params) async {
    return await weatherRepository.getWeather(query: params.query);
  }
}


class SearchParams {
  final String query; // City name

  SearchParams({
    required this.query,
  });
}
