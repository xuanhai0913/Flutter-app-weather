import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Get the current location of the device
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    // Check if permanently denied
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

  // Get a list of suggested cities around the current location
  Future<List<String>> getNearbyPlaces() async {
    try {
      final position = await getCurrentLocation();
      
      // Use geocoding to get places near the current location
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      // Create a set to avoid duplicate city names
      Set<String> cities = {};
      
      // Add the current city if available
      if (placemarks.isNotEmpty && placemarks[0].locality != null && placemarks[0].locality!.isNotEmpty) {
        cities.add(placemarks[0].locality!);
      }
      
      // Add some nearby major cities based on country
      String? countryCode = placemarks.isNotEmpty ? placemarks[0].isoCountryCode : null;
      
      // Add some predefined cities based on the country
      cities.addAll(_getCitiesByCountry(countryCode));
          
      // If we still don't have enough cities, add some global major cities
      if (cities.length < 3) {
        cities.addAll(['London', 'New York', 'Tokyo', 'Paris', 'Sydney']);
      }
      
      return cities.take(5).toList();
    } catch (e) {
      // Return default cities if there's an error
      return ['London', 'New York', 'Tokyo', 'Paris', 'Sydney'];
    }
  }

  // Helper method to get major cities by country code
  List<String> _getCitiesByCountry(String? countryCode) {
    // Nếu countryCode là null, sử dụng giá trị mặc định
    switch (countryCode ?? 'default') {
      case 'US':
        return ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Miami'];
      case 'GB':
        return ['London', 'Manchester', 'Birmingham', 'Glasgow', 'Liverpool'];
      case 'JP':
        return ['Tokyo', 'Osaka', 'Kyoto', 'Yokohama', 'Sapporo'];
      case 'VN':
        return ['Hanoi', 'Ho Chi Minh City', 'Da Nang', 'Hue', 'Nha Trang'];
      case 'FR':
        return ['Paris', 'Marseille', 'Lyon', 'Toulouse', 'Nice'];
      case 'AU':
        return ['Sydney', 'Melbourne', 'Brisbane', 'Perth', 'Adelaide'];
      default:
        return ['London', 'New York', 'Tokyo', 'Paris', 'Sydney'];
    }
  }
}