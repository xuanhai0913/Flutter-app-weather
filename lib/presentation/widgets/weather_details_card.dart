import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withBlue(theme.colorScheme.surface.blue + 15),
                  ]
                : [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withBlue(theme.colorScheme.surface.blue + 5),
                  ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.insights,
                      size: 20.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Weather Details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            // Detail grid with animations
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16.h,
              crossAxisSpacing: 16.w,
              childAspectRatio: 2.0,
              children: [
                _buildAnimatedDetailItem(
                  context,
                  Icons.air,
                  'Wind Speed',
                  '$windSpeed m/s',
                  delay: 100,
                ),
                _buildAnimatedDetailItem(
                  context,
                  Icons.water_drop,
                  'Humidity',
                  '$humidity%',
                  delay: 200,
                ),
                _buildAnimatedDetailItem(
                  context,
                  Icons.thermostat,
                  'Feels Like',
                  '${feelsLike.toStringAsFixed(1)}$temperatureSymbol',
                  delay: 300,
                ),
                _buildAnimatedDetailItem(
                  context,
                  Icons.device_thermostat,
                  'Min/Max',
                  '${minTemp.toStringAsFixed(0)}$temperatureSymbol / ${maxTemp.toStringAsFixed(0)}$temperatureSymbol',
                  delay: 400,
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Temperature comparison
            _buildTemperatureChart(context),
            
            SizedBox(height: 8.h),
            
            // Information about units
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14.sp,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Temperature unit: $temperatureSymbol',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    required int delay,
  }) {
    final theme = Theme.of(context);
    
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + delay),
      curve: Curves.easeOutQuad,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      icon,
                      color: theme.colorScheme.primary,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTemperatureChart(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width - 64.w;
    final chartHeight = 40.h;
    
    // Calculate positions based on min, current, and max temperatures
    final minPosition = 0.0;
    final maxPosition = width;
    final currentPosition = ((feelsLike - minTemp) / (maxTemp - minTemp)) * width;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature Range',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: chartHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.red,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Min temperature marker
              Positioned(
                left: minPosition,
                top: 0,
                bottom: 0,
                child: _buildTemperatureMarker(
                  context,
                  '${minTemp.toStringAsFixed(0)}$temperatureSymbol',
                  Colors.blue,
                ),
              ),
              
              // Current temperature marker
              Positioned(
                left: currentPosition.clamp(20.0, width - 20.0),
                top: 0,
                bottom: 0,
                child: _buildTemperatureMarker(
                  context,
                  '${feelsLike.toStringAsFixed(1)}$temperatureSymbol',
                  theme.colorScheme.primary,
                  isFeelsLike: true,
                ),
              ),
              
              // Max temperature marker
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: _buildTemperatureMarker(
                  context,
                  '${maxTemp.toStringAsFixed(0)}$temperatureSymbol',
                  Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTemperatureMarker(
    BuildContext context,
    String temperature,
    Color color, {
    bool isFeelsLike = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isFeelsLike)
          Transform.translate(
            offset: Offset(0, -24.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Feels like',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        else
          const SizedBox(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            temperature,
            style: TextStyle(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: 3.w,
          height: isFeelsLike ? 20.h : 10.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}