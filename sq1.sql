CREATE TABLE author (
    author_id INT PRIMARY KEY AUTO_INCREMENT,
    name_author VARCHAR(50)
);

INSERT INTO author (name_author)
VALUES ('Булгаков М.А.'),
       ('Достоевский Ф.М.'),
       ('Есенин С.А.'),
       ('Пастернак Б.Л.'),
       ('Лермонтов М.Ю.');
DROP TABLE IF EXISTS genre;
CREATE TABLE genre (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    name_genre VARCHAR(30)
);

INSERT INTO genre(name_genre)
VALUES ('Роман'),
       ('Поэзия'),
       ('Приключения');
DROP TABLE IF EXISTS book;
CREATE TABLE book (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    author_id INT NOT NULL,
    genre_id INT,
    price DECIMAL(8, 2),
    amount INT,
    FOREIGN KEY (author_id)
        REFERENCES author (author_id)
        ON DELETE CASCADE,
    FOREIGN KEY (genre_id)
        REFERENCES genre (genre_id)
        ON DELETE SET NULL
);

INSERT INTO book (title, author_id, genre_id, price, amount)
VALUES  ('Мастер и Маргарита', 1, 1, 670.99, 3),
        ('Белая гвардия ', 1, 1, 540.50, 5),
        ('Идиот', 2, 1, 460.00, 10),
        ('Братья Карамазовы', 2, 1, 799.01, 2),
        ('Игрок', 2, 1, 480.50, 10),
        ('Стихотворения и поэмы', 3, 2, 650.00, 15),
        ('Черный человек', 3, 2, 570.20, 6),
        ('Лирика', 4, 2, 518.99, 2);
DROP TABLE IF EXISTS city;

CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    name_city VARCHAR(30),
    days_delivery INT
);

INSERT INTO city(name_city, days_delivery)
VALUES ('Москва', 5),
       ('Санкт-Петербург', 3),
       ('Владивосток', 12);
DROP TABLE IF EXISTS client;
CREATE TABLE client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    name_client VARCHAR(50),
    city_id INT,
    email VARCHAR(30),
    FOREIGN KEY (city_id) REFERENCES city (city_id)
);

INSERT INTO client(name_client, city_id, email)
VALUES ('Баранов Павел', 3, 'baranov@test'),
       ('Абрамова Катя', 1, 'abramova@test'),
       ('Семенонов Иван', 2, 'semenov@test'),
       ('Яковлева Галина', 1, 'yakovleva@test');
DROP TABLE IF EXISTS buy;
CREATE TABLE buy(
    buy_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_description VARCHAR(100),
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES client (client_id)
);
INSERT INTO buy (buy_description, client_id)
VALUES ('Доставка только вечером', 1),
       (NULL, 3),
       ('Упаковать каждую книгу по отдельности', 2),
       (NULL, 1);

DROP TABLE IF EXISTS buy_book;
CREATE TABLE buy_book (
    buy_book_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    book_id INT,
    amount INT,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (book_id) REFERENCES book (book_id)
);

INSERT INTO buy_book(buy_id, book_id, amount)
VALUES (1, 1, 1),
       (1, 7, 2),
       (1, 3, 1),
       (2, 8, 2),
       (3, 3, 2),
       (3, 2, 1),
       (3, 1, 1),
       (4, 5, 1);

DROP TABLE IF EXISTS step;
CREATE TABLE step (
    step_id INT PRIMARY KEY AUTO_INCREMENT,
    name_step VARCHAR(30)
);

INSERT INTO step(name_step)
VALUES ('Оплата'),
       ('Упаковка'),
       ('Транспортировка'),
       ('Доставка');

DROP TABLE IF EXISTS buy_step;
CREATE TABLE buy_step (
    buy_step_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id INT,
    step_id INT,
    date_step_beg DATE,
    date_step_end DATE,
    FOREIGN KEY (buy_id) REFERENCES buy (buy_id),
    FOREIGN KEY (step_id) REFERENCES step (step_id)
);

INSERT INTO buy_step(buy_id, step_id, date_step_beg, date_step_end)
VALUES (1, 1, '2020-02-20', '2020-02-20'),
       (1, 2, '2020-02-20', '2020-02-21'),
       (1, 3, '2020-02-22', '2020-03-07'),
       (1, 4, '2020-03-08', '2020-03-08'),
       (2, 1, '2020-02-28', '2020-02-28'),
       (2, 2, '2020-02-29', '2020-03-01'),
       (2, 3, '2020-03-02', NULL),
       (2, 4, NULL, NULL),
       (3, 1, '2020-03-05', '2020-03-05'),
       (3, 2, '2020-03-05', '2020-03-06'),
       (3, 3, '2020-03-06', '2020-03-10'),
       (3, 4, '2020-03-11', NULL),
       (4, 1, '2020-03-20', NULL),
       (4, 2, NULL, NULL),
       (4, 3, NULL, NULL),
       (4, 4, NULL, NULL);


SELECT buy_book.buy_id, title, price, buy_book.amount
FROM 
    client 
    INNER JOIN buy ON client.client_id = buy.client_id
    INNER JOIN buy_book ON buy_book.buy_id = buy.buy_id
    INNER JOIN book ON buy_book.book_id=book.book_id
WHERE name_client LIKE 'Баранов Павел'
ORDER BY buy_book.buy_id, title;


SELECT author.name_author, book.title, COUNT(buy_book.book_id) AS Количество
FROM
    book
    INNER JOIN author ON author.author_id = book.author_id
    LEFT JOIN buy_book ON buy_book.book_id = book.book_id
    LEFT JOIN buy ON buy.buy_id = buy_book.buy_id
GROUP BY author.name_author, book.title
ORDER BY author.name_author, book.title;


SELECT city.name_city, COUNT(client_id) AS Количество
FROM buy
    INNER JOIN client USING (client_id)
    INNER JOIN city USING (city_id)
GROUP BY buy.client_id
ORDER BY Количество DESC, name_city;


SELECT buy_id, date_step_end 
FROM step
    INNER JOIN buy_step ON step.step_id = buy_step.step_id
WHERE buy_step.step_id = 1 and date_step_end IS NOT Null;

SELECT buy_id, name_client, SUM(price * buy_book.amount) as Стоимость
FROM buy
    INNER JOIN client using(client_id)
    INNER JOIN buy_book using(buy_id)
    INNER JOIN book using(book_id)
GROUP BY buy_book.buy_id
ORDER BY 1;


SELECT buy_id, name_step
FROM buy_step
     JOIN step USING(step_id)
WHERE date_step_beg IS NOT NULL and date_step_end IS NULL
ORDER BY buy_id;

SELECT buy_id, DATEDIFF(date_step_end, date_step_beg) AS Количество_дней, 
        IF(DATEDIFF(date_step_end, date_step_beg)<=days_delivery, 0, DATEDIFF(date_step_end, date_step_beg) -               days_delivery) AS Опоздание
FROM buy_step JOIN buy USING(buy_id)
              JOIN client USING(client_id)
              JOIN city USING(city_id)              
WHERE step_id=3 AND DATEDIFF(date_step_end, date_step_beg) IS NOT NULL
ORDER BY 1;

SELECT DISTINCT name_client
FROM client
    INNER JOIN buy USING (client_id)
    INNER JOIN buy_book USING (buy_id)
    INNER JOIN book USING (book_id)
    INNER JOIN author USING (author_id)
WHERE name_author LIKE "Достоевский%"
ORDER BY name_client;


SELECT name_genre, Количество
FROM
    (SELECT name_genre, sum(amount_1) as Количество
        FROM (SELECT book_id, SUM(amount) AS amount_1
        FROM buy_book
        GROUP BY book_id) AS temp
        INNER JOIN book ON temp.book_id = book.book_id
        INNER JOIN genre ON book.genre_id = genre.genre_id
        GROUP BY name_genre) as k
        where k.Количество IN (SELECT MAX(t.Количество) as n
                               FROM( SELECT name_genre, sum(amount_1) as Количество
                               FROM (SELECT book_id, SUM(amount) AS amount_1
                               FROM buy_book
                               GROUP BY book_id) AS temp
                               INNER JOIN book ON temp.book_id = book.book_id
                               INNER JOIN genre ON book.genre_id = genre.genre_id
                               GROUP BY name_genre) as t);
                               
                               
DROP TABLE IF EXISTS buy_archive;

CREATE TABLE buy_archive
(
    buy_archive_id INT PRIMARY KEY AUTO_INCREMENT,
    buy_id         INT,
    client_id      INT,
    book_id        INT,
    date_payment   DATE,
    price          DECIMAL(8, 2),
    amount         INT
);

INSERT INTO buy_archive (buy_id, client_id, book_id, date_payment, amount, price)
VALUES (2, 1, 1, '2019-02-21', 2, 670.60),
       (2, 1, 3, '2019-02-21', 1, 450.90),
       (1, 2, 2, '2019-02-10', 2, 520.30),
       (1, 2, 4, '2019-02-10', 3, 780.90),
       (1, 2, 3, '2019-02-10', 1, 450.90),
       (3, 4, 4, '2019-03-05', 4, 780.90),
       (3, 4, 5, '2019-03-05', 2, 480.90),
       (4, 1, 6, '2019-03-12', 1, 650.00),
       (5, 2, 1, '2019-03-18', 2, 670.60),
       (5, 2, 4, '2019-03-18', 1, 780.90);
       
SELECT YEAR(date_payment) AS Год,
	   MONTHNAME(date_payment) AS Месяц,
	   SUM(amount*price) AS Сумма
FROM buy_archive
GROUP BY Год, Месяц

UNION ALL
SELECT YEAR(date_step_end) AS Год,
	   MONTHNAME(date_step_end) AS Месяц,
	   SUM(bb.amount*price) AS Сумма
FROM buy_book bb
      JOIN buy_step bs ON bb.buy_id = bs.buy_id 
  				  AND bs.date_step_end 
  				  AND bs.step_id = 1
      JOIN book USING(book_id)
GROUP BY Год, Месяц
ORDER BY Месяц, Год;

WITH Title_sales AS (
SELECT title, buy_book.amount, price
FROM book
    INNER JOIN buy_book USING(book_id)
    INNER JOIN buy USING(buy_id) 
    INNER JOIN buy_step USING(buy_id)
    INNER JOIN step USING(step_id)
WHERE  date_step_end IS NOT Null and name_step = "Оплата"
    
UNION ALL
    
SELECT title, buy_archive.amount, buy_archive.price
    FROM buy_archive
    INNER JOIN book USING(book_id)
)
SELECT title, SUM(amount) AS Количество, SUM(amount*price) AS Сумма
FROM Title_sales
GROUP BY title
ORDER BY Сумма DESC;
