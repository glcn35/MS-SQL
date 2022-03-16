--window functýons  12.02.2022--
--Group by ile yaptýðýmýzda category'leri  bir araya toplayýp karþýsýna ilgili aggregation iþlemi sonucunu getiriyordu.
--WF ise yine agg. iþlemi sonucunu ilgili category icin getirir fakat sonucu tekilleþtirmez, kategorileri bir araya toplamaz. 
--Bunun için ayrýca distinct kullanmanýz gerekir.

SELECT *
FROM product.stock


SELECT product_id,sum(quantity)
FROM product.stock
GROUP BY product_id
ORDER BY product_id

SELECT DISTINCT product_id,
    SUM(quantity) OVER (PARTITION BY product_id)
FROM product.stock;

SELECT *,sum(quantity) OVER(partition by product_id) total_stock
FROM product.stock

/*--Nedir bu Windows Function ne iþe yarar?:
Window fonksiyonlarý sql sorgusu ile elde edilen sonuç setini her fonksiyonun kendi karakterine göre parçalara ayýrarak yine bu parçalara kendi fonksiyonlarýna göre deðer üretirler.
Bu deðerler SELECT listesinde veya ORDER BY sýralama kriterleri içinde kullanýlabilirler.
Window fonksiyonlarý kullanýlýrken OVER anahtarý ile kayýt setinin parçalara bölünmesi saðlanýr.*/

SELECT DISTINCT brand_id,AVG(list_price) 
						OVER(PARTITION BY brand_id) avg_price
FROM product.product


select	distinct brand_id, avg(list_price) over(partition by brand_id) avg_price
from	product.product
order by 2 desc


SELECT         OVER(PARTITION BY  )
FROM


SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id  ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id



SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id


SELECT  top 1 product_id,MIN(list_price)
from product.product
GROUP BY product_id
order by MIN(list_price)

SELECT top 1 list_price
from product.product
order by list_price

select	distinct min(list_price) over()
from	product.product


select	distinct product_name,list_price,min(list_price) over()
from	product.product


select	*
from	(
		select	product_id, product_name, list_price, min(list_price) over() cheapest
		from	product.product
		) A
where	A.list_price = A.cheapest
;


SELECT  category_id,MIN(list_price)
from product.product
GROUP BY category_id

SELECT  DISTINCT category_id,MIN(list_price) OVER(PARTITION BY category_id) cheapest_by_cat
from product.product


SELECT COUNT(*)
FROM product.product


SELECT COUNT(product_id)
FROM product.product

select distinct count(product_name) as different_products
from product.product

select	distinct count(*) over()
from	product.product

select count(distinct product_id)
from sale.order_item

select count(distinct product_id) over()
from sale.order_item

-- write a query that returns how many products are in each order?
select	distinct order_id, 
			count(item_id) over(partition by order_id) cnt_product
from	sale.order_item

SELECT DISTINCT
    order_id,
    SUM(quantity) OVER (PARTITION BY order_id) cnt_product
FROM sale.order_item


select	distinct brand_id, category_id, count(*) over(partition by brand_id, category_id) num_of_prod
from	product.product
order by brand_id, category_id


???
select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date) min_order_date
from	sale.customer a, sale.orders b
WHERE A.customer_id=B.customer_id


--order by içinde yalnýzca order_date yazdýðýmýzda tarihe göre sýralar.
--order by içinde order_date'in yanýna bir alan daha yazmýþ olsak ayný tarihler arasýnda sýralamayý o alana göre yapar.
--Eðer yalnýzca order_date yazarsak ve kayýtta iki ayný tarih olursa tablo oluþturulurken sýra nasýlsa o sýraya göre sýralar.

select	a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(b.order_date) over(order by b.order_date) LAST_order_date
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id

select	a.customer_id, a.first_name, b.order_date,
		FIRST_VALUE(b.order_date) over(order by b.order_date DESC) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;

select	a.customer_id, a.first_name, b.order_date,
		LAST_VALUE(b.order_date) over(order by b.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) store_id
from	sale.customer a, sale.orders b
where	a.customer_id = b.customer_id
;


select	distinct first_value(product_name) over (order by list_price) cheapest_product
from	product.product

select	distinct first_value(product_name) over (order by list_price,model_year DESC) cheapest_product
from	product.product

select	distinct
		first_value(product_name) over (order by list_price, model_year DESC) cheapest_product_name,
		first_value(list_price) over (order by list_price, model_year DESC) cheapest_product_price
from	product.product
;

--LAG, current row'dan belirtilen argümandaki rakam kadar önceki deðeri getiriyor.kaçgün öncesini,sonrasýný istiyorsak sayý girebiliriz.
--LEAD, current row'dan belirtilen argümandaki rakam kadar sonraki deðeri getiriyor.
--Genellikle LEAD VE LAG fonksiyonlarý SIRALANMIÞ BÝR LÝSTEYE UYGULANIR !  O yüzden ORDER BY KULLANILMALIDIR!!


select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date

select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lag(b.order_date, 3) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date



select	b.order_id, a.staff_id, a.first_name, a.last_name, b.order_date,
		lead(b.order_date,2) over(partition by a.staff_id order by b.order_id) previous_order_date
from	sale.staff a, sale.orders b
where	a.staff_id = b.staff_id
order by a.staff_id, b.order_date