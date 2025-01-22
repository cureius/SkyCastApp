import 'dart:convert';
import 'package:sky_cast/core/error/exceptions.dart';
import 'package:sky_cast/core/secrets/app_secrets.dart';
import 'package:sky_cast/features/weather/data/models/weather_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

abstract interface class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather({required String query});

  Future<WeatherModel> getCurrentLocationWeather(
      {required String latitude, required String longitude});
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final SupabaseClient supabaseClient;

  WeatherRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<WeatherModel> getWeather({required String query}) async {
    const String apiKey = AppSecrets.weatherstackApiKey;
    final String url =
        '${AppSecrets.weatherstackBaseUrl}current?access_key=$apiKey&query=$query';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        WeatherModel weather = WeatherModel.fromJson(jsonData);

        return weather;
      } else {
        throw const ServerException("Request Failed");
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<WeatherModel> getCurrentLocationWeather(
      {required String latitude, required String longitude}) async {
    final query = '$latitude,$longitude';
    const String apiKey = AppSecrets.weatherstackApiKey;
    final String url =
        '${AppSecrets.weatherstackBaseUrl}current?access_key=$apiKey&query=$query';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        WeatherModel weather = WeatherModel.fromJson(jsonData);

        return weather;
      } else {
        throw const ServerException("Request Failed");
      }
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
