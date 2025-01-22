import 'package:sky_cast/core/common/widgets/loader.dart';
import 'package:sky_cast/core/theme/app_pallete.dart';
import 'package:sky_cast/core/utils/show_snackbar.dart';
import 'package:sky_cast/features/weather/data/models/weather_model.dart';
import 'package:sky_cast/features/weather/domain/entities/weather.dart';
import 'package:sky_cast/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:sky_cast/features/weather/presentation/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const FavoritePage(),
      );

  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final queryController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Weather> _weathers = [];

  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(FetchAllWeathersEvent());
    final weatherState = context.read<WeatherBloc>().state;
    if (weatherState is! WeathersDisplaySuccess) {
      context.read<WeatherBloc>().add(FetchAllWeathersEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: TextStyle(
            fontSize: 32,
            color: AppPalette.onBackgroundColor(context).withAlpha(80),
            fontWeight: FontWeight.bold,
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
                    showSnackBar(context, state.error);
                  } else if (state is WeathersDisplaySuccess) {
                    setState(() {
                      _weathers = state.weathers;
                    });
                  } else if (state is MakeWeatherFavouriteDisplaySuccess) {
                    setState(() {
                      _weathers = state.weathers;
                    });
                  } else if (state is MakeWeatherUnFavouriteDisplaySuccess) {
                    setState(() {
                      _weathers = state.weathers;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is WeatherLoading) {
                    return const Loader();
                  }
                  final favoriteWeathers = _weathers.where((weather) {
                    if (weather is WeatherModel) {
                      return weather.isFavourite;
                    }
                    return false;
                  }).toList();

                  if (favoriteWeathers.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite_border,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No favorite items yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add your favorite cities to see them here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final weather = favoriteWeathers[index];
                            return WeatherCard(
                              weather: weather,
                              color: index % 2 == 0
                                  ? AppPalette.cardColor(context)
                                  : AppPalette.cardColor(context),
                            );
                          },
                          childCount: favoriteWeathers.length,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
