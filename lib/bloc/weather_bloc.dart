import 'package:bloc/bloc.dart';
import 'package:flutter_weather_bloc/data/repositories/weather_repository.dart';
import 'package:flutter_weather_bloc/data/services/location_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
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
  }
  
  Future<void> _onWeatherRequested(
    WeatherRequested event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadInProgress());
    try {
      final weather = await _weatherRepository.getWeather(event.city);
      
      // Get forecast as well
      try {
        final forecasts = await _weatherRepository.getForecast(event.city);
        emit(WeatherLoadSuccess(weather: weather, forecasts: forecasts));
      } catch (_) {
        // If forecast fails, still show weather
        emit(WeatherLoadSuccess(weather: weather));
      }
    } catch (e) {
      emit(WeatherLoadFailure(message: e.toString()));
    }
  }
  
  Future<void> _onWeatherRefreshRequested(
    WeatherRefreshRequested event,
    Emitter<WeatherState> emit,
  ) async {
    try {
      final weather = await _weatherRepository.getWeather(event.city);
      
      // Also refresh the forecast
      try {
        final forecasts = await _weatherRepository.getForecast(event.city);
        emit(WeatherLoadSuccess(weather: weather, forecasts: forecasts));
      } catch (_) {
        emit(WeatherLoadSuccess(weather: weather));
      }
    } catch (e) {
      emit(WeatherLoadFailure(message: e.toString()));
    }
  }
  
  Future<void> _onWeatherRequestedByLocation(
    WeatherRequestedByLocation event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoadInProgress());
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
        emit(WeatherLoadSuccess(weather: weather, forecasts: forecasts));
      } catch (_) {
        emit(WeatherLoadSuccess(weather: weather));
      }
    } catch (e) {
      emit(WeatherLoadFailure(message: e.toString()));
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
    emit(CitySuggestionsLoadInProgress());
    try {
      final suggestions = await _locationService.getNearbyPlaces();
      emit(CitySuggestionsLoadSuccess(suggestions: suggestions));
    } catch (e) {
      emit(CitySuggestionsLoadFailure(message: e.toString()));
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
}