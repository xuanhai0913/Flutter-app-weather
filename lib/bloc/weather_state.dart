import 'package:equatable/equatable.dart';
import '../data/models/weather.dart';
import '../data/models/forecast.dart';
import 'weather_event.dart';

abstract class WeatherState extends Equatable {
  final TemperatureUnit temperatureUnit;
  
  const WeatherState({
    this.temperatureUnit = TemperatureUnit.celsius,
  });
  
  @override
  List<Object> get props => [temperatureUnit];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial({super.temperatureUnit});
}

class WeatherLoadInProgress extends WeatherState {
  const WeatherLoadInProgress({super.temperatureUnit});
}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;
  final List<Forecast>? forecasts;
  
  const WeatherLoadSuccess({
    required this.weather,
    this.forecasts,
    super.temperatureUnit,
  });
  
  @override
  List<Object> get props => [
    weather, 
    if (forecasts != null) forecasts!, 
    temperatureUnit
  ];
  
  WeatherLoadSuccess copyWith({
    Weather? weather,
    List<Forecast>? forecasts,
    TemperatureUnit? temperatureUnit,
  }) {
    return WeatherLoadSuccess(
      weather: weather ?? this.weather,
      forecasts: forecasts ?? this.forecasts,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }
  
  // Helper methods to convert temperature
  double get temperatureInUnit {
    return temperatureUnit == TemperatureUnit.celsius
        ? weather.temperature
        : (weather.temperature * 9 / 5) + 32;
  }
  
  double get feelsLikeInUnit {
    return temperatureUnit == TemperatureUnit.celsius
        ? weather.feelsLike
        : (weather.feelsLike * 9 / 5) + 32;
  }
  
  double get minTempInUnit {
    return temperatureUnit == TemperatureUnit.celsius
        ? weather.minTemp
        : (weather.minTemp * 9 / 5) + 32;
  }
  
  double get maxTempInUnit {
    return temperatureUnit == TemperatureUnit.celsius
        ? weather.maxTemp
        : (weather.maxTemp * 9 / 5) + 32;
  }
  
  String get temperatureUnitSymbol {
    return temperatureUnit == TemperatureUnit.celsius ? '°C' : '°F';
  }
}

class WeatherLoadFailure extends WeatherState {
  final String message;
  
  const WeatherLoadFailure({
    required this.message,
    super.temperatureUnit,
  });
  
  @override
  List<Object> get props => [message, temperatureUnit];
}

class ForecastLoadInProgress extends WeatherState {
  const ForecastLoadInProgress({super.temperatureUnit});
}

class ForecastLoadFailure extends WeatherState {
  final String message;
  
  const ForecastLoadFailure({
    required this.message,
    super.temperatureUnit,
  });
  
  @override
  List<Object> get props => [message, temperatureUnit];
}

class CitySuggestionsLoadInProgress extends WeatherState {
  const CitySuggestionsLoadInProgress({super.temperatureUnit});
}

class CitySuggestionsLoadSuccess extends WeatherState {
  final List<String> suggestions;
  
  const CitySuggestionsLoadSuccess({
    required this.suggestions,
    super.temperatureUnit,
  });
  
  @override
  List<Object> get props => [suggestions, temperatureUnit];
}

class CitySuggestionsLoadFailure extends WeatherState {
  final String message;
  
  const CitySuggestionsLoadFailure({
    required this.message,
    super.temperatureUnit,
  });
  
  @override
  List<Object> get props => [message, temperatureUnit];
}