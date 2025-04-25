import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        // Main weather card with hero animation for transitions
        Hero(
          tag: 'weather_card_${weather.cityName}',
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 20.sp,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: 4.w),
                      Flexible(
                        child: Text(
                          weather.cityName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temperatureValue.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w500,
                          color: _getTemperatureColor(temperatureValue, isDarkMode),
                        ),
                      ),
                      Text(
                        temperatureSymbol,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: _getTemperatureColor(temperatureValue, isDarkMode),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Weather condition icon
                      Image.network(
                        weather.iconUrl,
                        width: 60.w,
                        height: 60.h,
                        errorBuilder: (context, error, stackTrace) {
                          return _getWeatherIcon(weather.condition);
                        },
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.condition,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            weather.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Temperature range
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWeatherDetail(
                        context,
                        'Min',
                        '${minTemp.toStringAsFixed(0)}$temperatureSymbol',
                        Icons.arrow_downward,
                      ),
                      SizedBox(width: 24.w),
                      _buildWeatherDetail(
                        context,
                        'Current',
                        '${temperatureValue.toStringAsFixed(0)}$temperatureSymbol',
                        Icons.thermostat,
                      ),
                      SizedBox(width: 24.w),
                      _buildWeatherDetail(
                        context,
                        'Max',
                        '${maxTemp.toStringAsFixed(0)}$temperatureSymbol',
                        Icons.arrow_upward,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Date and time of last update
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _formatDateTime(DateTime.now()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Add detailed weather information card
        WeatherDetailsCard(
          windSpeed: weather.windSpeed,
          humidity: weather.humidity,
          feelsLike: feelsLike,
          minTemp: minTemp,
          maxTemp: maxTemp,
          temperatureSymbol: temperatureSymbol,
        ),
        
        SizedBox(height: 16.h),
        
        // Show forecast if available
        if (forecasts != null && forecasts!.isNotEmpty)
          ForecastList(
            forecasts: forecasts!,
            temperatureUnit: temperatureUnit,
          ),
      ],
    );
  }

  Widget _buildWeatherDetail(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: theme.colorScheme.secondary,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
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
      size: 36.sp,
      color: color,
    );
  }
  
  // Get color based on temperature
  Color _getTemperatureColor(double temp, bool isDarkMode) {
    if (temp < 0) {
      return isDarkMode ? Colors.lightBlue[200]! : Colors.lightBlue;
    } else if (temp < 10) {
      return isDarkMode ? Colors.blue[200]! : Colors.blue;
    } else if (temp < 20) {
      return isDarkMode ? Colors.green[200]! : Colors.green;
    } else if (temp < 30) {
      return isDarkMode ? Colors.orange[300]! : Colors.orange;
    } else {
      return isDarkMode ? Colors.red[300]! : Colors.red;
    }
  }
  
  // Format date and time
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    String dayText;
    if (date == today) {
      dayText = 'Today';
    } else if (date == today.subtract(const Duration(days: 1))) {
      dayText = 'Yesterday';
    } else {
      dayText = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
    
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$dayText, $hour:$minute';
  }
}