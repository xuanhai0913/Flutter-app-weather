import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'forecast.g.dart';

@JsonSerializable()
class Forecast extends Equatable {
  final DateTime date;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final String description;
  final String iconCode;
  final double windSpeed;

  const Forecast({
    required this.date,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.description,
    required this.iconCode,
    required this.windSpeed,
  });

  @override
  List<Object> get props => [
    date, 
    temperature, 
    feelsLike, 
    humidity, 
    description, 
    iconCode, 
    windSpeed
  ];

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get dayOfWeek {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate = DateTime(date.year, date.month, date.day);
    
    final difference = forecastDate.difference(today).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    
    switch (date.weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);
  
  Map<String, dynamic> toJson() => _$ForecastToJson(this);
  
  // Factory constructor for API data
  static Forecast fromRepository(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final wind = json['wind'];
    
    return Forecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'] as int,
      description: weather['description'] as String,
      iconCode: weather['icon'] as String,
      windSpeed: (wind['speed'] as num).toDouble(),
    );
  }
}