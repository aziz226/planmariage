// TODO: Remplacer par vos identifiants Supabase
const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
const String supabaseAnonKey = 'YOUR_ANON_KEY';

class Tables {
  static const String profiles = 'profiles';
  static const String providers = 'providers';
  static const String reviews = 'reviews';
  static const String bookings = 'bookings';
  static const String favorites = 'favorites';
  static const String contactMessages = 'contact_messages';
}

class StorageBuckets {
  static const String avatars = 'avatars';
  static const String providerImages = 'provider-images';
}
