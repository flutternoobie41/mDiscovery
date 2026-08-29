import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart' as di;
import 'features/main_navigation/presentation/cubit/navigation_cubit.dart';
import 'features/main_navigation/presentation/screens/main_navigation_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar transparency for full-bleed dark theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize GetIt dependency injection
  await di.initDependencyInjection();

  runApp(const MDiscoverApp());
}

class MDiscoverApp extends StatefulWidget {
  const MDiscoverApp({super.key});

  @override
  State<MDiscoverApp> createState() => _MDiscoverAppState();
}

class _MDiscoverAppState extends State<MDiscoverApp> {
  bool _showSplash = true;
  bool _showOnboarding = true;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'MDiscover',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          home: _showSplash
              ? SplashScreen(
                  onInitializationComplete: () {
                    setState(() {
                      _showSplash = false;
                    });
                  },
                )
              : _showOnboarding
                  ? OnboardingScreen(
                      onGetStarted: () {
                        setState(() {
                          _showOnboarding = false;
                        });
                      },
                    )
                  : BlocProvider<NavigationCubit>(
                      create: (_) => di.sl<NavigationCubit>(),
                      child: const MainNavigationScreen(),
                    ),
        );
      },
    );
  }
}
