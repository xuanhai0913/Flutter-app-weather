import 'package:flutter/material.dart';

class AppTheme {
  // Get appropriate theme based on weather condition
  static ThemeData getTheme(String? weatherCondition) {
    // Default theme if no condition is provided
    if (weatherCondition == null) {
      return _buildDefaultTheme();
    }
    
    // Convert to lowercase for case-insensitive comparison
    final condition = weatherCondition.toLowerCase();
    
    // Determine theme based on weather condition
    if (condition == 'clear') {
      return _buildSunnyTheme();
    } else if (condition == 'clouds') {
      return _buildCloudyTheme();
    } else if (condition == 'rain' || condition == 'drizzle') {
      return _buildRainyTheme();
    } else if (condition == 'thunderstorm') {
      return _buildThunderstormTheme();
    } else if (condition == 'snow') {
      return _buildSnowyTheme();
    } else if (condition == 'mist' || condition == 'fog' || condition == 'haze') {
      return _buildMistyTheme();
    } else {
      return _buildDefaultTheme();
    }
  }
  
  // Default theme
  static ThemeData _buildDefaultTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Sunny day theme
  static ThemeData _buildSunnyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.amber[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.amber[300],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Cloudy day theme
  static ThemeData _buildCloudyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.blueGrey[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[300],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Rainy day theme
  static ThemeData _buildRainyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.indigo[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo[300],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Thunderstorm theme
  static ThemeData _buildThunderstormTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.deepPurple[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurple[700],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Snowy day theme
  static ThemeData _buildSnowyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.lightBlue[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlue[300],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
  
  // Misty/Foggy day theme
  static ThemeData _buildMistyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[400],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}