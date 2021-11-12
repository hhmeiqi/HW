1.select distinct c.city
from Employees e inner join Customers c on e.City = c.City
2. a. with sub-query
	Select distinct c.City FROM customers c where c.City not in
	(select distinct e.City from Employees e)
   b. without sub-query  
	select  distinct  c.City
	from Employees e right join Customers c on e.City = c.City
	where e.EmployeeID is null
3. select ProductID, count(OrderID) "Total" from [Order Details] group by ProductID
4. select o.ShipCity, count(o.orderid) "total" from Orders o group by o.ShipCity
5. select count(customerID)"NumOfCus",City from Customers  group by city  Having count(customerID) >1
6. select o.ShipCity,COUNT(od.productid) from orders o right join [Order Details] od on o.OrderID = od.OrderID group by o.ShipCity
7. select distinct sub.CustomerID,o.ShipCity,sub.City from orders o left join (select c.CustomerID,c.City from Customers c) sub on o.CustomerID = sub.CustomerID
   where o.ShipCity <> sub.City