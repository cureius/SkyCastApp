import 'package:sky_cast/core/error/failures.dart';
import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/repositories/weather_repository.dart';
class GetAllWeathers implements UseCase<List<Weather>, NoParams> {
  final WeatherRepository weatherRepository;
  GetAllWeathers(this.weatherRepository);

  @override
  Future<Either<Failure, List<Weather>>> call(NoParams params) async {
    return await weatherRepository.getAllWeather();
  }
}
