// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forecast _$ForecastFromJson(Map<String, dynamic> json) => Forecast(
  date: DateTime.parse(json['date'] as String),
  temperature: (json['temperature'] as num).toDouble(),
  feelsLike: (json['feelsLike'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
  description: json['description'] as String,
  iconCode: json['iconCode'] as String,
  windSpeed: (json['windSpeed'] as num).toDouble(),
);

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'temperature': instance.temperature,
  'feelsLike': instance.feelsLike,
  'humidity': instance.humidity,
  'description': instance.description,
  'iconCode': instance.iconCode,
  'windSpeed': instance.windSpeed,
};
