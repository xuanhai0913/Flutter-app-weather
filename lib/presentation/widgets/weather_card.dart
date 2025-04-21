import 'package:flutter/material.dart';
import '../../data/models/weather.dart';
import '../../data/models/forecast.dart';
import '../../bloc/weather_event.dart';
import 'forecast_list.dart';
import 'weather_details_card.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;
  final List<Forecast>? forecasts;
  final TemperatureUnit temperatureUnit;
  final double temperatureValue;
  final String temperatureSymbol;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;

  const WeatherCard({
    super.key, 
    required this.weather,
    this.forecasts,
    this.temperatureUnit = TemperatureUnit.celsius,
    this.temperatureValue = 0,
    this.temperatureSymbol = '°C',
    this.feelsLike = 0,
    this.minTemp = 0,
    this.maxTemp = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weather.cityName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${temperatureValue.toStringAsFixed(1)}$temperatureSymbol',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Use network image instead of icon
                    Image.network(
                      weather.iconUrl,
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return _getWeatherIcon(weather.condition);
                      },
                    ),
                  ],
                ),
                Text(
                  weather.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Add detailed weather information card
        WeatherDetailsCard(
          windSpeed: weather.windSpeed,
          humidity: weather.humidity,
          feelsLike: feelsLike,
          minTemp: minTemp,
          maxTemp: maxTemp,
          temperatureSymbol: temperatureSymbol,
        ),
        
        // Show forecast if available
        if (forecasts != null && forecasts!.isNotEmpty)
          ForecastList(
            forecasts: forecasts!,
            temperatureUnit: temperatureUnit,
          ),
      ],
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _getWeatherIcon(String condition) {
    IconData iconData;
    Color color;

    switch (condition.toLowerCase()) {
      case 'clear':
        iconData = Icons.wb_sunny;
        color = Colors.amber;
        break;
      case 'clouds':
        iconData = Icons.cloud;
        color = Colors.blueGrey;
        break;
      case 'rain':
        iconData = Icons.grain;
        color = Colors.blue;
        break;
      case 'thunderstorm':
        iconData = Icons.flash_on;
        color = Colors.deepPurple;
        break;
      case 'snow':
        iconData = Icons.ac_unit;
        color = Colors.lightBlue;
        break;
      case 'drizzle':
        iconData = Icons.water_drop;
        color = Colors.lightBlue;
        break;
      case 'mist':
      case 'fog':
      case 'haze':
        iconData = Icons.water;
        color = Colors.grey;
        break;
      default:
        iconData = Icons.cloud;
        color = Colors.grey;
    }

    return Icon(
      iconData,
      size: 36,
      color: color,
    );
  }
}