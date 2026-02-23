import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_colors.dart';
import 'core/constants.dart';
import 'core/routes.dart';
import 'core/variable_name.dart';
import 'providers/admin_provider.dart';
import 'providers/auth_provider.dart';
import 'repositories/admin_repository.dart';
import 'repositories/user_repository.dart';
import 'screens/admin/admin_bookings_page.dart';
import 'screens/admin/admin_categories_page.dart';
import 'screens/admin/admin_dashboard_page.dart';
import 'screens/admin/admin_messages_page.dart';
import 'screens/admin/admin_providers_page.dart';
import 'screens/admin/admin_reviews_page.dart';
import 'screens/admin/admin_subscriptions_page.dart';
import 'screens/admin/admin_users_page.dart';
import 'screens/login_page.dart';
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
  final adminRepo = AdminRepository(supabaseService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService, userRepo)),
        ChangeNotifierProvider(create: (_) => AdminProvider(adminRepo)),
      ],
      child: const AdminApp(),
    ),
  );
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: adminDashboardRoute,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final uri = Uri.parse(settings.name ?? '/');
    final path = uri.path;

    switch (path) {
      case loginRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const LoginPage());
      case adminRoute:
      case adminDashboardRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminDashboardPage());
      case adminProvidersRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminProvidersPage());
      case adminBookingsRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminBookingsPage());
      case adminReviewsRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminReviewsPage());
      case adminCategoriesRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminCategoriesPage());
      case adminUsersRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminUsersPage());
      case adminMessagesRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminMessagesPage());
      case adminSubscriptionsRoute:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminSubscriptionsPage());
      default:
        return MaterialPageRoute(settings: settings, builder: (_) => const AdminDashboardPage());
    }
  }
}
