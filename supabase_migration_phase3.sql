-- ============================================================
-- FasMix Phase 3 - Supabase Migration (Social Features)
-- Run this in Supabase SQL Editor AFTER Phase 2 migration
-- ============================================================

-- 1. PLAYLISTS TABLE
CREATE TABLE IF NOT EXISTS playlists (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT NOT NULL,
  name TEXT NOT NULL,
  cover_url TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. PLAYLIST SONGS TABLE
CREATE TABLE IF NOT EXISTS playlist_songs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  playlist_id UUID NOT NULL REFERENCES playlists(id) ON DELETE CASCADE,
  song_id INT NOT NULL,
  position INT NOT NULL DEFAULT 0,
  added_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(playlist_id, song_id)
);

-- 3. REVIEWS TABLE
CREATE TABLE IF NOT EXISTS reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  song_id INT NOT NULL,
  device_id TEXT NOT NULL,
  rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(song_id, device_id)
);

-- 4. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_uid TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('new_follower', 'new_like', 'contest_update', 'donation')),
  title TEXT NOT NULL DEFAULT '',
  body TEXT NOT NULL DEFAULT '',
  data JSONB DEFAULT '{}',
  read BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- RLS POLICIES
-- ============================================================

ALTER TABLE playlists ENABLE ROW LEVEL SECURITY;
ALTER TABLE playlist_songs ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Playlists: read/write by device
CREATE POLICY "Allow read playlists" ON playlists FOR SELECT USING (true);
CREATE POLICY "Allow insert playlists" ON playlists FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow delete own playlists" ON playlists FOR DELETE USING (true);

-- Playlist songs: read/write
CREATE POLICY "Allow read playlist_songs" ON playlist_songs FOR SELECT USING (true);
CREATE POLICY "Allow insert playlist_songs" ON playlist_songs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow delete playlist_songs" ON playlist_songs FOR DELETE USING (true);

-- Reviews: read all, write own
CREATE POLICY "Allow read reviews" ON reviews FOR SELECT USING (true);
CREATE POLICY "Allow insert reviews" ON reviews FOR INSERT WITH CHECK (true);

-- Notifications: read own, authenticated users
CREATE POLICY "Allow read own notifications" ON notifications FOR SELECT USING (recipient_uid = auth.uid()::text);
CREATE POLICY "Allow update own notifications" ON notifications FOR UPDATE USING (recipient_uid = auth.uid()::text);
CREATE POLICY "Allow insert notifications" ON notifications FOR INSERT WITH CHECK (true);

-- ============================================================
-- INDEXES for performance
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_playlists_device_id ON playlists(device_id);
CREATE INDEX IF NOT EXISTS idx_playlist_songs_playlist_id ON playlist_songs(playlist_id);
CREATE INDEX IF NOT EXISTS idx_reviews_song_id ON reviews(song_id);
CREATE INDEX IF NOT EXISTS idx_notifications_recipient_uid ON notifications(recipient_uid);
CREATE INDEX IF NOT EXISTS idx_notifications_read ON notifications(recipient_uid, read);
CREATE INDEX IF NOT EXISTS idx_follows_artist_uid ON follows(artist_uid);
CREATE INDEX IF NOT EXISTS idx_follows_device_id ON follows(follower_device_id);
CREATE INDEX IF NOT EXISTS idx_donations_artist_uid ON donations(artist_uid);

-- ============================================================
-- HELPER VIEW: Reviews with average rating per song
-- ============================================================

CREATE OR REPLACE VIEW song_reviews_summary AS
SELECT
  song_id,
  COUNT(*) AS review_count,
  ROUND(AVG(rating)::numeric, 1) AS avg_rating
FROM reviews
GROUP BY song_id;
