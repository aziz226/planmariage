import 'package:flutter/foundation.dart';

import '../core/models.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // ── Getters ──

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.price);

  String get totalFormatted {
    final total = totalPrice;
    // Format avec séparateur de milliers
    final str = total.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return '$buffer FCFA';
  }

  // ── Actions ──

  void addProvider(ProviderModel provider) {
    // Vérifier si déjà dans le panier
    final exists = _items.any((item) => item.provider?.id == provider.id);
    if (exists) return;

    _items.add(CartItem(
      provider: provider,
      price: provider.priceFrom,
    ));
    notifyListeners();
  }

  void addPack(PackModel pack) {
    // Extraire le prix numérique depuis la chaîne
    final priceStr = pack.price.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(priceStr) ?? 0;

    _items.add(CartItem(
      pack: pack,
      price: price,
    ));
    notifyListeners();
  }

  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void removeProvider(String providerId) {
    _items.removeWhere((item) => item.provider?.id == providerId);
    notifyListeners();
  }

  bool containsProvider(String providerId) {
    return _items.any((item) => item.provider?.id == providerId);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
