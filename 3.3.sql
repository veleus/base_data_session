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
-- 3.3.2
SELECT name_enrollee  
FROM program_enrollee 
INNER JOIN enrollee using (enrollee_id )
INNER JOIN program  using (program_id )
where program_id = 4
order by name_enrollee; 
-- 3.3.3
SELECT name_program                          
FROM program 
INNER JOIN program_subject using (program_id )
INNER JOIN subject  using (subject_id )
where subject_id = 4
order by name_program  desc;
-- 3.3.4
SELECT name_subject  ,  count(enrollee_id ) AS Количество ,  MAX(result ) as   Максимум, MIN(result) as Минимум ,ROUND( AVG(result),1)  as Среднее                
FROM enrollee_subject 
INNER JOIN subject  using (subject_id )
GROUP BY name_subject 
order by name_subject   ; 
-- 3.3.5
SELECT name_program             
FROM program_subject 
INNER JOIN program  using (program_id  )
GROUP BY  name_program
HAVING MIN(min_result) >= 40 order by name_program;
-- 3.3.6
SELECT name_program, plan       
FROM program 

WHERE plan = (
         SELECT max(plan) 
         FROM program
      );
-- 3.3.7
SELECT name_enrollee,   sum(if(bonus is NULL,0, bonus)) as   Бонус  
FROM enrollee 
LEFT JOIN enrollee_achievement  using (enrollee_id   )
LEFT JOIN achievement  using (achievement_id   )

GROUP BY name_enrollee    
ORDER BY name_enrollee;
-- 3.3.8
SELECT name_department ,  program.name_program,  program.plan, count(enrollee_id ) as Количество, ROUND(count(enrollee_id )/plan, 2) as Конкурс 
FROM department 
INNER JOIN program  using (department_id)
INNER JOIN program_enrollee  using (program_id )
       
GROUP BY program_id                                                           
ORDER BY Конкурс desc;

-- 3.3.9
SELECT name_program                          
FROM program 
INNER JOIN program_subject using (program_id )
INNER JOIN subject  using (subject_id )

where name_subject = 'Информатика' OR name_subject = 'Математика'
group by name_program
having count(name_subject)= 2
order by name_program;
-- 3.3.10
SELECT name_program , name_enrollee   , SUM(result) as    itog                 
FROM program_enrollee 
INNER JOIN enrollee_subject USING(enrollee_id)
INNER JOIN program_subject USING(program_id, subject_id)
INNER JOIN enrollee USING(enrollee_id)
INNER JOIN program USING(program_id)
GROUP BY name_program, name_enrollee
ORDER BY name_program, itog DESC;
-- 3.3.11
select name_program, name_enrollee
from program 
join program_subject using(program_id) 
join enrollee_subject using(subject_id) 
join enrollee using(enrollee_id) 
join program_enrollee on program_enrollee.program_id =program.program_id and enrollee.enrollee_id=program_enrollee.enrollee_id
where result<min_result
group by name_program, name_enrollee
order by name_program, name_enrollee;
-- 3.3.12
SELECT name_program , name_enrollee   , SUM(result) as    itog                 
FROM program_enrollee 
INNER JOIN enrollee_subject USING(enrollee_id)
INNER JOIN program_subject USING(program_id, subject_id)
INNER JOIN enrollee USING(enrollee_id)
INNER JOIN program USING(program_id)
GROUP BY name_program, name_enrollee
ORDER BY name_program, itog DESC;
