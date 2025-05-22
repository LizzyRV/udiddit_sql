-- Table of registered users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(25) NOT NULL UNIQUE,
    CONSTRAINT valid_username CHECK (LENGTH(TRIM(username)) > 0)
);

-- Table of discussion topics
CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE,
    description VARCHAR(500),
    CONSTRAINT valid_topic_name CHECK (LENGTH(TRIM(name)) > 0)
);

-- Table of posts (each with either a URL or text content, not both)
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    url VARCHAR(4000),
    text_content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_title CHECK (LENGTH(TRIM(title)) > 0),
    CONSTRAINT only_one_content CHECK (
        (url IS NULL AND text_content IS NOT NULL) OR
        (url IS NOT NULL AND text_content IS NULL)
    )
);

-- Table of comments with support for nested threads
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    parent_comment_id INTEGER REFERENCES comments(id) ON DELETE CASCADE,
    text_content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_comment_text CHECK (LENGTH(TRIM(text_content)) > 0)
);

-- Table of post votes (only one vote per user per post)
CREATE TABLE votes (
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    vote SMALLINT NOT NULL CHECK (vote IN (1, -1)),
    PRIMARY KEY (user_id, post_id)
);

-- Indexes
CREATE INDEX idx_users_username ON users (username);
CREATE INDEX idx_topics_name ON topics (name);
CREATE INDEX idx_posts_created_at ON posts (created_at DESC);
CREATE INDEX idx_posts_user_id ON posts (user_id);
CREATE INDEX idx_posts_topic_id ON posts (topic_id);
CREATE INDEX idx_comments_parent ON comments (parent_comment_id);
CREATE INDEX idx_comments_post ON comments (post_id);
