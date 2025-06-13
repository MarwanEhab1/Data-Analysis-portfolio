

use BikeStores;


select 
	ord.order_id,
	CONCAT(cus.first_name,' ' ,cus.last_name) as Customers,
	cus.state,
	cus.city,
	ord.order_date,
	pt.product_name,
	cat.category_name,
	sto.store_name,
	CONCAT(st.first_name,' ' ,st.last_name) as 'Sales_rep',
	sum(ite.quantity) as 'Total_Units',
	sum(ite.quantity * ite.list_price) as 'Revenue'
from  sales.orders as ord
join sales.customers as cus
on cus.customer_id= ord.customer_id
join sales.order_items ite
on ord.order_id=ite.order_id
join production.products as pt
on pt.product_id=ite.product_id
join production.categories as cat
on cat.category_id=pt.category_id
join Sales.stores as sto
on sto.store_id=ord.store_id
join Sales.staffs as st
on st.staff_id=ord.staff_id
group by ord.order_id,
	CONCAT(cus.first_name,' ' ,cus.last_name),
	cus.state,
	cus.city,
	ord.order_date,
	cat.category_name,
	sto.store_name,
	CONCAT(st.first_name,' ' ,st.last_name),
	pt.product_name
;


-- Description: Show total number of orders and sales value for each store
select sto.store_name ,
COUNT(distinct ord.order_id) AS total_orders,
SUM(ite.quantity * ite.list_price * (1-ite.discount)) AS total_sales
from 
sales.order_items as ite
join Sales.orders as ord
on ord.order_id = ite.order_id
join Sales.stores as sto
on sto.store_id = ord.store_id 
group by sto.store_name 
order by total_sales desc 
;

-- Description: Identify the 5 customers who spent the most
select top 5 
 CONCAT(cus.first_name,' ',cus.last_name) as 'Full Name',
 cast (SUM(ite.quantity * ite.list_price *(1-ite.discount)) as decimal (20,2)) AS total_sales
from Sales.customers as cus
join Sales.orders as ord
on cus.customer_id=ord.customer_id
join Sales.order_items as ite
on ite.order_id=ord.order_id
group by  CONCAT(cus.first_name,' ',cus.last_name)
order by total_sales desc
;

select prd.product_name,
	   sum(stk.quantity) as stock_quantity 
from production.products as prd
join production.stocks as stk
on stk.product_id=prd.product_id
group by prd.product_name
ORDER BY stock_quantity DESC;
;


-- Description: Find products that are in stock but have not been sold at all
SELECT 
    p.product_name,
    SUM(s.quantity) AS stock_quantity
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
LEFT JOIN sales.order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL
GROUP BY p.product_name
ORDER BY stock_quantity DESC
;

-- Description: Analyze how much discount is being given and how often
SELECT AVG(discount) as avg_discount ,
	   MAX(discount) as max_discount ,
	  count(ord.order_id) as orders_with_discount
FROM Sales.order_items as ite
left join Sales.orders as ord
on ord.order_id=ite.order_id
where ord.order_id is not null
;

--Another Way
SELECT 
    AVG(discount) AS avg_discount,
    MAX(discount) AS max_discount,
    COUNT(*) AS orders_with_discount
FROM Sales.order_items
WHERE discount > 0
;


-- Description: Find which brands have the highest sales revenue
select br.brand_name,
	   cast(sum(ite.quantity * ite.list_price * (1-ite.discount)) as decimal (20,2)) AS total_sales
from production.brands as br
join production.products as p
on p.brand_id=br.brand_id
join Sales.order_items as ite 
on ite.product_id=p.product_id
group by br.brand_name
order by total_sales desc
;


-- Description:  Total orders and sales handled by each staff member
select CONCAT(stf.first_name, ' ' ,last_name) as 'Full Name',
	   cast(sum(ite.quantity * ite.list_price * (1-ite.discount)) as decimal (20,2)) AS total_sales,
	   count(distinct ord.order_id)  AS total_orders
from Sales.staffs as stf
join Sales.orders as ord
on ord.staff_id=stf.staff_id
join Sales.order_items as ite
on ord.order_id = ite.order_id
group by CONCAT(stf.first_name, ' ' ,last_name) 
ORDER BY total_sales DESC;
;


-- Description:  orders and revenue per month
select FORMAT( ord.order_date,'yyyy-MM')  AS order_month,
		cast(sum(ite.quantity * ite.list_price * (1-ite.discount)) as decimal (20,2)) AS total_sales,
		count(distinct ord.order_id)  AS total_orders
from Sales.orders as ord
join Sales.order_items as ite
on ord.order_id=ite.order_id
group by FORMAT( ord.order_date,'yyyy-MM') 
ORDER BY order_month;
;

-- Description: Classifying delivery status based on comparison between shipped_date and required_date

 SELECT 
    DATEDIFF(day, order_date, required_date) AS RequiredDays,
    DATEDIFF(day, order_date, shipped_date) AS ShippedDays,
    CASE 
        WHEN DATEDIFF(day, order_date, shipped_date) = DATEDIFF(day, order_date, required_date)
            THEN 'Delivered on time'
        WHEN DATEDIFF(day, order_date, shipped_date) > DATEDIFF(day, order_date, required_date)
            THEN 'Delivered late'
        WHEN DATEDIFF(day, order_date, shipped_date) < DATEDIFF(day, order_date, required_date)
            THEN 'Delivered early'
    END AS Delivery_Status
FROM Sales.orders;