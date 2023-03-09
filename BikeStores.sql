SELECT 
pp.product_name,
pc.category_name

FROM BikeStores.production.categories pc
JOIN BikeStores.production.products pp
on pc.category_id = pp.category_id

WITH revenues_per_product as(
SELECT
pp.product_name,
soi.list_price,
soi.discount,
soi.list_price*(1-soi.discount) as after_discount,
soi.quantity,
soi.quantity*soi.list_price*(1-soi.discount) as total_price
FROM BikeStores.sales.order_items soi
JOIN BikeStores.production.products pp
on soi.product_id = pp.product_id)
SELECT
product_name,
SUM(total_price) as total_revenue,
SUM(quantity) as total_sales_quantity
FROM revenues_per_product
GROUP BY product_name



SELECT 
ss.staff_id,
count(so.order_id) as total_order
FROM BikeStores.sales.orders so
RIGHT JOIN BikeStores.sales.staffs ss
on so.staff_id = ss.staff_id
group by ss.staff_id

SELECT
	so.order_id,
	CONCAT(sc.first_name,' ',sc.last_name) as customer_name,
	sc.city,
	sc.state,
	so.order_date,
	SUM(soi.quantity) as 'total_units',
	SUM(soi.quantity * soi.list_price) as 'revenue',
	pp.product_name,
	pb.brand_name,
	pc.category_name,
	sto.store_name,
	CONCAT(sta.first_name,' ',sta.last_name) as staff_name
FROM BikeStores.sales.orders so
JOIN BikeStores.sales.customers sc
on so.customer_id = sc.customer_id
JOIN BikeStores.sales.order_items soi
on so.order_id = soi.order_id
JOIN BikeStores.production.products pp
on soi.product_id = pp.product_id
JOIN BikeStores.production.categories pc
on pp.category_id = pc.category_id
JOIN BikeStores.sales.stores sto
on so.store_id = sto.store_id
JOIN BikeStores.sales.staffs sta
on so.staff_id = sta.staff_id
JOIN BikeStores.production.brands pb
on pp.brand_id = pb.brand_id
GROUP by so.order_id,
	CONCAT(sc.first_name,' ',sc.last_name),
	sc.city,
	sc.state,
	so.order_date,
	pp.product_name,
	pb.brand_name,
	pc.category_name,
	sto.store_name,
	CONCAT(sta.first_name,' ',sta.last_name)