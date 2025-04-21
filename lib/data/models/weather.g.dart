// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
  cityName: json['cityName'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  condition: json['main'] as String,
  description: json['description'] as String,
  minTemp: (json['minTemp'] as num?)?.toDouble() ?? 0,
  maxTemp: (json['maxTemp'] as num?)?.toDouble() ?? 0,
  feelsLike: (json['feelsLike'] as num?)?.toDouble() ?? 0,
  humidity: (json['humidity'] as num?)?.toInt() ?? 0,
  windSpeed: (json['windSpeed'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'cityName': instance.cityName,
  'temperature': instance.temperature,
  'main': instance.condition,
  'description': instance.description,
  'minTemp': instance.minTemp,
  'maxTemp': instance.maxTemp,
  'feelsLike': instance.feelsLike,
  'humidity': instance.humidity,
  'windSpeed': instance.windSpeed,
};
