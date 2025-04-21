import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherRepository {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String _apiKey = '209a96d186137a5eaaf026f757dd1810'; // API key from your project
  
  Future<Weather> getWeather(String city) async {
    final weatherUrl = '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric';
    
    final response = await http.get(Uri.parse(weatherUrl));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather for $city');
    }
    
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    return Weather.fromRepository(city, jsonData);
  }
  
  // Get weather by geographical coordinates
  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final weatherUrl = '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    
    final response = await http.get(Uri.parse(weatherUrl));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch weather for location ($lat, $lon)');
    }
    
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final String cityName = jsonData['name'] ?? 'Unknown location';
    return Weather.fromRepository(cityName, jsonData);
  }
  
  // Get 5-day forecast by city name
  Future<List<Forecast>> getForecast(String city) async {
    final forecastUrl = '$_baseUrl/forecast?q=$city&appid=$_apiKey&units=metric';
    
    final response = await http.get(Uri.parse(forecastUrl));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch forecast for $city');
    }
    
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> forecastList = jsonData['list'];
    
    // Filter to get one forecast per day (at noon)
    final List<Forecast> dailyForecasts = [];
    String currentDay = '';
    
    for (var item in forecastList) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final String day = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      
      // Only add one forecast per day (preferably around noon)
      if (day != currentDay && dailyForecasts.length < 5) {
        dailyForecasts.add(Forecast.fromRepository(item));
        currentDay = day;
      }
    }
    
    return dailyForecasts;
  }
  
  // Get 5-day forecast by coordinates
  Future<List<Forecast>> getForecastByCoordinates(double lat, double lon) async {
    final forecastUrl = '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    
    final response = await http.get(Uri.parse(forecastUrl));
    
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch forecast for location ($lat, $lon)');
    }
    
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final List<dynamic> forecastList = jsonData['list'];
    
    // Filter to get one forecast per day
    final List<Forecast> dailyForecasts = [];
    String currentDay = '';
    
    for (var item in forecastList) {
      final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final String day = '${dateTime.year}-${dateTime.month}-${dateTime.day}';
      
      if (day != currentDay && dailyForecasts.length < 5) {
        dailyForecasts.add(Forecast.fromRepository(item));
        currentDay = day;
      }
    }
    
    return dailyForecasts;
  }
}