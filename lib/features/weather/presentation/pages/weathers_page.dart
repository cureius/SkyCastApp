import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sky_cast/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:sky_cast/core/common/entities/user.dart';
import 'package:sky_cast/core/common/widgets/loader.dart';
import 'package:sky_cast/core/services/location_service.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';
import 'package:sky_cast/core/utils/show_snackbar.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sky_cast/features/weather/presentation/pages/weather_viewer_page.dart';
import 'package:sky_cast/features/weather/presentation/widgets/favourite_carousel_widget.dart';
import 'package:sky_cast/features/weather/presentation/widgets/header_widget.dart';
import 'package:sky_cast/features/weather/presentation/widgets/search_bar.dart';
import 'package:sky_cast/features/weather/presentation/widgets/weather_card.dart';

import 'dart:async';

import 'package:sky_cast/features/weather/presentation/widgets/weather_info_grid.dart';

class WeatherPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const WeatherPage(),
      );

  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final formKey = GlobalKey<FormState>();
  late User userInfo;
  final List<String> cities = [
    "London, UK",
    "New York, USA",
    "Paris, France",
    "Tokyo, Japan",
    "Sydney, Australia"
  ];
  int currentCityIndex = 0;
  late Timer _timer;

  final TextEditingController _queryController = TextEditingController();
  final List<String> _cities = ["New York", "Los Angeles", "Chicago"];
  final int _currentCityIndex = 0;
  String _currentAddress = 'Fetching Address...';
  String _currentStreet = 'Location...';
  Weather? _currentLocationWeather;
  bool _currentLocationWeatherLoading = false;
  List<Weather>? _weathers;

  @override
  void initState() {
    super.initState();
    userInfo = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    context.read<WeatherBloc>().add(FetchAllWeathersEvent());
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentCityIndex = (currentCityIndex + 1) % cities.length;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCurrentLocation(); // Call your async function here
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _queryController.dispose();
    super.dispose();
  }

  getCurrentLocationWeather(latitude, longitude) async {
    context.read<WeatherBloc>().add(GetCurrentLocationWeatherEvent(
        latitude: latitude.toString(), longitude: longitude.toString()));
  }

  Future<void> _getCurrentLocation() async {
    String address = '';
    String street = '';

    try {
      Position position = await LocationService().getCurrentLocation();
      List<Placemark> placeMarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (!mounted) return; // Check if the widget is still mounted

      Placemark place = placeMarks[0];
      await getCurrentLocationWeather(position.latitude, position.longitude);

      address =
          "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      street = "${place.locality?.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ')}, ${place.subLocality}";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (!mounted) return; // Check again if the widget is still mounted
    setState(() {
      _currentAddress = address;
      _currentStreet = street;
    });
  }

  Future<void> _refreshCurrentLocation() async {
    if (!mounted) return;
    setState(() {
      _currentAddress = 'Fetching Address...';
      _currentStreet = 'Location...';
    });
    await _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.gradient1(context),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 120),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                HeaderWidget(
                  currentStreet: _currentStreet,
                  currentAddress: _currentAddress,
                  onShowBottomSheet: (context) {
                    Scaffold.of(context).showBottomSheet(
                      (BuildContext context) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 2.0),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                          ),
                          child: SizedBox(
                            height: 100,
                            width: double.maxFinite,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User Information',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Email: ${userInfo.email}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppPalette.onBackgroundColor(
                                                context)
                                            .withOpacity(1.0)),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SearchBarWidget(
                  queryController: _queryController,
                  onSubmitted: (value) {
                    context
                        .read<WeatherBloc>()
                        .add(SearchCityWeatherEvent(query: value.trim()));
                  },
                  hintTexts: const [
                    "Search for 'Mumbai'",
                    "Search for 'Delhi'",
                    "Search for 'Bengaluru'",
                    "Search for 'Hyderabad'",
                    "Search for 'Chennai'",
                    "Search for 'Kolkata'",
                    "Search for 'Ahmedabad'",
                    "Search for 'Pune'",
                    "Search for 'Jaipur'",
                    "Search for 'Lucknow'"
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  if (state is WeatherFailure) {
                    showSnackBar(context, "Weather not found");
                    _queryController.clear();
                  }
                  if (state is SearchCityWeatherLoadingState) {}
                  if (state is SearchCityWeatherFailureState) {
                    showSnackBar(context, "City not found");
                    _queryController.clear();
                  }
                  if (state is SearchCityWeatherSuccessState) {
                    _queryController.clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WeatherViewerPage(weather: state.weather),
                      ),
                    );
                    setState(() {
                      _weathers?.insert(0, state.weather);
                    });
                  }
                  if (state is GetCurrentLocationWeatherLoadingState) {
                    setState(() {
                      _currentLocationWeatherLoading = false;
                    });
                  }
                  if (state is GetCurrentLocationWeatherFailureState) {
                    showSnackBar(
                        context, "Cannot get current location weather");
                    _queryController.clear();
                    setState(() {
                      _currentLocationWeatherLoading = false;
                    });
                  }
                  if (state is GetCurrentLocationWeatherSuccessState) {
                    setState(() {
                      _currentLocationWeather = state.weather;
                      _currentLocationWeatherLoading = false;
                    });
                  }
                  if (state is WeatherDisplaySuccess) {}
                  if (state is WeathersDisplaySuccess) {
                    setState(() {
                      _weathers = state.weathers;
                    });
                  }
                  if (state is CurrentLocationWeatherDisplaySuccess) {}
                },
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Loader();
                  }
                  if (state is SearchCityWeatherLoadingState) {
                    return const Loader();
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 26.0, left: 16.0, right: 16.0, bottom: 8.0),
                          child: Text(
                            "Favorites",
                            style: TextStyle(
                              fontSize: 32,
                              color: AppPalette.onBackgroundColor(context)
                                  .withAlpha(80),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: Column(
                            children: [
                              FavouriteCarouselWidget(
                                weathers: _weathers,
                                onPageChanged: (index) {
                                  setState(() {
                                    // Handle carousel page change
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 26.0, left: 16.0, right: 16.0, bottom: 8.0),
                          child: Text(
                            "Current Weather",
                            style: TextStyle(
                              fontSize: 32,
                              color: AppPalette.onBackgroundColor(context)
                                  .withAlpha(80),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 0.0),
                          child: Column(
                            children: [
                              WeatherInfoGrid(
                                weather: _currentLocationWeather,
                                loadingState: _currentLocationWeatherLoading,
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 26.0, left: 16.0, right: 16.0, bottom: 8.0),
                          child: Text(
                            "History",
                            style: TextStyle(
                              fontSize: 32,
                              color: AppPalette.onBackgroundColor(context)
                                  .withAlpha(80),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      (_weathers == null || _weathers!.isEmpty)
                          ? SliverToBoxAdapter(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.history,
                                          size: 80,
                                          color: AppPalette.onBackgroundColor(
                                                  context)
                                              .withOpacity(0.4)),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No previous searches',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: AppPalette.onBackgroundColor(
                                                    context)
                                                .withOpacity(0.8)),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Your search history will appear here.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppPalette.onBackgroundColor(
                                                    context)
                                                .withOpacity(0.4)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final weather = _weathers?[index];
                                  if (weather == null) return const SizedBox();
                                  return WeatherCard(
                                    weather: weather,
                                    color: index % 2 == 0
                                        ? AppPalette.cardColor(context)
                                        : AppPalette.cardColor(context),
                                  );
                                },
                                childCount: _weathers?.length,
                              ),
                            ),
                      SliverToBoxAdapter(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 16.0),
                            child: const SizedBox(height: 46.0, width: 0.0)),
                      ),
                    ],
                  );

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _refreshCurrentLocation(); // Fetch location on FAB press
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.refresh_rounded),
      ),
    );
  }
}
