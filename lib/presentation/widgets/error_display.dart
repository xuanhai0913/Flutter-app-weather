import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplay({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(24.r),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: isDarkMode
              ? theme.colorScheme.errorContainer.withOpacity(0.7)
              : theme.colorScheme.errorContainer.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated error icon
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.5, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 70.sp,
                  ),
                );
              },
            ),
            
            SizedBox(height: 16.h),
            
            // Error title with fade-in animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'Something went wrong!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            
            SizedBox(height: 12.h),
            
            // Error details with fade-in animation
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeIn,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    _getReadableErrorMessage(message),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode
                          ? theme.colorScheme.onErrorContainer
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            
            SizedBox(height: 24.h),
            
            // Retry button with slide-up animation
            TweenAnimationBuilder<Offset>(
              tween: Tween<Offset>(
                begin: const Offset(0, 50),
                end: Offset.zero,
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuad,
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: offset,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      elevation: 2,
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 16.h),
            
            // Help tips
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Troubleshooting Tips:',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildTip(context, 'Check your internet connection.'),
                  _buildTip(context, 'Verify the city name is spelled correctly.'),
                  _buildTip(context, 'Try using your current location instead.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTip(BuildContext context, String tip) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.arrow_right,
            size: 16.sp,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to convert API errors to more user-friendly messages
  String _getReadableErrorMessage(String message) {
    if (message.contains('Failed to fetch weather')) {
      return 'We couldn\'t find weather information for this location. Please check the city name and try again.';
    } else if (message.contains('timed out')) {
      return 'The request took too long to complete. Please check your internet connection and try again.';
    } else if (message.contains('SocketException')) {
      return 'Can\'t connect to the server. Please check your internet connection and try again.';
    } else if (message.contains('permission')) {
      return 'Location access is required to get weather for your current position.';
    } else {
      return message;
    }
  }
}