import 'package:flutter/material.dart';

class WeatherSearchBar extends StatefulWidget {
  final Function(String) onCitySubmitted;

  const WeatherSearchBar({super.key, required this.onCitySubmitted});

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submit() {
    final city = _textController.text.trim();
    if (city.isNotEmpty) {
      widget.onCitySubmitted(city);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
              onSubmitted: (_) => _submit(),
              textInputAction: TextInputAction.search,
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}