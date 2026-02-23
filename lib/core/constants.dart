// TODO: Remplacer par vos identifiants Supabase
const String supabaseUrl = 'https://vdexbodmlffqcybjvvnw.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkZXhib2RtbGZmcWN5Ymp2dm53Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4MDAzMzMsImV4cCI6MjA4NzM3NjMzM30.EwFSigmjjHkhfCKB4Gx6VGADYgqkFZJ9xWQDUeUS56o';

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
