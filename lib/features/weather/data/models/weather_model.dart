import 'package:sky_cast/features/weather/domain/entities/weather.dart';

class RequestModel extends Request {
  RequestModel({
    required super.type,
    required super.query,
    required super.language,
    required super.unit,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type,
      'query': query,
      'language': language,
      'unit': unit,
    };
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      type: json['type'] as String,
      query: json['query'] as String,
      language: json['language'] as String,
      unit: json['unit'] as String,
    );
  }

  RequestModel copyWith({
    String? type,
    String? query,
    String? language,
    String? unit,
  }) {
    return RequestModel(
      type: type ?? this.type,
      query: query ?? this.query,
      language: language ?? this.language,
      unit: unit ?? this.unit,
    );
  }
}

class LocationModel extends Location {
  LocationModel({
    required super.name,
    required super.country,
    required super.region,
    required super.lat,
    required super.lon,
    required super.timezoneId,
    required super.localtime,
    required super.localtimeEpoch,
    required super.utcOffset,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'country': country,
      'region': region,
      'lat': lat,
      'lon': lon,
      'timezone_id': timezoneId,
      'localtime': localtime,
      'localtime_epoch': localtimeEpoch,
      'utc_offset': utcOffset,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String,
      country: json['country'] as String,
      region: json['region'] as String,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
      timezoneId: json['timezone_id'] as String,
      localtime: json['localtime'] as String,
      localtimeEpoch: json['localtime_epoch'] as int,
      utcOffset: json['utc_offset'] as String,
    );
  }

  LocationModel copyWith({
    String? name,
    String? country,
    String? region,
    String? lat,
    String? lon,
    String? timezoneId,
    String? localtime,
    int? localtimeEpoch,
    String? utcOffset,
  }) {
    return LocationModel(
      name: name ?? this.name,
      country: country ?? this.country,
      region: region ?? this.region,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      timezoneId: timezoneId ?? this.timezoneId,
      localtime: localtime ?? this.localtime,
      localtimeEpoch: localtimeEpoch ?? this.localtimeEpoch,
      utcOffset: utcOffset ?? this.utcOffset,
    );
  }
}

class CurrentWeatherModel extends CurrentWeather {
  CurrentWeatherModel({
    required super.observationTime,
    required super.temperature,
    required super.weatherCode,
    required super.weatherIcons,
    required super.weatherDescriptions,
    required super.windSpeed,
    required super.windDegree,
    required super.windDir,
    required super.pressure,
    required super.precip,
    required super.humidity,
    required super.cloudcover,
    required super.feelslike,
    required super.uvIndex,
    required super.visibility,
    required super.isDay,
  });

  Map<String, dynamic> toJson() {
    return {
      'observation_time': observationTime,
      'temperature': temperature,
      'weather_code': weatherCode,
      'weather_icons': weatherIcons,
      'weather_descriptions': weatherDescriptions,
      'wind_speed': windSpeed,
      'wind_degree': windDegree,
      'wind_dir': windDir,
      'pressure': pressure,
      'precip': precip,
      'humidity': humidity,
      'cloudcover': cloudcover,
      'feelslike': feelslike,
      'uv_index': uvIndex,
      'visibility': visibility,
      'is_day': isDay,
    };
  }

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      observationTime: json['observation_time'] as String,
      temperature: json['temperature'] as int,
      weatherCode: json['weather_code'] as int,
      weatherIcons: List<String>.from(json['weather_icons'] ?? []),
      weatherDescriptions:
          List<String>.from(json['weather_descriptions'] ?? []),
      windSpeed: json['wind_speed'] as int,
      windDegree: json['wind_degree'] as int,
      windDir: json['wind_dir'] as String,
      pressure: json['pressure'] as int,
      precip: json['precip'] as int,
      humidity: json['humidity'] as int,
      cloudcover: json['cloudcover'] as int,
      feelslike: json['feelslike'] as int,
      uvIndex: json['uv_index'] as int,
      visibility: json['visibility'] as int,
      isDay: json['is_day'] as String,
    );
  }

  CurrentWeatherModel copyWith({
    String? observationTime,
    int? temperature,
    int? weatherCode,
    List<String>? weatherIcons,
    List<String>? weatherDescriptions,
    int? windSpeed,
    int? windDegree,
    String? windDir,
    int? pressure,
    int? precip,
    int? humidity,
    int? cloudcover,
    int? feelslike,
    int? uvIndex,
    int? visibility,
    String? isDay,
  }) {
    return CurrentWeatherModel(
      observationTime: observationTime ?? this.observationTime,
      temperature: temperature ?? this.temperature,
      weatherCode: weatherCode ?? this.weatherCode,
      weatherIcons: weatherIcons ?? this.weatherIcons,
      weatherDescriptions: weatherDescriptions ?? this.weatherDescriptions,
      windSpeed: windSpeed ?? this.windSpeed,
      windDegree: windDegree ?? this.windDegree,
      windDir: windDir ?? this.windDir,
      pressure: pressure ?? this.pressure,
      precip: precip ?? this.precip,
      humidity: humidity ?? this.humidity,
      cloudcover: cloudcover ?? this.cloudcover,
      feelslike: feelslike ?? this.feelslike,
      uvIndex: uvIndex ?? this.uvIndex,
      visibility: visibility ?? this.visibility,
      isDay: isDay ?? this.isDay,
    );
  }
}

class WeatherModel extends Weather {
  WeatherModel({
    required super.request,
    required super.location,
    required super.current,
    super.isFavourite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'request': (request as RequestModel).toJson(),
      'location': (location as LocationModel).toJson(),
      'current': (current as CurrentWeatherModel).toJson(),
      'is_favourite': isFavourite,
    };
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      request: RequestModel.fromJson(json['request']),
      location: LocationModel.fromJson(json['location']),
      current: CurrentWeatherModel.fromJson(json['current']),
      isFavourite: json['is_favourite'] as bool? ?? false,
    );
  }

  WeatherModel copyWith({
    Request? request,
    Location? location,
    CurrentWeather? current,
    bool? isFavourite,
  }) {
    return WeatherModel(
      request: request ?? this.request,
      location: location ?? this.location,
      current: current ?? this.current,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
