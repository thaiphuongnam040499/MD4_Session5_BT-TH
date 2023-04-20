create database Test2;
use Test2;
create table Subjects(
SubjectId int auto_increment primary key,
SubjectName varchar(30)
);
create table Students(
StudentId int auto_increment primary key,
StudentName varchar(50),
Age int,
email varchar(100)
);
create table Marks(
Mark int,
SubjectId int,
foreign key (SubjectId) references Subjects(SubjectId),
StudentId int,
foreign key (StudentId) references Students(StudentId)
);
create table Classes(
ClassId int auto_increment primary key,
ClassName varchar(50)
);

create table ClassStudent(
StudentId int,
foreign key (StudentId) references Students(StudentId),
ClassId int,
foreign key (ClassId) references Classes(ClassId)
);
DELIMITER //
create procedure addStudent(
in StName varchar(50),
in StAge int,
in email varchar(100)
)
begin
insert into Students(StudentName,Age,email) values(StName,StAge,email);
end //
DELIMITER ;
call addStudent("Nguyen Quang An", 18, "an@yahoo.com");
call addStudent("Nguyen Cong Vinh", 20, "vinh@yahoo.com");
call addStudent("Nguyen Van Quyen", 19, "quyen@yahoo.com");
call addStudent("Pham Thanh Binh", 25, "binh@yahoo.com");
call addStudent("Nguyen Van Tai Em", 30, "em@yahoo.com");

insert into Classes(ClassName) values
("C0706L"),
("C0708G");
insert into ClassStudent(StudentId,ClassId) values
(1,1),
(2,1),
(3,2),
(4,2),
(5,2);
insert into Subjects(SubjectName) values
("SQL"),
("Java"),
("C"),
("Visual Basic");
insert into Marks(Mark,SubjectId,StudentId) values
(8,1,1),
(4,2,1),
(9,1,1),
(7,1,3),
(3,1,4),
(5,2,5),
(8,3,3),
(1,3,5),
(3,2,4);
-- 1.	Hien thi danh sach tat ca cac hoc vien 
DELIMITER //
create procedure findAllStudent()
begin
select * from Students;
end //
DELIMITER ;
call findAllStudent; 
-- 2.	Hien thi danh sach tat ca cac mon hoc
DELIMITER //
create procedure findAllSubject()
begin
select * from Subjects;
end //
DELIMITER ;
call findAllSubject();
-- 3.	Tinh diem trung binh 
DELIMITER //
create procedure avgMark()
begin
select avg(m.Mark), s.studentId from Marks m join Students s on m.StudentId = s.StudentId group by StudentId;
end //
DELIMITER ;
call avgMark();
-- 4.	Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
DELIMITER //
create procedure showMaxMarkSubject()
begin
select max(m.Mark), sub.SubjectName from Marks m join Subjects sub on m.SubjectId = sub.SubjectId 
group by sub.SubjectId order by max(m.Mark) desc limit 1;
end //
DELIMITER ;
call showMaxMarkSubject();
-- 5.	Danh so thu tu cua diem theo chieu giam
DELIMITER //
create procedure sortMark()
begin 
select Mark from Marks order by Mark desc;
end //
DELIMITER ;
call sortMark();
-- 7.	Cap nhat them dong chu « Day la mon hoc «  vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
DELIMITER //
create procedure updtateSubject(
in upSubName varchar(30)
)
begin
update Subjects
set SubjectName = concat(upSubName , SubjectName);
end //
DELIMITER ;
call updtateSubject("Day la mon hoc");
-- 8.	Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
DELIMITER //
create procedure checkAge()
begin
select age from Students having (Age >15 and Age<50);
end // 
DELIMITER ;
call checkAge();
-- 9.	Loai bo tat ca quan he giua cac bang
alter table ClassStudent
drop foreign key StudentId;
-- 10.	Xoa hoc vien co StudentID la 1
DELIMITER //
create procedure delStudent(
in idDel int
)
begin
delete from Students where StudentId = idDel;
end //
DELIMITER ;
call delStudent(1);
-- 11.	Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table Students
add column `status` bit default 1;
-- 12.	Cap nhap gia tri Status trong bang Student thanh 0
update Students
set `status`= 0;
drop procedure if exists `delStudent`