import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'providers/country_provider.dart';
import 'providers/location_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/audio_provider.dart';
import 'screens/home_screen.dart';
import 'screens/country_screen.dart';
import 'screens/locations_screen.dart';
import 'screens/audio_player_screen.dart';
import 'screens/subscription_screen.dart';
import 'screens/admin_dashboard.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountryProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: MaterialApp.router(
        title: 'أدلة سياحية صوتية',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar', 'SA'),
          Locale('en', 'US'),
        ],
        locale: const Locale('ar', 'SA'),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _buildRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/countries',
          builder: (context, state) => const CountryScreen(),
        ),
        GoRoute(
          path: '/locations/:countryId',
          builder: (context, state) => LocationsScreen(
            countryId: state.pathParameters['countryId']!,
          ),
        ),
        GoRoute(
          path: '/player/:locationId',
          builder: (context, state) => AudioPlayerScreen(
            locationId: state.pathParameters['locationId']!,
          ),
        ),
        GoRoute(
          path: '/subscription',
          builder: (context, state) => const SubscriptionScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboard(),
        ),
      ],
    );
  }
}
