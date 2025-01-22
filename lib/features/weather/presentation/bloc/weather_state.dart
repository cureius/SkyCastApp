part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class SearchCityWeatherLoadingState extends WeatherState {}

final class SearchCityWeatherFailureState extends WeatherState {
  final String error;

  SearchCityWeatherFailureState(this.error);
}

final class SearchCityWeatherSuccessState extends WeatherState {
  final Weather weather;

  SearchCityWeatherSuccessState(this.weather);
}

final class GetCurrentLocationWeatherLoadingState extends WeatherState {}

final class GetCurrentLocationWeatherFailureState extends WeatherState {
  final String error;

  GetCurrentLocationWeatherFailureState(this.error);
}

final class GetCurrentLocationWeatherSuccessState extends WeatherState {
  final Weather weather;

  GetCurrentLocationWeatherSuccessState(this.weather);
}

final class CurrentLocationWeatherLoading extends WeatherState {}

final class WeatherFailure extends WeatherState {
  final String error;

  WeatherFailure(this.error);
}

final class WeathersDisplaySuccess extends WeatherState {
  final List<Weather> weathers;

  WeathersDisplaySuccess(this.weathers);
}

final class WeatherDisplaySuccess extends WeatherState {
  final Weather weather;

  WeatherDisplaySuccess(this.weather);
}

final class CurrentLocationWeatherDisplaySuccess extends WeatherState {
  final Weather weather;

  CurrentLocationWeatherDisplaySuccess(this.weather);
}

final class MakeWeatherFavouriteDisplaySuccess extends WeatherState {
  final List<Weather> weathers;

  MakeWeatherFavouriteDisplaySuccess(this.weathers);
}

final class MakeWeatherUnFavouriteDisplaySuccess extends WeatherState {
  final List<Weather> weathers;

  MakeWeatherUnFavouriteDisplaySuccess(this.weathers);
}

final class WeatherDeletedSuccess extends WeatherState {
  final List<Weather> weathers;

  WeatherDeletedSuccess(this.weathers);
}
