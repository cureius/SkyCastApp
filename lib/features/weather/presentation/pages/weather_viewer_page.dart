import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sky_cast/core/common/pages/root_screen.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/presentation/bloc/weather_bloc.dart';

class WeatherViewerPage extends StatefulWidget {
  static route(Weather weather) => MaterialPageRoute(
        builder: (context) => WeatherViewerPage(
          weather: weather,
        ),
      );
  final Weather weather;

  const WeatherViewerPage({
    super.key,
    required this.weather,
  });

  @override
  State<WeatherViewerPage> createState() => _WeatherViewerPageState();
}

class _WeatherViewerPageState extends State<WeatherViewerPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.weather.isFavourite;
  }

  void _toggleFavorite(BuildContext context, Weather weather) {
    if (_isFavorite) {
      context.read<WeatherBloc>().add(MakeWeatherUnFavourite(weather: weather));
    } else {
      context.read<WeatherBloc>().add(MakeWeatherFavourite(weather: weather));
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _deleteWeather(BuildContext context, Weather weather) {
    context.read<WeatherBloc>().add(DeleteWeatherEvent(weather: weather));
    Navigator.pushAndRemoveUntil(
      context,
      RootScreen.route(),
      (route) => false,
    );
  }

  void _refreshData() {
    if (widget.weather.request.type == 'City') {
      context
          .read<WeatherBloc>()
          .add(FetchWeatherEvent(query: widget.weather.request.query));
    } else if (widget.weather.request.type == 'LatLon') {
      context.read<WeatherBloc>().add(FetchWeatherByCoordinatesEvent(
          longitude: widget.weather.location.lon,
          latitude: widget.weather.location.lat));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.cardColor(context),
        title: const Text("Weather Details"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: (() => {
                  _deleteWeather(context, widget.weather),
                }),
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: (() => {
                  _toggleFavorite(context, widget.weather),
                }),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCityWeatherHeader(),
                const SizedBox(height: 20),
                _buildWeatherDetails(),
                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityWeatherHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.weather.location.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${widget.weather.location.name}, ${widget.weather.location.region}, ${widget.weather.location.country}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Weather: ${widget.weather.current.weatherDescriptions[0]}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 0, width: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          // Apply the same border radius to the image
          child: CachedNetworkImage(
            imageUrl: widget.weather.current.weatherIcons[0],
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        )
      ],
    );
  }

  Widget _buildWeatherDetails() {
    final weatherDetails = [
      {
        'label': 'Temperature',
        'value': '${widget.weather.current.temperature}°C',
        'icon': Icons.thermostat
      },
      {
        'label': 'Wind Speed',
        'value': '${widget.weather.current.windSpeed} km/h',
        'icon': Icons.air
      },
      {
        'label': 'Wind Direction',
        'value': widget.weather.current.windDir,
        'icon': Icons.navigation
      },
      {
        'label': 'Humidity',
        'value': '${widget.weather.current.humidity}%',
        'icon': Icons.water_drop
      },
      {
        'label': 'Pressure',
        'value': '${widget.weather.current.pressure} hPa',
        'icon': Icons.filter_drama
      },
      {
        'label': 'Feels Like',
        'value': '${widget.weather.current.feelslike}°C',
        'icon': Icons.ac_unit
      },
      {
        'label': 'Visibility',
        'value': '${widget.weather.current.visibility} km',
        'icon': Icons.visibility
      },
      {
        'label': 'UV Index',
        'value': '${widget.weather.current.uvIndex}',
        'icon': Icons.wb_sunny
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: weatherDetails.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  weatherDetails[index]['icon'] as IconData,
                  size: 36,
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Text(
                  weatherDetails[index]['label'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  weatherDetails[index]['value'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Last Updated: ${(widget.weather.current.observationTime)}',
          style: const TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}