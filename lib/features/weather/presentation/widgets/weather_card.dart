import 'package:flutter/material.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:intl/intl.dart';
import 'package:sky_cast/features/weather/presentation/pages/weather_viewer_page.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final Color color;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, WeatherViewerPage.route(weather));
      },
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      weather.location.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    weather.isFavourite
                        ? Icon(color: AppPalette.gradient3(context), Icons.favorite)
                        : const SizedBox(width: 0, height: 0),
                  ],
                ),
                const SizedBox(height: 10, width: 0),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: weather.current.weatherDescriptions
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Chip(label: Text(e.toUpperCase())),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${weather.current.temperature}°C',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.air, size: 16),
                        const SizedBox(width: 5),
                        Text('${weather.current.windSpeed} km/h'),
                      ],
                    ),
                    const SizedBox(width: 10, height: 10),
                    Row(
                      children: [
                        const Icon(Icons.water_drop, size: 16),
                        const SizedBox(width: 5),
                        Text('${weather.current.humidity}%'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'Last Updated: ${weather.current.observationTime}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
