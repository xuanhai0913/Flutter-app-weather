import 'package:flutter/material.dart';
import '../../data/models/forecast.dart';
import '../../bloc/weather_event.dart';

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;
  final TemperatureUnit temperatureUnit;

  const ForecastList({
    super.key,
    required this.forecasts,
    this.temperatureUnit = TemperatureUnit.celsius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Text(
            '5-Day Forecast',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              final temperature = temperatureUnit == TemperatureUnit.celsius
                  ? forecast.temperature
                  : (forecast.temperature * 9 / 5) + 32;
              final symbol = temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';
              
              return Card(
                margin: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: index == forecasts.length - 1 ? 16.0 : 8.0,
                  bottom: 8.0,
                ),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        forecast.dayOfWeek,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Image.network(
                        forecast.iconUrl,
                        width: 50,
                        height: 50,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.cloud,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${temperature.toStringAsFixed(1)}$symbol',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        forecast.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}