-- ============================================================
-- FasMix Phase 2 - Supabase Migration
-- Run this in Supabase SQL Editor
-- ============================================================

-- 1. CONTESTS TABLE
CREATE TABLE IF NOT EXISTS contests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL DEFAULT '',
  start_date TIMESTAMPTZ NOT NULL,
  end_date TIMESTAMPTZ NOT NULL,
  prize TEXT NOT NULL DEFAULT '',
  rules JSONB DEFAULT '{}',
  status TEXT NOT NULL DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'active', 'ended')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 2. CONTEST ENTRIES TABLE
CREATE TABLE IF NOT EXISTS contest_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contest_id UUID NOT NULL REFERENCES contests(id) ON DELETE CASCADE,
  song_id INT NOT NULL,
  artist_uid TEXT NOT NULL,
  votes INT NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(contest_id, song_id)
);

-- 3. CONTEST VOTES TABLE
CREATE TABLE IF NOT EXISTS contest_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  contest_entry_id UUID NOT NULL REFERENCES contest_entries(id) ON DELETE CASCADE,
  device_id TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(contest_entry_id, device_id)
);

-- 4. FOLLOWS TABLE
CREATE TABLE IF NOT EXISTS follows (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  follower_device_id TEXT NOT NULL,
  artist_uid TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(follower_device_id, artist_uid)
);

-- 5. DONATIONS TABLE
CREATE TABLE IF NOT EXISTS donations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  donor_device_id TEXT NOT NULL,
  artist_uid TEXT NOT NULL,
  amount INT NOT NULL DEFAULT 0,
  currency TEXT NOT NULL DEFAULT 'XOF',
  payment_ref TEXT DEFAULT '',
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ============================================================
-- RPC FUNCTIONS
-- ============================================================

-- Vote for a contest entry (with device dedup)
CREATE OR REPLACE FUNCTION api_vote_contest(p_entry_id UUID, p_device_id TEXT)
RETURNS VOID AS $$
BEGIN
  -- Insert vote (will fail on duplicate due to UNIQUE constraint)
  INSERT INTO contest_votes (contest_entry_id, device_id)
  VALUES (p_entry_id, p_device_id);

  -- Increment votes count on entry
  UPDATE contest_entries
  SET votes = votes + 1
  WHERE id = p_entry_id;
END;
$$ LANGUAGE plpgsql;

-- Get contest leaderboard
CREATE OR REPLACE FUNCTION api_get_contest_leaderboard(p_contest_id UUID)
RETURNS TABLE (
  entry_id UUID,
  song_id INT,
  artist_uid TEXT,
  votes INT,
  nom_artiste TEXT,
  music_titre TEXT,
  music_img TEXT,
  pro_img TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ce.id AS entry_id,
    ce.song_id,
    ce.artist_uid,
    ce.votes,
    a."nomArtiste" AS nom_artiste,
    m."musicTitre" AS music_titre,
    m."musicImg" AS music_img,
    a."proImg" AS pro_img
  FROM contest_entries ce
  JOIN artists a ON a.uid = ce.artist_uid
  JOIN musics m ON m.id = ce.song_id
  WHERE ce.contest_id = p_contest_id
  ORDER BY ce.votes DESC;
END;
$$ LANGUAGE plpgsql;

-- Toggle follow (follow/unfollow)
CREATE OR REPLACE FUNCTION api_toggle_follow(p_device_id TEXT, p_artist_uid TEXT)
RETURNS BOOLEAN AS $$
DECLARE
  existed BOOLEAN;
BEGIN
  -- Check if already following
  DELETE FROM follows
  WHERE follower_device_id = p_device_id AND artist_uid = p_artist_uid
  RETURNING TRUE INTO existed;

  IF existed THEN
    -- Unfollowed: decrement followers
    UPDATE artists SET followers = GREATEST(followers - 1, 0)
    WHERE uid = p_artist_uid;
    RETURN FALSE; -- not following anymore
  ELSE
    -- Follow: insert + increment
    INSERT INTO follows (follower_device_id, artist_uid)
    VALUES (p_device_id, p_artist_uid);

    UPDATE artists SET followers = followers + 1
    WHERE uid = p_artist_uid;
    RETURN TRUE; -- now following
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Enable RLS on new tables
ALTER TABLE contests ENABLE ROW LEVEL SECURITY;
ALTER TABLE contest_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE contest_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE donations ENABLE ROW LEVEL SECURITY;

-- Allow read access to all authenticated and anon users
CREATE POLICY "Allow read contests" ON contests FOR SELECT USING (true);
CREATE POLICY "Allow read contest_entries" ON contest_entries FOR SELECT USING (true);
CREATE POLICY "Allow read contest_votes" ON contest_votes FOR SELECT USING (true);
CREATE POLICY "Allow read follows" ON follows FOR SELECT USING (true);
CREATE POLICY "Allow read donations" ON donations FOR SELECT USING (true);

-- Allow insert for contest votes and follows (anon users can vote/follow via device_id)
CREATE POLICY "Allow insert contest_votes" ON contest_votes FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow insert follows" ON follows FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow delete follows" ON follows FOR DELETE USING (true);
CREATE POLICY "Allow insert donations" ON donations FOR INSERT WITH CHECK (true);

-- Contest entries: only authenticated artists can enter
CREATE POLICY "Allow insert contest_entries" ON contest_entries FOR INSERT WITH CHECK (auth.uid()::text = artist_uid);
