--Insert users (from both posts and comments)
INSERT INTO users (username)
SELECT DISTINCT username
FROM (
    SELECT username FROM bad_posts
    UNION
    SELECT username FROM bad_comments
) AS all_usernames
WHERE username IS NOT NULL;

-- Insert topics from bad_posts
INSERT INTO topics (name)
SELECT DISTINCT topic
FROM bad_posts
WHERE topic IS NOT NULL;

-- Insert posts with user_id and topic_id
INSERT INTO posts (user_id, topic_id, title, url, text_content)
SELECT
    u.id,
    t.id,
    LEFT(TRIM(bp.title), 100),
    NULLIF(TRIM(bp.url), ''),
    NULLIF(TRIM(bp.text_content), '')
FROM bad_posts bp
JOIN users u ON u.username = bp.username
JOIN topics t ON t.name = bp.topic
-- Only insert posts that meet content constraints
WHERE (
    (bp.url IS NULL AND bp.text_content IS NOT NULL)
    OR
    (bp.url IS NOT NULL AND bp.text_content IS NULL)
);

-- Step 4: Insert top-level comments (no threading in original data)
INSERT INTO comments (user_id, post_id, text_content)
SELECT
    u.id,
    p.id,
    TRIM(bc.text_content)
FROM bad_comments bc
JOIN users u ON u.username = bc.username
JOIN posts p ON p.id = bc.post_id;

-- Insert upvotes (value = 1)
-- Only include votes for posts that were successfully inserted
INSERT INTO votes (user_id, post_id, vote)
SELECT
    u.id,
    bp.id,
    1
FROM bad_posts bp
JOIN posts p ON p.id = bp.id
     , LATERAL regexp_split_to_table(bp.upvotes, ',') AS voter(username)
JOIN users u ON u.username = TRIM(voter.username)
WHERE bp.upvotes IS NOT NULL;

--Insert downvotes (value = -1)
-- Only include votes for posts that were successfully inserted
INSERT INTO votes (user_id, post_id, vote)
SELECT
    u.id,
    bp.id,
    -1
FROM bad_posts bp
JOIN posts p ON p.id = bp.id
     , LATERAL regexp_split_to_table(bp.downvotes, ',') AS voter(username)
JOIN users u ON u.username = TRIM(voter.username)
WHERE bp.downvotes IS NOT NULL;

-- Sanity check - count rows in all new tables
SELECT 'users' AS table, COUNT(*) FROM users
UNION ALL
SELECT 'topics', COUNT(*) FROM topics
UNION ALL
SELECT 'posts', COUNT(*) FROM posts
UNION ALL
SELECT 'comments', COUNT(*) FROM comments
UNION ALL
SELECT 'votes', COUNT(*) FROM votes;
