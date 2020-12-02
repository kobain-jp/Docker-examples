CREATE TABLE IF NOT Exists book(book_id SERIAL, isbn BIGINT, title VARCHAR(50), author VARCHAR(50), release_date DATE);

INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 1',9784088716114,'井上雄彦','1991-02-08');
INSERT INTO book(title, isbn,  author, release_date) VALUES ('SLAM DUNK 2',9784088716121,'井上雄彦','1991-06-10');
INSERT INTO book(title, isbn,  author, release_date) VALUES ('リアル 1',9784088761435,'井上雄彦','2001-3-19');


