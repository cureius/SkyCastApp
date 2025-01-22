
import 'package:sky_cast/core/common/pages/root_screen.dart';
import 'package:sky_cast/core/common/widgets/loader.dart';
import 'package:sky_cast/core/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sky_cast/features/weather/presentation/bloc/weather_bloc.dart';
import 'dart:developer' as developer;

import 'package:sky_cast/features/weather/presentation/widgets/query_editor.dart';

class AddNewCityWeatherPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewCityWeatherPage(),
      );

  const AddNewCityWeatherPage({super.key});

  @override
  State<AddNewCityWeatherPage> createState() => _AddNewWeatherPageState();
}

class _AddNewWeatherPageState extends State<AddNewCityWeatherPage> {
  final queryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void searchCityWeather() {
    if (formKey.currentState!.validate()) {
      context.read<WeatherBloc>().add(FetchWeatherEvent(query: queryController.text.trim()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    queryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              searchCityWeather();
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherFailure) {
            showSnackBar(context, state.error);
          } else if (state is WeatherDisplaySuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              RootScreen.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is WeatherLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    QueryEditor(
                      controller: queryController,
                      hintText: 'Search City',
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
