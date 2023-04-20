create database StudentTest;
use StudentTest;
create table Student(
RN int auto_increment primary key,
`name` varchar(20),
age tinyint,
`status` bit
);
create table Test(
TestId int primary key,
`name` varchar(30)
);
create table StudentTest(
RN int,
TestId int,
`date` datetime,
Mark float
); 

insert into Student(`name`,age) values
("Nguyen Hong Ha", 20),
("Truong Ngoc Anh", 30),
("Tuan Minh", 25),
("Đan Trường", 22);

insert into Test(TestId,`name`) values
(1,"EPC"),(2,"DWMX"),(3,"SQL1"),(4,"SQL2");

insert into StudentTest values
(1,1,"2016-7-17",8),
(1,2,"2016-7-18",5),
(1,3,"2016-7-19",7),
(2,1,"2016-7-17",7),
(2,2,"2016-7-18",4),
(2,3,"2016-7-19",2),
(3,1,"2016-7-17",10),
(3,3,"2016-7-18",1);

-- a.	Thêm ràng buộc dữ liệu cho cột age với giá trị thuộc khoảng: 15-55
alter table student
modify column age int check(age>=15 and age<=50);
-- b.	Thêm giá trị mặc định cho cột mark trong bảng StudentTest là 0
alter table StudentTest
modify column mark int default 0;
-- c.	Thêm khóa chính cho bảng studenttest là (RN,TestID)
alter table studenttest 
add constraint foreign_key foreign key (RN) references Student(RN) ;
alter table studenttest 
add constraint fk_foreign_key foreign key (TestId) references Test(TestId);
-- d.	Thêm ràng buộc duy nhất (unique) cho cột name trên bảng Test
ALTER TABLE Test 
ADD CONSTRAINT MyUniqueConstraint UNIQUE(`name`);
-- e.	Xóa ràng buộc duy nhất (unique) trên bảng Test
alter table test
drop constraint MyUniqueConstraint;
-- 3.	Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó
select @stt:=@stt + 1 as STT,  s.`name`, t.`name`, st.Mark, st.`date`
from (select @stt:= 0) as STT, Student s join studenttest st on s.RN = st.RN join Test t on t.TestId = st.TestId;
-- 4.	Hiển thị danh sách các bạn học viên chưa thi môn nào
select s.RN, s.`name`, s.age from Student s where `name` not in (select s.`name` from Student s join studenttest st on s.RN = st.RN);
-- 5.	Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi(điểm phải thi lại là điểm nhỏ hơn 5)
select s.`name`, t.`name`, st.Mark, st.`date`
from Student s join studenttest st on s.RN = st.RN join Test t on t.TestId = st.TestId where Mark < 5; 
-- 6.	Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. 
-- Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần(nếu không sắp xếp thì chỉ được ½ số điểm)
select s.`name`, avg(st.Mark) as TrungBinh
from Student s join studenttest st on s.RN = st.RN group by st.RN order by avg(st.Mark) desc;
-- 7.	Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất như sau:
select s.`name`, avg(st.Mark)  as TrungBinh
from Student s join studenttest st on s.RN = st.RN group by st.RN order by avg(st.Mark) desc limit 1;
-- 8.	Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học
select t.`name` as MônHọc, max(st.Mark) from Test t 
join studenttest st on t.TestId = st.TestId group by st.TestId order by t.`name` asc; 
-- 9.	Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null
select s.`name` as studentName, t.`name` as MonHoc from Student s left 
join studenttest st on s.RN = st.RN left join Test t on st.TestId = t.TestId;
-- 10.	Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update Student
set age = age + 1;
-- 11.	Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table Student
add column StudentStatus varchar(10);
-- 12.	Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 30 tuổi sẽ nhận giá trị ‘Young’, 
-- trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student lên
update student
set StudentStatus = case when age<30 then "Young" else "old" end;
-- 13.	Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi
select s.`name` as StudentName, st.Mark as DiemThi, st.`date`as NgayThi  from Student s 
join studenttest st on s.RN = st.RN order by st.`date` asc;
-- Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. 
-- Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select s.`name` as StudentName , avg(st.Mark) as DiemThiTB from Student s 
join studenttest st on s.RN = st.RN group by s.RN having s.`name` like "T%" and avg(st.Mark) > 4.5;
-- 15.	Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng). 
-- Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1.
select s.RN as Mã, s.`name` as Tên, avg(st.Mark) as ĐTB, rank() over(order by avg(st.Mark) desc) as XepHang from Student s
join studenttest st on s.RN = st.RN group by s.RN order by avg(st.Mark) desc;
-- 17.	Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau:
-- a.	Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
-- b.	Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)
update student
set `name` = case when age >20 then concat("Old",`name`)  else concat("Young",`name`) end;
-- 18.  Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
delete from Test where `name` not in (select s.`name` from Student s join studenttest st on s.RN = st.RN); 
-- 19.	Xóa thông tin điểm thi của sinh viên có điểm <5. 
delete from Studenttest where Mark < 5;
