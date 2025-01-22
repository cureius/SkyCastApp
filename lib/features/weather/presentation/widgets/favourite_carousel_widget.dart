import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';
import 'package:sky_cast/features/weather/data/models/weather_model.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/presentation/pages/weather_viewer_page.dart';

class FavouriteCarouselWidget extends StatefulWidget {
  final List<Weather>? weathers;
  final Function(int) onPageChanged;

  const FavouriteCarouselWidget({
    super.key,
    required this.weathers,
    required this.onPageChanged,
  });

  @override
  State<FavouriteCarouselWidget> createState() =>
      _FavouriteCarouselWidgetState();
}

class _FavouriteCarouselWidgetState extends State<FavouriteCarouselWidget> {
  int _currentCarouselIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Weather>? listOfFavouriteWeathers = widget.weathers?.where((weather) {
      if (weather is WeatherModel) {
        return weather.isFavourite;
      }
      return false;
    }).toList();
    if (listOfFavouriteWeathers == null || listOfFavouriteWeathers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppPalette.onBackgroundColor(context).withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No favorite items yet',
              style: TextStyle(
                  fontSize: 18,
                  color:
                      AppPalette.onBackgroundColor(context).withOpacity(0.8)),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your favorite cities to see them here.',
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

    return Column(
      children: [
        listOfFavouriteWeathers.isNotEmpty
            ? CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselIndex = index;
                      widget.onPageChanged(index);
                    });
                  },
                ),
                items: listOfFavouriteWeathers.map<Widget>((weatherData) {
                  return buildWeatherCard(weatherData as WeatherModel);
                }).toList(),
              )
            : Container(),
        const SizedBox(height: 10, width: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              widget.weathers
                      ?.where((weather) {
                        if (weather is WeatherModel) {
                          return weather.isFavourite;
                        }
                        return false;
                      })
                      .toList()
                      .length ??
                  0,
              (index) => index).map((index) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentCarouselIndex == index
                    ? Colors.blue
                    : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildWeatherCard(WeatherModel weatherData) {
    final location = weatherData.location;
    final current = weatherData.current;

    String cityName = location.name;
    String country = location.country;
    String region = location.region;
    String localtime = location.localtime;
    double temperature = current.temperature.toDouble() ?? 0.0;
    String weatherDescription = current.weatherDescriptions[0] ?? '';
    String weatherIcon = current.weatherIcons[0] ?? '';
    int windSpeed = current.windSpeed ?? 0;
    int humidity = current.humidity ?? 0;
    double visibility = current.visibility.toDouble() ?? 0.0;

    return SizedBox(
      height: 185, // Fixed height
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, WeatherViewerPage.route(weatherData));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppPalette.cardColor(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppPalette.cardColor(context).withAlpha(100),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Location and Icon
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                                color: AppPalette.gradient3(context),
                                Icons.favorite),
                            const SizedBox(width: 2),
                            Flexible(
                              child: Text(
                                '$cityName, $country',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap:
                                    false, // Optional: Prevents wrapping to the next line
                              ),
                            ),
                            // Change the color to fit your theme
                          ],
                        ),
                        Text(
                          '$region • $localtime',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8, height: 0),
                  // Weather Icon
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    // Apply the same border radius to the image
                    child: CachedNetworkImage(
                      imageUrl: weatherIcon,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Weather Description and Temperature
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: AppPalette.borderColor(context),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      child: Text(
                        weatherDescription,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
              const Spacer(),
              // Bottom Row: Wind, Humidity, Visibility
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildWeatherDetail(Icons.air, 'Wind', '$windSpeed km/h'),
                  _buildWeatherDetail(
                      Icons.water_drop, 'Humidity', '$humidity%'),
                  _buildWeatherDetail(Icons.visibility, 'Visibility',
                      '${visibility.toStringAsFixed(1)} km'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
