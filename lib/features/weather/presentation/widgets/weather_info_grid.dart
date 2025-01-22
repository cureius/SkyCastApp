import 'package:flutter/material.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';
import 'package:sky_cast/features/weather/data/models/weather_model.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';

class WeatherInfoGrid extends StatelessWidget {
  final Weather? weather;
  final bool? loadingState;

  const WeatherInfoGrid({super.key, this.weather, this.loadingState});

  @override
  Widget build(BuildContext context) {
    if (weather == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline,
                size: 80,
                color: AppPalette.onBackgroundColor(context).withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              'No weather information available',
              style: TextStyle(
                  fontSize: 18,
                  color:
                      AppPalette.onBackgroundColor(context).withOpacity(0.8)),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color:
                      AppPalette.onBackgroundColor(context).withOpacity(0.4)),
            ),
          ],
        ),
      );
    }

    final weatherDetails = [
      ['Temperature', '${weather?.current.temperature}°C', Icons.thermostat],
      ['Wind Speed', '${weather?.current.windSpeed} km/h', Icons.air],
      ['Wind Direction', weather?.current.windDir, Icons.navigation],
      ['UV Index', weather?.current.uvIndex.toString(), Icons.wb_sunny],
      ['Humidity', '${weather?.current.humidity}%', Icons.water_drop],
      ['Pressure', '${weather?.current.pressure} hPa', Icons.filter_drama],
      ['Feels Like', '${weather?.current.feelslike}°C', Icons.ac_unit],
      ['Visibility', '${weather?.current.visibility} km', Icons.visibility],
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.7,
              mainAxisSpacing: 2,
              crossAxisSpacing: 16,
            ),
            itemCount: weatherDetails.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          AppPalette.backgroundColor(context).withOpacity(0.6),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppPalette.onBackgroundColor(context)
                            .withOpacity(0.1),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.backgroundColor(context)
                              .withOpacity(0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      weatherDetails[index][2] as IconData,
                      size: 24,
                      color: AppPalette.gradient1(context)
                          .withOpacity(1.0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherDetails[index][0] as String,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  (loadingState == true)
                      ? const CircularProgressIndicator()
                      : Text(
                          weatherDetails[index][1] as String,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
