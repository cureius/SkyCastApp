import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/repositories/weather_repository.dart';

class GetWeather implements UseCase<Weather, QueryParams> {
  final WeatherRepository weatherRepository;
  GetWeather(this.weatherRepository);

  @override
  Future<Either<Failure, Weather>> call(QueryParams params) async {
    return await weatherRepository.getWeather(query: params.query);
  }
}


class QueryParams {
  final String query;

  QueryParams({
    required this.query,
  });
}
