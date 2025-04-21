import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/weather_bloc.dart';
import 'bloc/weather_state.dart';
import 'data/repositories/weather_repository.dart';
import 'presentation/screens/welcome_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize HydratedBloc for persisting state
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => WeatherBloc(
            weatherRepository: WeatherRepository(),
          ),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              // Determine theme based on current weather condition
              String? weatherCondition;
              if (state is WeatherLoadSuccess) {
                weatherCondition = state.weather.condition;
              }
              
              return MaterialApp(
                title: 'Weather Forecast',
                theme: AppTheme.getTheme(weatherCondition),
                home: const WelcomeScreen(),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
    );
  }
}
