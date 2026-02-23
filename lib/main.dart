import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_colors.dart';
import 'core/constants.dart';
import 'core/routes.dart';
import 'core/variable_name.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/providers_provider.dart';
import 'providers/pack_provider.dart';
import 'providers/review_provider.dart';
import 'repositories/booking_repository.dart';
import 'repositories/pack_repository.dart';
import 'repositories/provider_repository.dart';
import 'repositories/review_repository.dart';
import 'repositories/user_repository.dart';
import 'screens/bookings_page.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart';
import 'screens/contact_page.dart';
import 'screens/favorites_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/prestataires_page.dart';
import 'screens/profile_page.dart';
import 'screens/provider_detail_page.dart';
import 'screens/register_page.dart';
import 'screens/services_page.dart';
import 'services/auth_service.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Services
  final authService = AuthService();
  final supabaseService = SupabaseService();

  // Repositories
  final userRepo = UserRepository(supabaseService);
  final providerRepo = ProviderRepository(supabaseService);
  final bookingRepo = BookingRepository(supabaseService);
  final reviewRepo = ReviewRepository(supabaseService);
  final packRepo = PackRepository(supabaseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService, userRepo)),
        ChangeNotifierProvider(create: (_) => ProvidersProvider(providerRepo)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider(bookingRepo)),
        ChangeNotifierProvider(create: (_) => ReviewProvider(reviewRepo)),
        ChangeNotifierProvider(create: (_) => PackProvider(packRepo)),
        ChangeNotifierProvider(create: (_) => FavoritesProvider(userRepo)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: homeRoute,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path;

    // Route dynamique : /prestataire/:id
    if (path.startsWith('$providerDetailRoute/')) {
      final id = path.substring(providerDetailRoute.length + 1);
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => ProviderDetailPage(providerId: id),
      );
    }

    // Routes avec arguments optionnels
    final args = settings.arguments as Map<String, dynamic>?;

    switch (path) {
      case homeRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());
      case serviceRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const ServicesPage());
      case prestatairesRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => PrestatairesPage(
            initialCategory: args?['category'] as String?,
            initialSearch: args?['search'] as String?,
          ),
        );
      case contactRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const ContactPage());
      case loginRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const LoginPage());
      case registerRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const RegisterPage());
      case profileRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const ProfilePage());
      case cartRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const CartPage());
      case checkoutRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const CheckoutPage());
      case bookingsRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const BookingsPage());
      case favoritesRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const FavoritesPage());
      case forgotPasswordRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const ForgotPasswordPage());
      default:
        return MaterialPageRoute(settings: settings, builder: (_) => const HomePage());
    }
  }
}
