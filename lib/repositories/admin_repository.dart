import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class AdminRepository {
  final SupabaseService _db;

  AdminRepository(this._db);

  // ── Dashboard Stats ──

  Future<Map<String, dynamic>> getStats() async {
    final providers = await _db.getAll(Tables.providers);
    final bookings = await _db.getAll(Tables.bookings);
    final users = await _db.getAll(Tables.profiles);
    final reviews = await _db.getAll(Tables.reviews);

    final totalRevenue = bookings
        .where((b) => b['status'] == 'confirmed')
        .fold<int>(0, (sum, b) => sum + ((b['total_price'] as num?)?.toInt() ?? 0));

    final pendingBookings = bookings.where((b) => b['status'] == 'pending').length;

    return {
      'totalProviders': providers.length,
      'totalBookings': bookings.length,
      'totalUsers': users.length,
      'totalReviews': reviews.length,
      'totalRevenue': totalRevenue,
      'pendingBookings': pendingBookings,
    };
  }

  Future<List<BookingModel>> getRecentBookings({int limit = 5}) async {
    final data = await _db.getAll(
      Tables.bookings,
      select: '*, providers(name, service_category)',
      orderBy: 'created_at',
      ascending: false,
      limit: limit,
    );
    return data.map((json) => BookingModel.fromJson(json)).toList();
  }

  // ── Providers CRUD ──

  Future<List<ProviderModel>> getAllProviders() async {
    final data = await _db.getAll(Tables.providers, orderBy: 'created_at', ascending: false);
    return data.map((json) => ProviderModel.fromJson(json)).toList();
  }

  Future<void> createProvider(Map<String, dynamic> data) async {
    await _db.insert(Tables.providers, data);
  }

  Future<void> updateProvider(String id, Map<String, dynamic> data) async {
    await _db.update(Tables.providers, id, data);
  }

  Future<void> deleteProvider(String id) async {
    await _db.delete(Tables.providers, id);
  }

  // ── Bookings ──

  Future<List<BookingModel>> getAllBookings() async {
    final data = await _db.getAll(
      Tables.bookings,
      select: '*, providers(name, service_category)',
      orderBy: 'created_at',
      ascending: false,
    );
    return data.map((json) => BookingModel.fromJson(json)).toList();
  }

  Future<void> updateBookingStatus(String id, String status) async {
    await _db.update(Tables.bookings, id, {'status': status});
  }

  // ── Reviews ──

  Future<List<ReviewModel>> getAllReviews() async {
    final data = await _db.getAll(
      Tables.reviews,
      select: '*, profiles(display_name)',
      orderBy: 'created_at',
      ascending: false,
    );
    return data.map((json) => ReviewModel.fromJson(json)).toList();
  }

  Future<void> deleteReview(String id) async {
    await _db.delete(Tables.reviews, id);
  }

  // ── Categories ──

  Future<List<CategoryModel>> getAllCategories() async {
    final data = await _db.getAll(Tables.categories, orderBy: 'name', ascending: true);
    return data.map((json) => CategoryModel.fromJson(json)).toList();
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    await _db.insert(Tables.categories, data);
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    await _db.update(Tables.categories, id, data);
  }

  Future<void> deleteCategory(String id) async {
    await _db.delete(Tables.categories, id);
  }

  // ── Users ──

  Future<List<UserModel>> getAllUsers() async {
    final data = await _db.getAll(Tables.profiles, orderBy: 'created_at', ascending: false);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<void> updateUserRole(String id, String role) async {
    await _db.update(Tables.profiles, id, {'role': role});
  }

  // ── Contact Messages ──

  Future<List<ContactMessage>> getAllMessages() async {
    final data = await _db.getAll(Tables.contactMessages, orderBy: 'created_at', ascending: false);
    return data.map((json) => ContactMessage.fromJson(json)).toList();
  }

  Future<void> deleteMessage(String id) async {
    await _db.delete(Tables.contactMessages, id);
  }

  // ── Subscriptions ──

  Future<List<SubscriptionModel>> getAllSubscriptions() async {
    final data = await _db.getAll(
      Tables.subscriptions,
      select: '*, providers(name, service_category)',
      orderBy: 'created_at',
      ascending: false,
    );
    return data.map((json) => SubscriptionModel.fromJson(json)).toList();
  }
}
