import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/weather_bloc.dart';
import '../../bloc/weather_event.dart';
import '../../bloc/weather_state.dart';

class CitySuggestions extends StatelessWidget {
  const CitySuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        // Don't show suggestions if we already have weather data
        if (state is WeatherLoadSuccess || 
            state is WeatherRefreshInProgress) {
          return const SizedBox.shrink();
        }
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.recommend,
                    size: 18.sp,
                    color: theme.colorScheme.secondary,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Popular Cities',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              
              if (state is CitySuggestionsLoadInProgress)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              else if (state is CitySuggestionsLoadSuccess)
                _buildCitySuggestionGrid(context, state.suggestions, theme)
              else if (state is CitySuggestionsLoadFailure)
                _buildErrorMessage(context, state.message, theme)
              else
                _buildDefaultSuggestions(context, theme),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCitySuggestionGrid(
    BuildContext context, 
    List<String> suggestions, 
    ThemeData theme
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final city = suggestions[index];
        
        return InkWell(
          onTap: () {
            context.read<WeatherBloc>().add(WeatherRequested(city: city));
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_city,
                    size: 16.sp,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 6.w),
                  Flexible(
                    child: Text(
                      city,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildErrorMessage(BuildContext context, String message, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: theme.colorScheme.errorContainer.withOpacity(0.7),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.onErrorContainer,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'Could not load city suggestions: $message',
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDefaultSuggestions(BuildContext context, ThemeData theme) {
    // List of popular cities to show by default
    final popularCities = [
      'London', 'New York', 'Tokyo', 'Paris',
      'Berlin', 'Sydney', 'Beijing', 'Cairo'
    ];
    
    return _buildCitySuggestionGrid(context, popularCities, theme);
  }
}