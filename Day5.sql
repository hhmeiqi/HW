
--Write queries for following scenarios
--1.Write an sql statement that will display the name of each customer and the sum of order totals placed by that customer during the year 2002
 --Create table customer(cust_id int,  iname varchar (50)) create table order(order_id int,cust_id int,amount money,order_date smalldatetime)
create table customer(cust_id int, iname varchar(50))
create table [order](order_id int, cust_id int, amount money, order_date
smalldatetime)
select c.iname, sum(o.amount) total from customer c
left join [order] o
on c.cust_id = o.cust_id
where year(order_date)=2002
group by c.iname

--2. The following table is used to store information about company’s personnel:
--Create table person (id int, firstname varchar(100), lastname varchar(100)) write a query that returns all employees whose last names  start with “A”.
create table person(id int, firstanme varchar(100), lastname varchar(100))
select * from person where lastname like 'A%'

--3. The information about company’s personnel is stored in the following table:
--Create table person(person_id int primary key, manager_id int null, name varchar(100)not null) The filed managed_id contains the person_id of the employee’s manager.
--Please write a query that would return the names of all top managers(an employee who does not have  a manger, and the number of people that report directly to this manager.
create table person(person_id int primary key,manager_id int null, name varchar(100) not null)
select sub.name, count(*) from person p
left join
(select * from person p where manager_id is null) sub
on p.person_id= sub.manager_id
group by sub.name




--4.  List all events that can cause a trigger to be executed.
--Insert, delete, update


--5. Generate a destination schema in 3rd Normal Form.  Include all necessary fact, join, and dictionary tables, and all Primary and Foreign Key relationships.  The following assumptions can be made:
--a. Each Company can have one or more Divisions.
--b. Each record in the Company table represents a unique combination 
--c. Physical locations are associated with Divisions.
--d. Some Company Divisions are collocated at the same physical of Company Name and Division Name.
--e. Contacts can be associated with one or more divisions and the address, but are differentiated by suite/mail drop records.status of each association should be separately maintained and audited.
create table Company(companyid int primary key, companyname varchar(20) not null)
create table Division(divisionid int primary key, divisionname varchar(20) not null, companyid int foreign key references company(companyid))
create table Contacts(companyid int foreign key references company(companyid), divisionid int foreign key references Division(divisionid), primary key(companyid, divisionid))
create table Physical_location(locationid int primary key, locationDes varchar(20) not null,divisionid int foreign key references Division(divisionid))
create table Contacts_address(suitid int primary key,divisionid int foreign key references Division(divisionid),  mail varchar(20))




