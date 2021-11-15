--1. List all cities that have both Employees and Customers.
select distinct c.city from Employees e inner join Customers c on e.City = c.City -- inner join 
select distinct c.City from customers c where c.City in (select distinct e.City from Employees e) -- regular subquery

--2. List all cities that have Customers but no Employee.
--a. Use sub-query
select distinct c.City from customers c where c.City not in (select distinct e.City from Employees e) -- regular subquery
--b. Do not use sub-query
select distinct c.city from Employees e right join Customers c on e.City = c.City where e.City is null

--3. List all products and their total order quantities throughout all orders.
select ProductID, count(OrderID) "Total" from [Order Details] group by ProductID



--4. List all Customer Cities and total products ordered by that city.
select c.City,count(dt.[total products]) from Orders o inner join customers c on o.CustomerID = c.CustomerID inner join
(select od.OrderID,count(od.ProductID) "total products" from [Order Details] od group by od.OrderID) dt 
on o.OrderID = dt.OrderID
group by c.City


--5. List all Customer Cities that have at least two customers.
--a. Use union
select count(customerID)"NumOfCus",City from Customers  group by city  Having count(customerID) >1
--b. Use sub-query and no union


--6. List all Customer Cities that have ordered at least two different kinds of products.
select count( distinct od.ProductID),c.city
from [Order Details] od inner join Orders o on od.OrderID = o.OrderID inner join Customers c on o.CustomerID = c.CustomerID
group by c.city
order by c.city


--7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
select distinct c.CustomerID,c.City,o.ShipCity from Customers c inner join orders o on c.CustomerID = o.CustomerID where c.City <>o.ShipCity



--8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
select * from (select sub.ProductID,sub.avgPrice,sub.total,DENSE_RANK()over(order by sub.total desc) "rnk" from (select od.PRODUCTID, count(od.Quantity) "total",AVG(od.unitprice) "avgPrice" from [Order Details] od 
group by od.PRODUCTID) sub) rnk where rnk.rnk <=5

*/


--9. List all cities that have never ordered something but we have employees there.
--a. Use sub-query
select e.city from Employees e where e.City in
(Select c.city from customers c left join Orders o on c.CustomerID = o.CustomerID where o.CustomerID is null)
