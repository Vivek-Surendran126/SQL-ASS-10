create database school;
use school;

#creating table 
create table Teachers (ID int primary key , Name varchar(50),
Subject varchar(50), Experience int, Salary decimal(10,2));

#inserting values
Insert into teachers (id, name, subject, experience, salary) VALUES
(1, 'John Doe', 'Mathematics', 5, 50000.00),
(2, 'Jane Smith', 'Physics', 7, 55000.00),
(3, 'Tom Brown', 'Chemistry', 3, 48000.00),
(4, 'Lucy White', 'Biology', 8, 60000.00),
(5, 'James Green', 'History', 12, 65000.00),
(6, 'Emily Blue', 'Geography', 10, 62000.00),
(7, 'George Black', 'Literature', 9, 59000.00),
(8, 'Anna Gray', 'Art', 4, 52000.00);

#2.before trigger to make error message for salaries

delimiter //
create trigger before_insert_teacher
before insert on teachers
for each row
begin 
if new.salary<0 then
signal sqlstate '45000' 
set message_text ='Salary cannot be negative';
end if;
end //
delimiter ;
  
#3.creating teachers log table and storing details

create table teacher_log (
    teacher_id int,
    action varchar(50),
    timestamp datetime);
    #creating after insert trigger
    
delimiter //
create trigger after_insert_teacher
after insert on teachers
for each row
begin
    insert into teacher_log (teacher_id, action, timestamp)
    values (new.id, 'Insert', now());
end //
delimiter ;

insert into teachers (id,name,subject,experience,salary)
values(10,'donna brown','science',5,25000.00);

select*from teachers;
select* from teacher_log;

#4.creating before trigger when trying to delete teacher with more than 10 exp.
Delimiter //
create trigger before_delete_teacher
before delete on teachers
for each row
begin
  if old.experience > 10 then
        signal sqlstate '45000' set message_text = 
        'Cannot delete teacher with more than 10 years of experience';
   end if;
end //
delimiter ;

delete from teachers where id=5;

#5. creating after delete trigger to store deletion into log table
delimiter //
create trigger after_delete_teacher
after delete on  teachers
for each row
begin
   insert into teacher_log (teacher_id,action,timestamp)
   values (old.id,'delete',now());
   end//
   delimiter ;

delete from teachers where id=1;
select*from teacher_log;

