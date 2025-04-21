import 'package:flutter/material.dart';

class WeatherDetailsCard extends StatelessWidget {
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final String temperatureSymbol;

  const WeatherDetailsCard({
    super.key,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    this.temperatureSymbol = '°C',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weather Details',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Show the current temperature unit
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Unit: $temperatureSymbol',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDetailItem(
                  context,
                  Icons.air,
                  'Wind',
                  '$windSpeed m/s',
                ),
                _buildDetailItem(
                  context,
                  Icons.water_drop,
                  'Humidity',
                  '$humidity%',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildDetailItem(
                  context,
                  Icons.thermostat,
                  'Feels Like',
                  '${feelsLike.toStringAsFixed(1)}$temperatureSymbol',
                ),
                _buildDetailItem(
                  context,
                  Icons.device_thermostat,
                  'Min/Max',
                  '${minTemp.toStringAsFixed(1)}$temperatureSymbol / ${maxTemp.toStringAsFixed(1)}$temperatureSymbol',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}