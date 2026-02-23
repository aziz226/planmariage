import '../core/constants.dart';
import '../core/models.dart';
import '../services/supabase_service.dart';

class BookingRepository {
  final SupabaseService _db;

  BookingRepository(this._db);

  Future<BookingModel> createBooking(BookingModel booking) async {
    final data = await _db.insert(Tables.bookings, booking.toJson());
    return BookingModel.fromJson(data);
  }

  Future<List<BookingModel>> getUserBookings(String userId) async {
    final data = await _db.getAll(
      Tables.bookings,
      select: '*, providers(*)',
      filters: {'user_id': userId},
      orderBy: 'created_at',
      ascending: false,
    );
    return data.map((json) => BookingModel.fromJson(json)).toList();
  }

  Future<void> updateStatus(String bookingId, String status) async {
    await _db.update(Tables.bookings, bookingId, {'status': status});
  }

  Future<void> cancelBooking(String bookingId) async {
    await updateStatus(bookingId, 'cancelled');
  }
}
