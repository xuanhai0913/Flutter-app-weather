import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_weather_bloc/data/repositories/weather_repository.dart';
import 'package:flutter_weather_bloc/data/services/location_service.dart';
import 'dart:async';
import 'dart:convert';
import '../data/models/weather.dart';
import '../data/models/forecast.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends HydratedBloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;
  final LocationService _locationService = LocationService();
  
  WeatherBloc({required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested);
    on<WeatherRefreshRequested>(_onWeatherRefreshRequested);
    on<WeatherRequestedByLocation>(_onWeatherRequestedByLocation);
    on<CitySuggestionsRequested>(_onCitySuggestionsRequested);
    on<ForecastRequested>(_onForecastRequested);
    on<ForecastRequestedByLocation>(_onForecastRequestedByLocation);
    on<TemperatureUnitToggled>(_onTemperatureUnitToggled);
    on<WeatherRequestTimeout>(_onWeatherRequestTimeout);
  }
  
  Future<void> _onWeatherRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadInProgress());
    
    // Add timeout handling
    Timer? timeoutTimer = Timer(const Duration(seconds: 15), () {
      add(WeatherRequestTimeout());
    });
    
    try {
      final weather = await _weatherRepository.getWeather(event.city);
      
      // Get forecast as well
      try {
        final forecasts = await _weatherRepository.getForecast(event.city);
        timeoutTimer.cancel();
        emit(WeatherLoadSuccess(weather: weather, forecasts: forecasts, lastUpdated: DateTime.now()));
      } catch (e) {
        // If forecast fails, still show weather
        timeoutTimer.cancel();
        emit(WeatherLoadSuccess(weather: weather, lastUpdated: DateTime.now()));
      }
    } catch (e) {
      timeoutTimer.cancel();
      emit(WeatherLoadFailure(message: 'Could not load weather for ${event.city}: ${e.toString()}'));
    }
  }
  
  Future<void> _onWeatherRefreshRequested(
    WeatherRefreshRequested event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoadSuccess) {
      // Keep the old state while refreshing
      final currentState = state as WeatherLoadSuccess;
      emit(WeatherRefreshInProgress(
        previousWeather: currentState.weather, 
        previousForecasts: currentState.forecasts,
        temperatureUnit: currentState.temperatureUnit
      ));
    } else {
      emit(WeatherLoadInProgress());
    }
    
    try {
      final weather = await _weatherRepository.getWeather(event.city);
      
      // Also refresh the forecast
      try {
        final forecasts = await _weatherRepository.getForecast(event.city);
        emit(WeatherLoadSuccess(
          weather: weather, 
          forecasts: forecasts, 
          lastUpdated: DateTime.now(),
          temperatureUnit: state.temperatureUnit
        ));
      } catch (e) {
        emit(WeatherLoadSuccess(
          weather: weather, 
          lastUpdated: DateTime.now(),
          temperatureUnit: state.temperatureUnit
        ));
      }
    } catch (e) {
      // If refresh fails, return to previous state if available
      if (state is WeatherRefreshInProgress) {
        final refreshState = state as WeatherRefreshInProgress;
        emit(WeatherLoadSuccess(
          weather: refreshState.previousWeather,
          forecasts: refreshState.previousForecasts,
          temperatureUnit: refreshState.temperatureUnit,
          lastUpdated: DateTime.now().subtract(const Duration(minutes: 30)) // Mark as stale data
        ));
      } else {
        emit(WeatherLoadFailure(
          message: 'Could not refresh weather data: ${e.toString()}',
          temperatureUnit: state.temperatureUnit
        ));
      }
    }
  }
  
  Future<void> _onWeatherRequestedByLocation(
    WeatherRequestedByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadInProgress());
    
    Timer? timeoutTimer = Timer(const Duration(seconds: 15), () {
      add(WeatherRequestTimeout());
    });
    
    try {
      final weather = await _weatherRepository.getWeatherByCoordinates(
        event.latitude,
        event.longitude,
      );
      
      // Get forecast for location as well
      try {
        final forecasts = await _weatherRepository.getForecastByCoordinates(
          event.latitude,
          event.longitude,
        );
        timeoutTimer.cancel();
        emit(WeatherLoadSuccess(
          weather: weather, 
          forecasts: forecasts,
          lastUpdated: DateTime.now(),
          temperatureUnit: state.temperatureUnit
        ));
      } catch (_) {
        timeoutTimer.cancel();
        emit(WeatherLoadSuccess(
          weather: weather,
          lastUpdated: DateTime.now(),
          temperatureUnit: state.temperatureUnit
        ));
      }
    } catch (e) {
      timeoutTimer.cancel();
      emit(WeatherLoadFailure(
        message: 'Could not load weather for your location: ${e.toString()}',
        temperatureUnit: state.temperatureUnit
      ));
    }
  }
  
  Future<void> _onForecastRequested(
    ForecastRequested event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoadSuccess) {
      final currentState = state as WeatherLoadSuccess;
      try {
        final forecasts = await _weatherRepository.getForecast(event.city);
        emit(currentState.copyWith(forecasts: forecasts));
      } catch (e) {
        emit(ForecastLoadFailure(message: e.toString()));
      }
    }
  }
  
  Future<void> _onForecastRequestedByLocation(
    ForecastRequestedByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoadSuccess) {
      final currentState = state as WeatherLoadSuccess;
      try {
        final forecasts = await _weatherRepository.getForecastByCoordinates(
          event.latitude,
          event.longitude,
        );
        emit(currentState.copyWith(forecasts: forecasts));
      } catch (e) {
        emit(ForecastLoadFailure(message: e.toString()));
      }
    }
  }
  
  Future<void> _onCitySuggestionsRequested(
    CitySuggestionsRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(CitySuggestionsLoadInProgress(temperatureUnit: state.temperatureUnit));
    try {
      final suggestions = await _locationService.getNearbyPlaces();
      emit(CitySuggestionsLoadSuccess(
        suggestions: suggestions,
        temperatureUnit: state.temperatureUnit
      ));
    } catch (e) {
      emit(CitySuggestionsLoadFailure(
        message: e.toString(),
        temperatureUnit: state.temperatureUnit
      ));
    }
  }
  
  void _onTemperatureUnitToggled(
    TemperatureUnitToggled event,
    Emitter<WeatherState> emit,
  ) {
    if (state is WeatherLoadSuccess) {
      final currentState = state as WeatherLoadSuccess;
      emit(currentState.copyWith(temperatureUnit: event.unit));
    } else {
      emit(WeatherInitial(temperatureUnit: event.unit));
    }
  }
  
  void _onWeatherRequestTimeout(
    WeatherRequestTimeout event,
    Emitter<WeatherState> emit,
  ) {
    emit(WeatherLoadFailure(
      message: 'Request timed out. Please check your internet connection and try again.',
      temperatureUnit: state.temperatureUnit
    ));
  }
  
  // HydratedBloc implementation to persist and load state
  @override
  WeatherState? fromJson(Map<String, dynamic> json) {
    try {
      final temperatureUnit = TemperatureUnit.values[json['temperatureUnit'] as int];
      
      if (json.containsKey('weather')) {
        return WeatherLoadSuccess(
          weather: Weather.fromJson(json['weather'] as Map<String, dynamic>),
          forecasts: json.containsKey('forecasts') && json['forecasts'] != null 
              ? (json['forecasts'] as List)
                  .map((e) => Forecast.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
          temperatureUnit: temperatureUnit,
          lastUpdated: json.containsKey('lastUpdated') && json['lastUpdated'] != null
              ? DateTime.parse(json['lastUpdated'] as String)
              : DateTime.now().subtract(const Duration(days: 1)),
        );
      }
      
      return WeatherInitial(temperatureUnit: temperatureUnit);
    } catch (_) {
      return null;
    }
  }
  
  @override
  Map<String, dynamic>? toJson(WeatherState state) {
    if (state is WeatherLoadSuccess) {
      return {
        'temperatureUnit': state.temperatureUnit.index,
        'weather': state.weather.toJson(),
        'forecasts': state.forecasts?.map((e) => e.toJson()).toList(),
        'lastUpdated': state.lastUpdated.toIso8601String(),
      };
    }
    
    return {
      'temperatureUnit': state.temperatureUnit.index,
    };
  }
}