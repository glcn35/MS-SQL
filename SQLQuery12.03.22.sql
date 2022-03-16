--window funct�ons  12.02.2022--
--Group by ile yapt���m�zda category'leri  bir araya toplay�p kar��s�na ilgili aggregation i�lemi sonucunu getiriyordu.
--WF ise yine agg. i�lemi sonucunu ilgili category icin getirir fakat sonucu tekille�tirmez, kategorileri bir araya toplamaz. 
--Bunun i�in ayr�ca distinct kullanman�z gerekir.

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

/*--Nedir bu Windows Function ne i�e yarar?:
Window fonksiyonlar� sql sorgusu ile elde edilen sonu� setini her fonksiyonun kendi karakterine g�re par�alara ay�rarak yine bu par�alara kendi fonksiyonlar�na g�re de�er �retirler.
Bu de�erler SELECT listesinde veya ORDER BY s�ralama kriterleri i�inde kullan�labilirler.
Window fonksiyonlar� kullan�l�rken OVER anahtar� ile kay�t setinin par�alara b�l�nmesi sa�lan�r.*/

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


--order by i�inde yaln�zca order_date yazd���m�zda tarihe g�re s�ralar.
--order by i�inde order_date'in yan�na bir alan daha yazm�� olsak ayn� tarihler aras�nda s�ralamay� o alana g�re yapar.
--E�er yaln�zca order_date yazarsak ve kay�tta iki ayn� tarih olursa tablo olu�turulurken s�ra nas�lsa o s�raya g�re s�ralar.

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

--LAG, current row'dan belirtilen arg�mandaki rakam kadar �nceki de�eri getiriyor.ka�g�n �ncesini,sonras�n� istiyorsak say� girebiliriz.
--LEAD, current row'dan belirtilen arg�mandaki rakam kadar sonraki de�eri getiriyor.
--Genellikle LEAD VE LAG fonksiyonlar� SIRALANMI� B�R L�STEYE UYGULANIR !  O y�zden ORDER BY KULLANILMALIDIR!!


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