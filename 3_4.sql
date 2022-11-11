-- создание базы данных для работы
DROP TABLE IF EXISTS department;
DROP TABLE IF EXISTS subject;
DROP TABLE IF EXISTS program;
DROP TABLE IF EXISTS enrollee;
DROP TABLE IF EXISTS achievement;
DROP TABLE IF EXISTS enrollee_achievement;
DROP TABLE IF EXISTS program_subject;
DROP TABLE IF EXISTS program_enrollee;
DROP TABLE IF EXISTS enrollee_subject;

CREATE TABLE department(
    department_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_department VARCHAR(30)
);
INSERT INTO department(name_department)
VALUES
    ('Инженерная школа'),
    ('Школа естественных наук');

CREATE TABLE subject(
    subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_subject VARCHAR(30)
);
INSERT INTO subject(name_subject)
VALUES
    ('Русский язык'),
    ('Математика'),
    ('Физика'),
    ('Информатика');

CREATE TABLE program(
    program_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_program VARCHAR(50),
    department_id INT,
    plan INT,
    FOREIGN KEY department(department_id) REFERENCES department(department_id) ON DELETE CASCADE
);
INSERT INTO program(name_program, department_id, plan)
VALUES
    ('Прикладная математика и информатика', 2, 2),
    ('Математика и компьютерные науки', 2, 1),
    ('Прикладная механика', 1, 2),
    ('Мехатроника и робототехника', 1, 3);

CREATE TABLE enrollee(
    enrollee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_enrollee VARCHAR(50)
);
INSERT INTO enrollee(name_enrollee)
VALUES
    ('Баранов Павел'),
    ('Абрамова Катя'),
    ('Семенов Иван'),
    ('Яковлева Галина'),
    ('Попов Илья'),
    ('Степанова Дарья');

CREATE TABLE achievement(
    achievement_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name_achievement VARCHAR(30),
    bonus INT
);
INSERT INTO achievement(name_achievement, bonus)
VALUES
    ('Золотая медаль', 5),
    ('Серебряная медаль', 3),
    ('Золотой значок ГТО', 3),
    ('Серебряный значок ГТО    ', 1);

CREATE TABLE enrollee_achievement(
    enrollee_achiev_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    enrollee_id INT,
    achievement_id INT,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY achievement(achievement_id) REFERENCES achievement(achievement_id) ON DELETE CASCADE
);
INSERT INTO enrollee_achievement(enrollee_id, achievement_id)
VALUES
    (1, 2),
    (1, 3),
    (3, 1),
    (4, 4),
    (5, 1),
    (5, 3);

CREATE TABLE program_subject(
    program_subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    program_id INT,
    subject_id INT,
    min_result INT,
    FOREIGN KEY program(program_id) REFERENCES program(program_id) ON DELETE CASCADE,
    FOREIGN KEY subject(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
);
INSERT INTO program_subject(program_id, subject_id, min_result)
VALUES
    (1, 1, 40),
    (1, 2, 50),
    (1, 4, 60),
    (2, 1, 30),
    (2, 2, 50),
    (2, 4, 60),
    (3, 1, 30),
    (3, 2, 45),
    (3, 3, 45),
    (4, 1, 40),
    (4, 2, 45),
    (4, 3, 45);

CREATE TABLE program_enrollee(
    program_enrollee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    program_id INT,
    enrollee_id INT,
    FOREIGN KEY program(program_id) REFERENCES program(program_id) ON DELETE CASCADE,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE
);
INSERT INTO program_enrollee(program_id, enrollee_id)
VALUES
    (3, 1),
    (4, 1),
    (1, 1),
    (2, 2),
    (1, 2),
    (1, 3),
    (2, 3),
    (4, 3),
    (3, 4),
    (3, 5),
    (4, 5),
    (2, 6),
    (3, 6),
    (4, 6);

CREATE TABLE enrollee_subject(
    enrollee_subject_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    enrollee_id INT,
    subject_id INT,
    result INT,
    FOREIGN KEY enrollee(enrollee_id) REFERENCES enrollee(enrollee_id) ON DELETE CASCADE,
    FOREIGN KEY subject(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE
);
INSERT INTO enrollee_subject(enrollee_id, subject_id, result)
VALUES
    (1, 1, 68),
    (1, 2, 70),
    (1, 3, 41),
    (1, 4, 75),
    (2, 1, 75),
    (2, 2, 70),
    (2, 4, 81),
    (3, 1, 85),
    (3, 2, 67),
    (3, 3, 90),
    (3, 4, 78),
    (4, 1, 82),
    (4, 2, 86),
    (4, 3, 70),
    (5, 1, 65),
    (5, 2, 67),
    (5, 3, 60),
    (6, 1, 90),
    (6, 2, 92),
    (6, 3, 88),
    (6, 4, 94);




-- 3.4.2
CREATE TABLE applicant  AS 
SELECT program_id, enrollee_id, SUM(result) as    itog                 
FROM program_enrollee 
INNER JOIN enrollee_subject USING(enrollee_id)
INNER JOIN program_subject USING(program_id, subject_id)
INNER JOIN enrollee USING(enrollee_id)
INNER JOIN program USING(program_id)
GROUP BY program_id, enrollee_id
ORDER BY program_id, itog DESC;

select * from applicant;
-- 3.4.3
DELETE  FROM applicant using applicant
join program_subject using(program_id) 
join enrollee_subject using(subject_id,enrollee_id)
where  result<min_result;

select * from applicant;
-- 3.4.4
UPDATE applicant JOIN (
SELECT enrollee_id,   sum(if(bonus is NULL,0, bonus)) as   Бонус  
FROM enrollee_achievement 
LEFT JOIN achievement  using (achievement_id   )
GROUP BY enrollee_id 
) as  applicant using(enrollee_id)
SET itog = itog +  Бонус;


select * from applicant;
-- 3.4.5

CREATE TABLE applicant_order
 as( 
    select
    program_id, enrollee_id,itog 
    FROM applicant 
    );


DROP TABLE applicant;
SELECT * FROM applicant_order ORDER BY program_id, itog DESC;
-- 3.4.6
ALTER TABLE applicant_order  ADD str_id  VARCHAR(50) FIRST;

-- 3.4.7
SET @a := 0;
SET @b := 1;

UPDATE applicant_order
SET str_id = IF(@a = program_id, @b := @b + 1, @b := 1 +(@a := program_id)*0)
;
SELECT * FROM applicant_order;
-- 3.4.8
CREATE TABLE student
SELECT name_program, name_enrollee, itog FROM enrollee
JOIN applicant_order USING (enrollee_id)
JOIN program USING (program_id)
WHERE str_id<=plan
ORDER BY name_program, itog DESC;
select* from student;
-- 3.4.9
select* from student;