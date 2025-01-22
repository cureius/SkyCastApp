import 'package:sky_cast/core/usecase/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/domain/usecases/get_all_weather.dart';
import 'package:sky_cast/features/weather/domain/usecases/get_current_location_weather.dart';
import 'package:sky_cast/features/weather/domain/usecases/get_weather.dart';
import 'dart:developer' as developer;
import 'package:sky_cast/features/weather/domain/usecases/mark_favourite.dart';
import 'package:sky_cast/features/weather/domain/usecases/search_city_weather.dart';
import 'package:sky_cast/features/weather/domain/usecases/un_mark_favourite.dart';
import 'package:sky_cast/features/weather/domain/usecases/delete_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetAllWeathers _getAllWeathers;
  final GetWeather _getWeather;
  final SearchCityWeather _searchCityWeather;
  final GetCurrentLocationWeather _getCurrentLocationWeather;
  final MarkFavouriteWeather _markFavouriteWeather;
  final UnMarkFavouriteWeather _unMarkFavouriteWeather;
  final DeleteWeather _deleteWeather;

  WeatherBloc({
    required GetAllWeathers getAllWeathers,
    required GetWeather getWeather,
    required SearchCityWeather searchCityWeather,
    required GetCurrentLocationWeather getCurrentLocationWeather,
    required MarkFavouriteWeather markFavouriteWeather,
    required UnMarkFavouriteWeather unMarkFavouriteWeather,
    required DeleteWeather deleteWeather,
  })  : _getWeather = getWeather,
        _searchCityWeather = searchCityWeather,
        _getCurrentLocationWeather = getCurrentLocationWeather,
        _getAllWeathers = getAllWeathers,
        _markFavouriteWeather = markFavouriteWeather,
        _unMarkFavouriteWeather = unMarkFavouriteWeather,
        _deleteWeather = deleteWeather,
        super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) => emit(WeatherLoading()));
    on<FetchAllWeathersEvent>(_onFetchAllWeathers);
    on<FetchWeatherEvent>(_onFetchWeather);
    on<SearchCityWeatherEvent>(_onSearchCityWeather);
    on<GetCurrentLocationWeatherEvent>(_onGetCurrentLocationWeatherEvent);
    on<MakeWeatherFavourite>(_onMakeWeatherFavourite);
    on<MakeWeatherUnFavourite>(_onMakeWeatherUnFavourite);
    on<DeleteWeatherEvent>(_onDeleteWeather);
  }

  void _onFetchAllWeathers(
    FetchAllWeathersEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final res = await _getAllWeathers(NoParams());
    res.fold(
      (l) => emit(WeatherFailure(l.message)),
      (r) => emit(WeathersDisplaySuccess(r)),
    );
  }

  void _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final res = await _getWeather(
      QueryParams(
        query: event.query,
      ),
    );

    res.fold(
      (l) => emit(WeatherFailure(l.message)),
      (r) => emit(WeatherDisplaySuccess(r)),
    );
  }
  void _onSearchCityWeather(
    SearchCityWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(SearchCityWeatherLoadingState());
    final res = await _searchCityWeather(
      SearchParams(
        query: event.query,
      ),
    );

    res.fold(
      (l) => emit(SearchCityWeatherFailureState(l.message)),
      (r) => emit(SearchCityWeatherSuccessState(r)),
    );
  }

  void _onGetCurrentLocationWeatherEvent(
    GetCurrentLocationWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    emit(GetCurrentLocationWeatherLoadingState());
    final res = await _getCurrentLocationWeather(
      LocationParams(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    res.fold(
      (l) => emit(GetCurrentLocationWeatherFailureState(l.message)),
      (r) => emit(GetCurrentLocationWeatherSuccessState(r)),
    );
  }

  void _onMakeWeatherFavourite(
    MakeWeatherFavourite event,
    Emitter<WeatherState> emit,
  ) async {
    final res = await _markFavouriteWeather(event.weather);
    res.fold(
      (l) => emit(WeatherFailure(l.message)),
      (r) => emit(WeathersDisplaySuccess(r)),
    );
  }

  void _onMakeWeatherUnFavourite(
    MakeWeatherUnFavourite event,
    Emitter<WeatherState> emit,
  ) async {
    final res = await _unMarkFavouriteWeather(event.weather);
    res.fold(
      (l) => emit(WeatherFailure(l.message)),
      (r) => emit(WeathersDisplaySuccess(r)),
    );
  }

  void _onDeleteWeather(
    DeleteWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final res = await _deleteWeather(event.weather);
    res.fold(
      (l) => emit(WeatherFailure(l.message)),
      (r) => emit(WeatherDeletedSuccess(r)),
    );
  }
}
