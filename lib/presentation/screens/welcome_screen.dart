import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';
import 'weather_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isRequestingLocation = false;
  bool _autoNavigateEnabled = true;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad,
    ));
    
    _controller.forward();
    
    // Check if we already have weather data saved
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSavedState();
    });
  }

  Future<void> _checkSavedState() async {
    // Check if we have persisted weather data
    final weatherState = BlocProvider.of<WeatherBloc>(context).state;
    
    // If we have saved weather data, navigate to weather page after a brief delay
    if (weatherState is WeatherLoadSuccess && _autoNavigateEnabled) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToWeatherPage();
      }
    }
  }

  void _navigateToWeatherPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const WeatherPage(),
      ),
    );
  }

  Future<void> _requestLocationAndGetWeather() async {
    if (_isRequestingLocation) return;
    
    setState(() {
      _isRequestingLocation = true;
      _autoNavigateEnabled = false; // Disable auto-navigation once user interacts
    });
    
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Show a snackbar if permission is denied
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location permission denied. Using default city.'),
                duration: Duration(seconds: 3),
              ),
            );
            setState(() {
              _isRequestingLocation = false;  // Reset flag here
            });
          }
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Show a snackbar if permission is permanently denied
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Location permission permanently denied. Please enable it in app settings.',
              ),
              action: SnackBarAction(
                label: 'Settings',
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
              ),
              duration: const Duration(seconds: 5),
            ),
          );
        }
        return;
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Request weather based on location
      if (mounted) {
        context.read<WeatherBloc>().add(
          WeatherRequestedByLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
        
        // Navigate to weather page
        _navigateToWeatherPage();
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: ${e.toString()}'),
            backgroundColor: Colors.red[700],
          ),
        );
        setState(() {
          _isRequestingLocation = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[300]!,
              Colors.blue[700]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wb_sunny,
                        size: 100.sp,
                        color: Colors.amber[300],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Weather Forecast',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Your daily weather companion',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48.h),
                      
                      // Location button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isRequestingLocation 
                              ? null 
                              : _requestLocationAndGetWeather,
                          icon: const Icon(Icons.location_on),
                          label: Text(
                            _isRequestingLocation 
                                ? 'Getting location...' 
                                : 'Use my location',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue[700],
                            disabledBackgroundColor: Colors.grey[300],
                            elevation: 2,
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      // Skip button
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _autoNavigateEnabled = false;
                          });
                          _navigateToWeatherPage();
                        },
                        child: const Text(
                          'Skip to search',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      if (_isRequestingLocation) 
                        Padding(
                          padding: EdgeInsets.only(top: 24.h),
                          child: const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}