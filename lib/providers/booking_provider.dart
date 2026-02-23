import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../repositories/booking_repository.dart';

class BookingProvider extends ChangeNotifier {
  final BookingRepository _repo;

  BookingProvider(this._repo);

  List<BookingModel> _bookings = [];
  bool _loading = false;
  String? _error;

  // ── Getters ──

  List<BookingModel> get bookings => _bookings;
  bool get loading => _loading;
  String? get error => _error;

  List<BookingModel> get pendingBookings =>
      _bookings.where((b) => b.status == 'pending').toList();

  List<BookingModel> get confirmedBookings =>
      _bookings.where((b) => b.status == 'confirmed').toList();

  List<BookingModel> get cancelledBookings =>
      _bookings.where((b) => b.status == 'cancelled').toList();

  // ── Actions ──

  Future<void> loadBookings(String userId) async {
    _setLoading(true);
    _error = null;
    try {
      _bookings = await _repo.getUserBookings(userId);
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  Future<BookingModel?> createBooking({
    required String userId,
    String? providerId,
    String? packTitle,
    DateTime? eventDate,
    required int totalPrice,
    String? paymentMethod,
    String? notes,
  }) async {
    _setLoading(true);
    _error = null;
    try {
      final booking = BookingModel(
        id: '',
        userId: userId,
        providerId: providerId,
        packTitle: packTitle,
        eventDate: eventDate,
        status: 'pending',
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        notes: notes,
        createdAt: DateTime.now(),
      );
      final created = await _repo.createBooking(booking);
      _bookings.insert(0, created);
      _setLoading(false);
      return created;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return null;
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    _setLoading(true);
    _error = null;
    try {
      await _repo.cancelBooking(bookingId);
      final index = _bookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        final old = _bookings[index];
        _bookings[index] = BookingModel(
          id: old.id,
          userId: old.userId,
          providerId: old.providerId,
          packTitle: old.packTitle,
          eventDate: old.eventDate,
          status: 'cancelled',
          totalPrice: old.totalPrice,
          paymentMethod: old.paymentMethod,
          notes: old.notes,
          createdAt: old.createdAt,
          provider: old.provider,
        );
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // ── Helpers ──

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}
