import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';
import '../widgets/search_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/city_suggestions.dart';
import '../widgets/error_display.dart';
import '../widgets/temperature_unit_toggle.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Create fade-in animation
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    
    // Request city suggestions when the page loads
    context.read<WeatherBloc>().add(CitySuggestionsRequested());
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper method to trigger manual refresh
  Future<void> _refresh(String cityName) async {
    context.read<WeatherBloc>().add(
      WeatherRefreshRequested(city: cityName),
    );
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        centerTitle: true,
        actions: [
          // Add refresh button to app bar
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoadSuccess) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh weather data',
                  onPressed: () {
                    // Trigger refresh indicator programmatically
                    _refreshIndicatorKey.currentState?.show();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Add settings icon for future expansion
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Show a simple dialog with app info
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Weather Forecast'),
                  content: const Text('A beautiful weather app built with Flutter and BLoC pattern.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          WeatherSearchBar(
            onCitySubmitted: (city) {
              context.read<WeatherBloc>().add(WeatherRequested(city: city));
            },
          ),
          // Add temperature unit toggle
          const TemperatureUnitToggle(),
          // Display city suggestions
          const CitySuggestions(),
          Expanded(
            child: Center(
              child: BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  // Reset and start animation when new weather data is loaded
                  if (state is WeatherLoadSuccess) {
                    _animationController.reset();
                    _animationController.forward();
                  }
                },
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return const Text(
                      'Search for a city to see weather information',
                      textAlign: TextAlign.center,
                    );
                  } else if (state is WeatherLoadInProgress) {
                    return const CircularProgressIndicator();
                  } else if (state is WeatherLoadSuccess) {
                    return FadeTransition(
                      opacity: _fadeInAnimation,
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () => _refresh(state.weather.cityName),
                        color: Theme.of(context).colorScheme.primary,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        strokeWidth: 3.0,
                        displacement: 50,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: WeatherCard(
                              weather: state.weather,
                              forecasts: state.forecasts,
                              temperatureUnit: state.temperatureUnit,
                              temperatureValue: state.temperatureInUnit,
                              temperatureSymbol: state.temperatureUnitSymbol,
                              feelsLike: state.feelsLikeInUnit,
                              minTemp: state.minTempInUnit,
                              maxTemp: state.maxTempInUnit,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (state is WeatherLoadFailure) {
                    return ErrorDisplay(
                      message: state.message,
                      onRetry: () {
                        // Try to show weather for a default city or retry last request
                        final previousState = context.read<WeatherBloc>().state;
                        if (previousState is WeatherLoadSuccess) {
                          context.read<WeatherBloc>().add(
                                WeatherRefreshRequested(
                                  city: previousState.weather.cityName,
                                ),
                              );
                        } else {
                          // If no previous successful state, request city suggestions again
                          context.read<WeatherBloc>().add(CitySuggestionsRequested());
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}