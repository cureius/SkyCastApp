import 'package:hive/hive.dart';
import 'package:sky_cast/features/weather/data/models/weather_model.dart';
import 'dart:developer' as developer;

abstract interface class WeatherLocalDataSource {
  WeatherModel? loadWeather({required String query});

  WeatherModel? loadCurrentLocationWeather(
      {required String latitude, required String longitude});

  List<WeatherModel>? loadWeathers();

  List<WeatherModel>? markFavouriteWeather({required WeatherModel weather});

  List<WeatherModel>? unMarkFavouriteWeather({required WeatherModel weather});

  List<WeatherModel>? deleteWeather({required WeatherModel weather});

  void addWeather({required WeatherModel weather});

  void addCurrentLocationWeather({required WeatherModel weather});
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final Box weatherBox;
  final Box currentWeatherBox;

  WeatherLocalDataSourceImpl(this.weatherBox, this.currentWeatherBox);

  @override
  WeatherModel? loadWeather({required String query}) {
    WeatherModel? weather;
    weatherBox.read(() {
      final keys = weatherBox.keys;
      for (int i = 0; i < keys.length; i++) {
        if (weatherBox[keys[i]]
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase())) {
          weather = (WeatherModel.fromJson(weatherBox[keys[i]]));
          break;
        }
      }
    });

    return weather;
  }

  @override
  List<WeatherModel>? loadWeathers() {
    List<WeatherModel>? weathers = [];

    weatherBox.read(() {
      var keys = weatherBox.keys;
      for (int i = 0; i < keys.length; i++) {
        weathers.add(WeatherModel.fromJson(weatherBox.get(keys[i].toString())));
      }
    });

    return weathers.reversed.toList();
  }

  @override
  void addWeather({required WeatherModel weather}) {
    weatherBox.write(() {
      weatherBox.put(weather.request.query.toString(), weather.toJson());
    });
  }

  @override
  List<WeatherModel>? markFavouriteWeather({required WeatherModel weather}) {
    List<WeatherModel>? weathers = [];
    weatherBox.write(() {
      weatherBox.put(weather.request.query.toString(),
          weather.copyWith(isFavourite: true).toJson());
    });
    weatherBox.read(() {
      var keys = weatherBox.keys;
      for (int i = 0; i < keys.length; i++) {
        weathers.add(WeatherModel.fromJson(weatherBox.get(keys[i].toString())));
      }
    });

    return weathers.reversed.toList();
  }

  @override
  List<WeatherModel>? unMarkFavouriteWeather({required WeatherModel weather}) {
    List<WeatherModel>? weathers = [];
    weatherBox.write(() {
      weatherBox.put(weather.request.query.toString(),
          weather.copyWith(isFavourite: false).toJson());
    });
    weatherBox.read(() {
      var keys = weatherBox.keys;
      for (int i = 0; i < keys.length; i++) {
        weathers.add(WeatherModel.fromJson(weatherBox.get(keys[i].toString())));
      }
    });

    return weathers.reversed.toList();
  }

  @override
  List<WeatherModel>? deleteWeather({required WeatherModel weather}) {
    List<WeatherModel>? weathers = [];
    weatherBox.write(() {
      weatherBox.delete(weather.request.query.toString());
    });
    weatherBox.read(() {
      var keys = weatherBox.keys;
      for (int i = 0; i < keys.length; i++) {
        weathers.add(WeatherModel.fromJson(weatherBox.get(keys[i].toString())));
      }
    });

    return weathers.reversed.toList();
  }

  @override
  WeatherModel? loadCurrentLocationWeather(
      {required String latitude, required String longitude}) {
    WeatherModel? weather;
    currentWeatherBox.read(() {
      weather = WeatherModel.fromJson(currentWeatherBox
          .get("current_location_weather", defaultValue: null));
    });

    return weather;
  }

  @override
  void addCurrentLocationWeather({required WeatherModel weather}) {
    currentWeatherBox.write(() {
      currentWeatherBox.put("current_location_weather", weather.toJson());
    });
  }
}
