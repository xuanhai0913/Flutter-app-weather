import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';

class TemperatureUnitToggle extends StatelessWidget {
  const TemperatureUnitToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUnitToggleButton(
                  context: context,
                  unit: TemperatureUnit.celsius,
                  isSelected: state.temperatureUnit == TemperatureUnit.celsius,
                  label: '°C',
                ),
                SizedBox(width: 4.w),
                _buildUnitToggleButton(
                  context: context,
                  unit: TemperatureUnit.fahrenheit,
                  isSelected: state.temperatureUnit == TemperatureUnit.fahrenheit,
                  label: '°F',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUnitToggleButton({
    required BuildContext context,
    required TemperatureUnit unit,
    required bool isSelected,
    required String label,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<WeatherBloc>().add(TemperatureUnitToggled(unit: unit));
          },
          borderRadius: BorderRadius.circular(25.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected 
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  unit == TemperatureUnit.celsius
                      ? Icons.thermostat
                      : Icons.thermostat_auto,
                  size: 18.sp,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}