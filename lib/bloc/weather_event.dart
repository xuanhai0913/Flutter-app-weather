import 'package:equatable/equatable.dart';

enum TemperatureUnit { celsius, fahrenheit }

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  
  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;
  
  const WeatherRequested({required this.city});
  
  @override
  List<Object> get props => [city];
}

class WeatherRefreshRequested extends WeatherEvent {
  final String city;
  
  const WeatherRefreshRequested({required this.city});
  
  @override
  List<Object> get props => [city];
}

class WeatherRequestedByLocation extends WeatherEvent {
  final double latitude;
  final double longitude;
  
  const WeatherRequestedByLocation({
    required this.latitude,
    required this.longitude,
  });
  
  @override
  List<Object> get props => [latitude, longitude];
}

class CitySuggestionsRequested extends WeatherEvent {}

// New events for forecast
class ForecastRequested extends WeatherEvent {
  final String city;
  
  const ForecastRequested({required this.city});
  
  @override
  List<Object> get props => [city];
}

class ForecastRequestedByLocation extends WeatherEvent {
  final double latitude;
  final double longitude;
  
  const ForecastRequestedByLocation({
    required this.latitude,
    required this.longitude,
  });
  
  @override
  List<Object> get props => [latitude, longitude];
}

// New event for toggling temperature unit
class TemperatureUnitToggled extends WeatherEvent {
  final TemperatureUnit unit;
  
  const TemperatureUnitToggled({required this.unit});
  
  @override
  List<Object> get props => [unit];
}