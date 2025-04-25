import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';

class WeatherSearchBar extends StatefulWidget {
  final Function(String) onCitySubmitted;

  const WeatherSearchBar({super.key, required this.onCitySubmitted});

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final city = _textController.text.trim();
    if (city.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      
      widget.onCitySubmitted(city);
      
      // Reset the searching state after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isSearching = false;
          });
        }
      });
      // Don't clear text to provide better UX - user can see what they searched for
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission denied'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        // Show settings message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location permission permanently denied. Please enable in settings.'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      // Call the weather by location event
      if (mounted) {
        context.read<WeatherBloc>().add(
          WeatherRequestedByLocation(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r), // Giảm padding dọc
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Search for a city...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                    size: 20.r, // Giảm kích thước icon
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 8.h, // Giảm padding dọc
                    horizontal: 12.w, // Giảm padding ngang
                  ),
                ),
                onSubmitted: (_) => _submit(),
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: 14.sp), // Giảm kích thước font
              ),
            ),
            // Nút tìm kiếm mới
            Material(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: _isSearching ? null : _submit,
                child: Container(
                  padding: EdgeInsets.all(8.r), // Giảm padding
                  child: _isSearching
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 20.r, // Giảm kích thước icon
                        ),
                ),
              ),
            ),
            SizedBox(width: 6.w), // Khoảng cách giữa nút
            // Nút vị trí
            Material(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(12.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: _isLoading ? null : _getCurrentLocation,
                child: Container(
                  padding: EdgeInsets.all(8.r), // Giảm padding
                  margin: EdgeInsets.only(right: 4.w), // Giảm margin
                  child: _isLoading
                      ? SizedBox(
                          width: 18.r,
                          height: 18.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.my_location,
                          color: Colors.white,
                          size: 20.r, // Giảm kích thước icon
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}