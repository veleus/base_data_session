
-- создание базы данных для работы
DROP TABLE IF EXISTS answer;
 DROP TABLE IF EXISTS question;
 DROP TABLE IF EXISTS testing;
 DROP TABLE IF EXISTS attempt;
 DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS student;

CREATE TABLE student (
student_id INTEGER PRIMARY KEY AUTO_INCREMENT,
name_student varchar(50) DEFAULT NULL
);

	
CREATE TABLE subject (
subject_id INTEGER PRIMARY KEY AUTO_INCREMENT,
name_subject varchar(30) DEFAULT NULL
);
	
CREATE TABLE attempt (
attempt_id INTEGER PRIMARY KEY AUTO_INCREMENT,
student_id int DEFAULT NULL,
subject_id int DEFAULT NULL,
date_attempt date DEFAULT NULL,
result int DEFAULT NULL,
CONSTRAINT attempt_ibfk_1 FOREIGN KEY (student_id) REFERENCES student (student_id) ON DELETE CASCADE,
CONSTRAINT attempt_ibfk_2 FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);
	
CREATE TABLE testing (
testing_id INTEGER PRIMARY KEY AUTO_INCREMENT,
attempt_id int DEFAULT NULL,
question_id int DEFAULT NULL,
answer_id int DEFAULT NULL,
CONSTRAINT testing_ibfk_1 FOREIGN KEY (attempt_id) REFERENCES attempt (attempt_id) ON DELETE CASCADE
);

CREATE TABLE question (
question_id INTEGER PRIMARY KEY AUTO_INCREMENT,
name_question varchar(100) DEFAULT NULL, 
subject_id int DEFAULT NULL,
CONSTRAINT question_ibfk_1 FOREIGN KEY (subject_id) REFERENCES subject (subject_id) ON DELETE CASCADE
);

CREATE TABLE answer (
answer_id INTEGER PRIMARY KEY AUTO_INCREMENT,
name_answer varchar(100) DEFAULT NULL,
question_id int DEFAULT NULL,
is_correct tinyint(1) DEFAULT NULL,
CONSTRAINT answer_ibfk_1 FOREIGN KEY (question_id) REFERENCES question (question_id) ON DELETE CASCADE
);

INSERT INTO subject (subject_id,name_subject) VALUES 
(1,'Основы SQL'),
(2,'Основы баз данных'),
(3,'Физика');

INSERT INTO student (student_id,name_student) VALUES
(1,'Баранов Павел'),
(2,'Абрамова Катя'),
(3,'Семенов Иван'),
(4,'Яковлева Галина');

INSERT INTO attempt (attempt_id,student_id,subject_id,date_attempt,result) VALUES
(1,1,2,'2020-03-23',67),
(2,3,1,'2020-03-23',100),
(3,4,2,'2020-03-26',0),
(4,1,1,'2020-04-15',33),
(5,3,1,'2020-04-15',67),
(6,4,2,'2020-04-21',100),
(7,3,1,'2020-05-17',33);

INSERT INTO question (question_id,name_question,subject_id) VALUES
(1,'Запрос на выборку начинается с ключевого слова:',1),
(2,'Условие, по которому отбираются записи, задается после ключевого слова:',1),
(3,'Для сортировки используется:',1),
(4,'Какой запрос выбирает все записи из таблицы student:',1),
(5,'Для внутреннего соединения таблиц используется оператор:',1),
(6,'База данных - это:',2),
(7,'Отношение - это:',2),
(8,'Концептуальная модель используется для',2),
(9,'Какой тип данных не допустим в реляционной таблице?',2);

INSERT INTO answer (answer_id,name_answer,question_id,is_correct) VALUES
(1,'UPDATE',1,0),
(2,'SELECT',1,1),
(3,'INSERT',1,0),
(4,'GROUP BY',2,0),
(5,'FROM',2,0),
(6,'WHERE',2,1),
(7,'SELECT',2,0),
(8,'SORT',3,0),
(9,'ORDER BY',3,1),
(10,'RANG BY',3,0),
(11,'SELECT * FROM student',4,1),
(12,'SELECT student',4,0),
(13,'INNER JOIN',5,1),
(14,'LEFT JOIN',5,0),
(15,'RIGHT JOIN',5,0),
(16,'CROSS JOIN',5,0),
(17,'совокупность данных, организованных по определенным правилам',6,1),
(18,'совокупность программ для хранения и обработки больших массивов информации',6,0),
(19,'строка',7,0),
(20,'столбец',7,0),
(21,'таблица',7,1),
(22,'обобщенное представление пользователей о данных',8,1),
(23,'описание представления данных в памяти компьютера',8,0),
(24,'база данных',8,0),
(25,'file',9,1),
(26,'INT',9,0),
(27,'VARCHAR',9,0),
(28,'DATE',9,0);

INSERT INTO testing (testing_id,attempt_id,question_id,answer_id) VALUES
(1,1,9,25),
(2,1,7,19),
(3,1,6,17),
(4,2,3,9),
(5,2,1,2),
(6,2,4,11),
(7,3,6,18),
(8,3,8,24),
(9,3,9,28),
(10,4,1,2),
(11,4,5,16),
(12,4,3,10),
(13,5,2,6),
(14,5,1,2),
(15,5,4,12),
(16,6,6,17),
(17,6,8,22),
(18,6,7,21),
(19,7,1,3),
(20,7,4,11),
(21,7,5,16);
-- 3.2.2
insert into  attempt(student_id , subject_id , date_attempt , result ) 
VALUE (1 , 2 ,NOW(), NULL   );
SELECT * FROM attempt;
-- 3.2.3
insert into testing(attempt_id, question_id)
select attempt_id, question_id
from question
join attempt using(subject_id)
where attempt_id =(select max(attempt_id)from attempt )
order by rand()
limit 3;
SELECT * FROM testing;
-- 3.2.4
UPDATE attempt
    SET result = (SELECT ROUND(SUM(is_correct)/3*100, 0)
        FROM answer INNER JOIN testing using(answer_id)
        WHERE attempt_id = 8)
    WHERE attempt_id = 8;
select * from attempt;
-- 3.2.5
DELETE FROM attempt WHERE date_attempt < "2020-05-01";
select * from attempt;
-- 3.2.6
insert into  attempt(student_id , subject_id , date_attempt , result ) 
VALUE (1 , 2 ,NOW(), NULL   );
SELECT * FROM attempt;
