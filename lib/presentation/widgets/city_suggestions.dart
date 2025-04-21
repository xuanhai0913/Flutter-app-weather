import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';
import '../../data/services/location_service.dart';

class CitySuggestions extends StatelessWidget {
  const CitySuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suggested Cities:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is CitySuggestionsLoadInProgress) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is CitySuggestionsLoadSuccess) {
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: state.suggestions.map((city) {
                    return ActionChip(
                      label: Text(city),
                      avatar: const Icon(Icons.location_city, size: 16),
                      onPressed: () {
                        context.read<WeatherBloc>().add(WeatherRequested(city: city));
                      },
                    );
                  }).toList(),
                );
              } else if (state is CitySuggestionsLoadFailure) {
                return Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.my_location),
            label: const Text('Use My Location'),
            onPressed: () async {
              try {
                final locationService = LocationService();
                final position = await locationService.getCurrentLocation();
                
                if (context.mounted) {
                  context.read<WeatherBloc>().add(
                    WeatherRequestedByLocation(
                      latitude: position.latitude,
                      longitude: position.longitude,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error getting location: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}