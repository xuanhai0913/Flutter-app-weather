import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';

class TemperatureUnitToggle extends StatelessWidget {
  const TemperatureUnitToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Unit:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              _buildUnitToggleButton(
                context: context,
                unit: TemperatureUnit.celsius,
                isSelected: state.temperatureUnit == TemperatureUnit.celsius,
                label: '°C',
              ),
              const SizedBox(width: 8),
              _buildUnitToggleButton(
                context: context,
                unit: TemperatureUnit.fahrenheit,
                isSelected: state.temperatureUnit == TemperatureUnit.fahrenheit,
                label: '°F',
              ),
            ],
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
    
    return InkWell(
      onTap: () {
        context.read<WeatherBloc>().add(TemperatureUnitToggled(unit: unit));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
                ? theme.colorScheme.onPrimary 
                : theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}