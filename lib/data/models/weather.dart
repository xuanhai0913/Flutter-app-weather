import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather extends Equatable {
  final String cityName;
  final double temperature;
  
  @JsonKey(name: 'main')
  final String condition;
  
  @JsonKey(name: 'description')
  final String description;
  
  @JsonKey(defaultValue: 0)
  final double minTemp;
  
  @JsonKey(defaultValue: 0)
  final double maxTemp;
  
  @JsonKey(defaultValue: 0)
  final double feelsLike;
  
  @JsonKey(defaultValue: 0)
  final int humidity;
  
  @JsonKey(defaultValue: 0)
  final double windSpeed;
  
  const Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.description,
    required this.minTemp,
    required this.maxTemp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });
  
  @override
  List<Object> get props => [
    cityName, 
    temperature, 
    condition, 
    description,
    minTemp,
    maxTemp,
    feelsLike,
    humidity,
    windSpeed
  ];
  
  String get iconUrl => 'https://openweathermap.org/img/wn/${_getIconCode(condition)}@2x.png';
  
  String _getIconCode(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear': return '01d';
      case 'clouds': return '03d';
      case 'rain': return '10d';
      case 'drizzle': return '09d';
      case 'thunderstorm': return '11d';
      case 'snow': return '13d';
      case 'mist':
      case 'fog':
      case 'haze': return '50d';
      default: return '01d';
    }
  }
  
  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);
      
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
  
  static Weather fromRepository(
    String cityName,
    Map<String, dynamic> json,
  ) {
    final Map<String, dynamic> weatherData = json['weather'][0];
    final Map<String, dynamic> mainData = json['main'];
    final Map<String, dynamic> windData = json['wind'] ?? {'speed': 0.0};
    
    return Weather(
      cityName: cityName,
      temperature: (mainData['temp'] as num).toDouble(),
      condition: weatherData['main'] as String,
      description: weatherData['description'] as String,
      minTemp: (mainData['temp_min'] as num).toDouble(),
      maxTemp: (mainData['temp_max'] as num).toDouble(),
      feelsLike: (mainData['feels_like'] as num).toDouble(),
      humidity: mainData['humidity'] as int,
      windSpeed: (windData['speed'] as num).toDouble(),
    );
  }
}