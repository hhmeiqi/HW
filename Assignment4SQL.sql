

--1. Lock tables Region, Territories, EmployeeTerritories and Employees. Insert following
--information into the database. In case of an error, no changes should be made to DB.
--a. A new region called “Middle Earth”;
--b. A new territory called “Gondor”, belongs to region “Middle Earth”;
--c. A new employee “Aragorn King” who's territory is “Gondor”.
--begin transaction 
--commit/rollback
begin tran
select * from Region with(holdlock)
select * from Employees with(holdlock)
select * from Territories with(holdlock)
select * from EmployeeTerritories with(holdlock)
insert into Region(RegionID,RegionDescription) values (5,'Middle Earth')
insert into Territories(TerritoryID,TerritoryDescription,RegionID) values(90123,'Gondor',5)
Insert into Employees(FirstName,LastName) values('Aragorn','King')
insert into EmployeeTerritories(EmployeeID,TerritoryID) VALUES(10,90123)
rollback

--2. Change territory “Gondor” to “Arnor”.
begin tran

UPDATE Territories set TerritoryDescription = 'Arnor' where TerritoryDescription = 'Gondor'

--3. Delete Region “Middle Earth”. (tip: remove referenced data first) (Caution: do not forget
--WHERE or you will delete everything.) In case of an error, no changes should be made to
--DB. Unlock the tables mentioned in question 1.
select * from region
select * from Employees
select * from EmployeeTerritories
select * from Territories
begin tran
delete from EmployeeTerritories where TerritoryID = 90123
delete from Territories where RegionID = 5
delete from region where RegionID = 5
commit tran

--4. Create a view named “view_product_order_[your_last_name]”, list all products and total
--ordered quantity for that product.
CREATE VIEW view_product_order_He AS
select od.ProductID,sum(od.Quantity) "TOTAL" from [Order Details] od
group by od.ProductID


--5. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept
--product id as an input and total quantities of order as output parameter.
CREATE PROCEDURE sp_product_order_quantity_He 
(@ product_id int,
@ total_quantity float output)as
begin
select @product_id= p.productid
from Products p
join [Order Details] od
on p.ProductID=od.ProductID
where sum(od.quantity)= @total_quantity
group by p.ProductID
end

--6. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept
--product name as an input and top 5 cities that ordered most that product combined
--with the total quantity of that product ordered from that city as output.
create proc sp_product_order_city_He
(@product_name varchar(20),
@order_city varchar(20) output)
as
begin
select @product_name=sub.productname from (select top 5 d.ProductID,
d.ProductName
from (select p.ProductID,p.ProductName,sum(od.quantity) s from Products p
inner join [Order Details] od
on p.ProductID = od.ProductID
group by p.ProductID, p.ProductName) d Order by d.s desc) sub
left join(
select * from (select sub2.productid, sub2.city, rank() over(partition by
productid order by q desc) rnk from
(select p.ProductID, c.city, sum(od.quantity) q from Customers c
join orders o on c.CustomerID= o.CustomerID
left join [Order Details] od on o.OrderID=od.OrderID
left join Products p on od.ProductID=p.ProductID
group by p.ProductID, c.City ) sub2 ) sub3 where sub3.rnk=1) r
on sub.productid= r.productid
where r.city =@order_city
end

--7. Lock tables Region, Territories, EmployeeTerritories and Employees. Create a stored
--procedure “sp_move_employees_[your_last_name]” that automatically find all
--employees in territory “Tory”; if more than 0 found, insert a new territory “Stevens
--Point” of region “North” to the database, and then move those employees to “Stevens Point”.
create proc sp_move_employees_He
@terroity_name char(50) = 'Tory'
as
if exists(select e.EmployeeID,count(t.TerritoryDescription) c from Territories t
join employeeterritories et on t.TerritoryID=et.TerritoryID
join Employees e on et.EmployeeID=e.EmployeeID
where TerritoryDescription=@terroity_name
group by e.EmployeeID
having  count(t.TerritoryDescription)>0)
begin
insert into Territories(TerritoryID,TerritoryDescription,RegionID) values
(90123,'Stevens Point',11)
insert into Region(RegionID,RegionDescription) values(11,'North')
end
go

--8. Create a trigger that when there are more than 100 employees in territory “Stevens
--Point”, move them back to Troy. (After test your code,) remove the trigger. Move those
--employees back to “Troy”, if any. Unlock the tables.
create trigger trg_ins_He on territories
for update as
if exists(select e.employeeid, count(t.TerritoryDescription)from Territories t
join employeeterritories et on t.TerritoryID=et.TerritoryID
join Employees e on et.EmployeeID=e.EmployeeID
where t.TerritoryDescription= 'stevens point'
group by e.EmployeeID
having count(t.TerritoryDescription)>100)
begin
update Territories set TerritoryDescription= 'Tory' where
TerritoryDescription='stevens point'
End
drop trigger trg_ins_He

--9. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has
--two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1,
--Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody
--Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a
--new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay.
--If any error occurred, no changes should be made to DB. (after test) Drop both tables
--and view.
create table people_He (id int,name char(20),cityid int)
create table city_He (cityid int,city char(20))
insert into people_He(id,name,cityid) values(1,'Aaron Rodgers',2)
insert into people_He(id,name,cityid) values(2,'Russell Wilson',1)
insert into people_He(id,name,cityid) values(3,'Jody Nelson',2)
insert into city_He(cityid,city) values(1,'Settle')
insert into city_He(cityid,city) values(2,'Green Bay')
create view Packers_Meiqi_He as
select p.id,p.name from people_He p join city_He c on p.cityid=c.cityid where c.city='Green Bay'
begin tran
rollback
drop table people_He
drop table city_He
drop view Packers_Meiqi_He

--10. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a
--new table “birthday_employees_your_last_name” and fill it with all employees that
--have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.

create proc sp_birthday_employees_He as
begin
select * into birthday_employees_He from
Employees
where month(BirthDate)=2
end
drop table birthday_employees_He


--11. Create a stored procedure named “sp_your_last_name_1” that returns all cites that
--have at least 2 customers who have bought no or only one kind of product. Create a
--stored procedure named “sp_your_last_name_2” that returns the same but using a
--different approach. (sub-query and no-sub-query).
create proc sp_He_1 as
select c.city, count(c.CustomerID) from Customers c
inner join (
select sub.CustomerID, count(sub.CustomerID) sub2 from (select distinct c.CustomerID,
p.ProductID from Products p
join [Order Details] od on p.ProductID=od.ProductID
join Orders o on od.OrderID=o.OrderID
join Customers c on o.CustomerID=c.CustomerID) sub
group by sub.CustomerID
having count(sub.CustomerID)<2) h
on c.CustomerID= h.CustomerID
group by city
having count(c.CustomerID) >1


--12. How do you make sure two tables have the same data?
--You can just use CHECKSUM TABLE and compare the results. 


--14.
select firstname +''+ lastname + middlename + '.' as fullname from table1

--15.
declare @student varchar(20)
declare @marks int
set @student
set @marks = (select max(marks) from student where sex='F')
print @student

--16.
declare @student varchar(20)
declare @marks int
set @student
set @marks= (select max(marks) from student order by sex)
print @student