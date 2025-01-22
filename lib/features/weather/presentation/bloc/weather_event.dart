part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

final class FetchWeatherEvent extends WeatherEvent {
  final String query;

  FetchWeatherEvent({
    required this.query,
  });
}

final class SearchCityWeatherEvent extends WeatherEvent {
  final String query;

  SearchCityWeatherEvent({
    required this.query,
  });
}

final class GetCurrentLocationWeatherEvent extends WeatherEvent {
  final String latitude;
  final String longitude;

  GetCurrentLocationWeatherEvent(
      {required this.latitude, required this.longitude});
}

final class FetchWeatherByCoordinatesEvent extends WeatherEvent {
  final String latitude;
  final String longitude;

  FetchWeatherByCoordinatesEvent(
      {required this.latitude, required this.longitude});
}

final class FetchAllWeathersEvent extends WeatherEvent {}

final class MakeWeatherFavourite extends WeatherEvent {
  final Weather weather;

  MakeWeatherFavourite({
    required this.weather,
  });
}

final class MakeWeatherUnFavourite extends WeatherEvent {
  final Weather weather;

  MakeWeatherUnFavourite({
    required this.weather,
  });
}

final class DeleteWeatherEvent extends WeatherEvent {
  final Weather weather;

  DeleteWeatherEvent({
    required this.weather,
  });
}
