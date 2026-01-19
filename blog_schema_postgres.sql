CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (username) VALUES
('alice'),
('bob'),
('carol'),
('dave'),
('eve'),
('frank'),
('grace');

INSERT INTO posts (user_id, title, body) VALUES
(1, 'First Post!', 'This is the body of the first post.'),
(2, 'Bob''s Thoughts', 'A penny for my thoughts.'),
(3, 'Carol''s Cooking Tips', 'Always taste as you go.'),
(4, 'Dave''s Travel Log', 'Visited the mountains today.'),
(5, 'Eve on Security', 'Use strong passwords everywhere.'),
(6, 'Frank''s Fitness Journey', 'Day 1 at the gym was tough!'),
(7, 'Grace and Gardening', 'Planted tomatoes and basil.');

INSERT INTO comments (post_id, user_id, comment) VALUES
(1, 2, 'Great first post, Alice!'),
(2, 1, 'Interesting thoughts, Bob.'),
(3, 4, 'Nice tips, Carol!'),
(4, 5, 'The mountains sound amazing!'),
(5, 6, 'Security is so important these days.'),
(6, 7, 'Good luck with your fitness goals!'),
(7, 3, 'Hope your garden grows well!');
