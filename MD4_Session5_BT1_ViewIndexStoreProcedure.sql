create database Bai1;
use Bai1;
create table Products(
id int auto_increment primary key,
productCode varchar(4) not null,
productName varchar(30),
productPrice float not null,
productAmount int not null,
productDescription text,
productStatus bit
);
insert into Products(productCode,productName,productPrice,productAmount,productDescription,productStatus) values
("SP01","Quạt","100.0",100,null,1),
("SP02","Điều hòa","150.0",100,null,1),
("SP03","TiVi","2000.0",100,null,1),
("SP04","Tủ lạnh","3000.0",100,null,1);

-- Tạo index
select * from Products where productCode = "SP03";
create unique index index_productCode on Products(productCode);
explain select * from Products where productCode = "SP03";
create index index_productName_productPrice on Products(productName, productPrice); 
explain select * from Products where productName = "Điều hòa" and productPrice = 150.0;

-- Tạo view
create view products_view as 
select productCode , productName, productPrice, productStatus from Products;
select * from products_view;
-- Sửa đổi view 
create or replace view products_view as
select productCode , productName, productPrice,productDescription, productStatus from Products
where productName = "Tủ lạnh";
select * from products_view;
-- xóa view
drop view products_view;

-- Tạo store procedure 
DELIMITER //
create procedure findAllProducts()
begin
select * from Products;
end //
DELIMITER ;
call findAllProducts()
-- thêm sản phẩm mới
DELIMITER //
create procedure addProduct(
in proCodeUP varchar(4),
in proName varchar(30),
in proPrice float,
in proAmount int,
in proDes text,
in proSt bit
)
begin
insert into Products(productCode,productName,productPrice,productAmount,productDescription,productStatus) 
values (proCodeUp, proName, proPrice, proAmount,proDes,proSt);
end //
DELIMITER ;
call addProduct("SP09","Điều hòa","2000.0",100,null,1);
call findAllProducts();
-- Sửa sản phẩm theo id
DELIMITER //
create procedure updatePro
(in idu int,
in proCodeUP varchar(4),
in proName varchar(30),
in proPrice float,
in proAmount int,
in proDes text,
in proSt bit
)
begin
update Products 
set productCode = proCodeUp, productName = proName, productPrice = proPrice, productAmount = proAmount,productDescription = proDes,productStatus=proSt 
where id=idu;
end //
DELIMITER ;
call updatePro(2,"SP02","Rửa bát",160.0,990,"abc",0);
call findAllProducts();
-- xóa procedure
drop procedure if exists `addProduct`;
