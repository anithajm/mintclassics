use mintclassics;
--- identify the totalorder placed vs totalquantity in stock for each product---
select o.productcode,sum(o.quantityordered) totalorder,(p.quantityinstock) totalstock
from orderdetails o , products p
where o.productcode = p.productcode
group by o.productcode
order by productcode,totalorder;
--- to identity the product which has minimum order / no order
select o.productcode,sum(o.quantityordered),p.productname,w.warehousename
from orderdetails o 
right join products p
on p.productcode = o.productcode
left join warehouses w 
on p.warehousecode = w.warehousecode
group by o.productcode,p.productname,w.warehousename
order by sum(o.quantityordered);
--- warehouse stock data analysis
select warehousename,sum(quantityinstock) totalstock
from products p
left join warehouses w
on p.warehousecode = w.warehousecode
group by w.warehousename
order by totalstock desc;
--- productline stock details
select warehousename,productline,sum(quantityinstock) totalstock
from products p
left join warehouses w
on p.warehousecode = w.warehousecode
group by warehousename,productline
order by totalstock desc;
--- stock vs order analysis
select p.productname,w.warehousename,p.quantityinstock,sum(o.quantityordered) totalorder,(p.quantityinstock- sum(o.quantityordered))currentstock
from products p
left join orderdetails o
on p.productcode=o.productcode
left join warehouses w 
on p.warehousecode = w.warehousecode
group by p.productname,w.warehousename,p.quantityinstock
order by currentstock desc;
---- revenue analysis
select warehousename, sum(quantityordered) totalorder,sum(quantityordered*priceeach) totalrevenue
from products p
inner join orderdetails o on p.productcode= o.productcode
right join warehouses w on w.warehousecode = p.warehousecode
group by warehousename
order by totalrevenue desc;
--- productline revenue
select productline, warehousename,sum(quantityordered) totalorder,sum(quantityordered*priceeach) totalrevenue
from products p
inner join orderdetails o on p.productcode= o.productcode
right join warehouses w on w.warehousecode = p.warehousecode
group by warehousename,productline
order by totalrevenue desc;
--- customer analysis
select c.customerNumber,c.customerName,count(o.ordernumber) totalorder
from customers c
left join orders o on
c.customerNumber=o.customerNumber
group by customerNumber
order by count(o.ordernumber);
--- employee analysis
select e.employeeNumber,e.firstname,e.lastname,e.jobtitle,count(o.orderNumber) totalsales
from employees e
left join customers c on
e.employeeNumber = c.salesRepEmployeeNumber
left join orders o on
c.customerNumber = o.customerNumber
where e.jobtitle = 'Sales Rep'
group by e.employeeNumber
order by totalsales desc;
--- pending orders analysis
select o.orderNumber,sum(o.quantityordered)QtyinProcess,orders.status,w.warehousename
from orderdetails o
left join orders 
on o.orderNumber = orders.orderNumber
left join products p on
o.productcode = p.productcode
left join warehouses w on
w.warehouseCode = p.warehouseCode
where orders.status= 'In Process'
group by o.orderNumber,w.warehousename
order by w.warehousename desc;
--- order vs shipment trend
select month(orderdate),month(shippedDate),year(shippeddate),sum(quantityordered) ordersplaced
from orders
left join orderdetails on
orders.ordernumber = orderdetails.ordernumber
where month(shippeddate) is not null
group by month(orderdate),month(shippeddate),year(shippeddate)
order by ordersplaced desc;