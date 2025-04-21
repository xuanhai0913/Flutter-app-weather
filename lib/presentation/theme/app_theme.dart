import 'package:flutter/material.dart';

class AppTheme {
  // Get appropriate theme based on weather condition and system theme mode
  static ThemeData getTheme(String? weatherCondition, {bool darkMode = false}) {
    // Default theme if no condition is provided
    if (weatherCondition == null) {
      return darkMode ? _buildDarkDefaultTheme() : _buildDefaultTheme();
    }
    
    // Convert to lowercase for case-insensitive comparison
    final condition = weatherCondition.toLowerCase();
    
    // Determine theme based on weather condition and system preference
    if (condition == 'clear') {
      return darkMode ? _buildDarkSunnyTheme() : _buildSunnyTheme();
    } else if (condition == 'clouds') {
      return darkMode ? _buildDarkCloudyTheme() : _buildCloudyTheme();
    } else if (condition == 'rain' || condition == 'drizzle') {
      return darkMode ? _buildDarkRainyTheme() : _buildRainyTheme();
    } else if (condition == 'thunderstorm') {
      return darkMode ? _buildDarkThunderstormTheme() : _buildThunderstormTheme();
    } else if (condition == 'snow') {
      return darkMode ? _buildDarkSnowyTheme() : _buildSnowyTheme();
    } else if (condition == 'mist' || condition == 'fog' || condition == 'haze') {
      return darkMode ? _buildDarkMistyTheme() : _buildMistyTheme();
    } else {
      return darkMode ? _buildDarkDefaultTheme() : _buildDefaultTheme();
    }
  }
  
  // Light mode themes
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
  
  // Dark mode themes
  // Dark default theme
  static ThemeData _buildDarkDefaultTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
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
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
  
  // Dark sunny theme
  static ThemeData _buildDarkSunnyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.amber,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.amber[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.amber[800],
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
  
  // Dark cloudy theme
  static ThemeData _buildDarkCloudyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.blueGrey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[800],
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
  
  // Dark rainy theme
  static ThemeData _buildDarkRainyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.indigo[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.indigo[800],
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
  
  // Dark thunderstorm theme
  static ThemeData _buildDarkThunderstormTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurple[900],
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
  
  // Dark snowy theme
  static ThemeData _buildDarkSnowyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.blue[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.lightBlue[800],
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
  
  // Dark misty/foggy theme
  static ThemeData _buildDarkMistyTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.grey,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[800],
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