import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 8.h),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                '5-Day Forecast',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecasts.length,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemBuilder: (context, index) {
              final forecast = forecasts[index];
              final temperature = temperatureUnit == TemperatureUnit.celsius
                  ? forecast.temperature
                  : (forecast.temperature * 9 / 5) + 32;
              final symbol = temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';
              
              return Container(
                width: 130.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: _getGradientColors(forecast.temperature, isDarkMode),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Day of week
                        Text(
                          forecast.dayOfWeek,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        
                        // Weather icon
                        Image.network(
                          forecast.iconUrl,
                          width: 60.w,
                          height: 60.h,
                          errorBuilder: (_, __, ___) => Icon(
                            _getWeatherIcon(forecast.description),
                            size: 40.sp,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        
                        // Temperature
                        Text(
                          '${temperature.toStringAsFixed(1)}$symbol',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        
                        // Description
                        Text(
                          forecast.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        
                        // Wind speed
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.air,
                              size: 14.sp,
                              color: isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${forecast.windSpeed.toStringAsFixed(1)} m/s',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  // Helper method to get appropriate gradient colors based on temperature
  List<Color> _getGradientColors(double temperature, bool isDarkMode) {
    if (temperature < 0) {
      return isDarkMode
          ? [Colors.blue[900]!, Colors.blue[700]!]
          : [Colors.blue[100]!, Colors.blue[300]!];
    } else if (temperature < 10) {
      return isDarkMode
          ? [Colors.lightBlue[900]!, Colors.lightBlue[700]!]
          : [Colors.lightBlue[100]!, Colors.lightBlue[300]!];
    } else if (temperature < 20) {
      return isDarkMode
          ? [Colors.teal[900]!, Colors.teal[700]!]
          : [Colors.teal[100]!, Colors.teal[300]!];
    } else if (temperature < 30) {
      return isDarkMode
          ? [Colors.orange[900]!, Colors.orange[700]!]
          : [Colors.orange[100]!, Colors.orange[300]!];
    } else {
      return isDarkMode
          ? [Colors.red[900]!, Colors.red[700]!]
          : [Colors.red[100]!, Colors.red[300]!];
    }
  }
  
  // Helper method to get appropriate weather icon
  IconData _getWeatherIcon(String description) {
    final lowerDesc = description.toLowerCase();
    
    if (lowerDesc.contains('clear') || lowerDesc.contains('sun')) {
      return Icons.wb_sunny;
    } else if (lowerDesc.contains('cloud')) {
      return Icons.cloud;
    } else if (lowerDesc.contains('rain') || lowerDesc.contains('drizzle')) {
      return Icons.grain;
    } else if (lowerDesc.contains('thunder') || lowerDesc.contains('storm')) {
      return Icons.flash_on;
    } else if (lowerDesc.contains('snow')) {
      return Icons.ac_unit;
    } else if (lowerDesc.contains('mist') || lowerDesc.contains('fog') || lowerDesc.contains('haze')) {
      return Icons.water;
    } else {
      return Icons.cloud;
    }
  }
}