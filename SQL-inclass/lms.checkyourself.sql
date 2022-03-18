
--List the product names in ascending order where the part from the beginning to the first space character is
--"Samsung" in the product_name column.

-----Ürün adlarýný, baþlangýçtan ilk boþluk karakterine kadar olan kýsmýn bulunduðu artan sýrada listeleyin.
-- ürün_adý sütununda "Samsung".


SELECT  product_name from  product.product
where product_name like 'Samsung %' 
order by product_name asc

select PATINDEX('Samsung %' ,product_name) 
from product.product
order by PATINDEX('Samsung %' ,product_name) asc 

select charINDEX('Samsung ' ,product_name) 
from product.product



SELECT  product_name  ,substring(product_name,len('Samsung ')+1,len(product_name)) as pro_name
from  product.product 
where product_name like 'Samsung %' 
order by pro_name

---Write a query that returns streets in ascending order.
--The streets have an integer character lower than 5 after the "#" character end of the street.
--(use sale.customer table)

---Sokaklarý artan sýrada döndüren bir sorgu yazýn.
--Sokaklarda, sokaðýn sonundaki "#" karakterinden sonra 5'ten küçük bir tamsayý karakteri var.
--(satýþ.müþteri tablosunu kullanýn)

select street from sale.customer


SELECT street , substring(street,charindex('#', street)+1 , len(street)) as street_no
FROM sale.customer
where street not in (substring(street,charindex('#', street)+1 , len(street)))
--ORDER BY street_no



SELECT street ,substring(street,1,charindex('#', street))
FROM sale.customer

select charindex('#', street) from sale.customer

SELECT street ,substring(street,charindex('#', street)+1 , len(street)) 
FROM sale.customer
where street in (substring(street,charindex('#', street)+1 , len(street)) )




SELECT street ,substring(street,charindex('#', street)+1 , len(street)) 
FROM sale.customer




SELECT RIGHT(street,LEN(street)-charindex('#',street))as street_no
FROM sale.customer
ORDER BY street_no

SELECT RIGHT(street,LEN(street)-charindex('#',street))as street_no
FROM sale.customer
where street not in  (RIGHT(street,LEN(street)-charindex('#',street)))
ORDER BY street_no

---Write a query that returns orders of the products branded "Seagate". 
--It should be listed Product names and order IDs of all the products ordered or not ordered. 
--(order_id in ascending order)
--"Seagate" markalý ürünlerin sipariþlerini döndüren bir sorgu yazýn.  
--Sipariþ edilen veya verilmeyen tüm ürünlerin Ürün adlarý  ve  sipariþ numaralarý listelenmelidir  . ( artan sýrada order_id )


select * from product.brand
where brand_name='Seagate'

select *
from product.brand A
	JOIN product.product B
			ON A.brand_id=B.brand_id
	JOIN SALE.order_item C
			ON B.product_id=C.product_id
where A.brand_name='Seagate'
ORDER BY C.order_id ASC



select B.product_name,C.order_id
from product.brand A
	LEFT JOIN product.product B
			ON A.brand_id=B.brand_id
  LEFT JOIN SALE.order_item C
			ON B.product_id=C.product_id
where A.brand_name='Seagate'
ORDER BY C.order_id ASC



--Write a query that returns the order date of the product named "Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black"--
--"Sony - 5.1-Ch. 3D / Smart Blu-ray Ev Sinema Sistemi - Siyah" isimli ürünün sipariþ tarihini döndüren bir sorgu yazýnýz.




select C.order_date
from  product.product A
	JOIN  sale.order_item B
			ON A.product_id=B.product_id
	JOIN sale.orders C
			ON B.order_id=C.order_id
WHERE product_name='Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black'



--Please write a query to return only the order ids that have an average amount of more than $2000. 
--Your result set should include order_id. Sort the order_id in ascending order.

--Lütfen yalnýzca ortalama tutarý 2000 ABD Dolarýndan fazla olan sipariþ kimliklerini döndürmek için bir sorgu yazýn. 
---Sonuç kümeniz order_id içermelidir. order_id'yi artan düzende sýralayýn.



SELECT order_id, sum(list_price*(1-discount)*quantity)
FROM sale.order_item
group by order_id
having sum(list_price*(1-discount)*quantity)>2000
order by order_id asc


SELECT order_id, avg(list_price*(1-discount)*quantity)
FROM sale.order_item
group by order_id
having avg(list_price*(1-discount)*quantity)>2000
order by order_id asc

--Write a query that returns the count of orders of each day between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.
--Note: The column names should be day names (Sun, Mon, etc.).
--(Use SampleRetail DB on SQL Server and paste the result in the answer box.
--'2020-01-19' ve '2020-01-25' arasýndaki her günün sipariþ sayýsýný döndüren bir sorgu yazýn. Özet Tabloyu kullanarak sonucu bildirin.
--Not : Sütun adlarý gün adlarý olmalýdýr (Paz, Pzt, vb.).


SELECT *
FROM sale.orders
where order_date between '2020-01-19'and  '2020-01-25' 



SELECT order_date,DATENAME( WEEKDAY, order_date)
FROM sale.orders
where order_date between '2020-01-19'and  '2020-01-25' 



SELECT order_date,DATENAME( WEEKDAY, order_date),COUNT( order_date)
FROM sale.orders
where order_date between '2020-01-19'and  '2020-01-25'
group by order_date, DATENAME( WEEKDAY, order_date)


	
SELECT  [Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday]
FROM (
	SELECT
		DATENAME(WEEKDAY, order_date) day_sales, 
		COUNT( order_date) day_count
FROM sale.orders
   where order_date between '2020-01-19'and  '2020-01-25'
   GROUP BY order_date
  )aaaaaaaaaaaa
PIVOT 
(  
 SUM(day_count) FOR (day_sales)  IN
     ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
	 ) AS pivot_table;



SELECT  *
FROM (
		SELECT 
			DATENAME( WEEKDAY, order_date) day_sales, 
			count(*) AS DAY_COUNT
		FROM sale.orders
		where order_date between '2020-01-19'and  '2020-01-25'
	    GROUP BY  order_date
 ) AS day_SALES
PIVOT 
(  
	SUM(day_COUNT) 
	FOR day_sales IN
     ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
			) AS pivot_table;
			

---Detect the store that does not have a product named "Samsung Galaxy Tab S3 Keyboard Cover" in its stock.
--(Paste the store name in the box below.)
--(Use SampleRetail Database and paste your result in the box below.)

--Stokunda "Samsung Galaxy Tab S3 Klavye Kýlýfý" isimli ürünü olmayan maðazayý tespit edin.
--(Maðaza adýný aþaðýdaki kutuya yapýþtýrýn.)


select store_name
from sale.store
WHERE store_id NOT IN
				(
				SELECT DISTINCT  store_id
				FROM product.stock
				where product_id =
							(SELECT product_id
							FROM product.product	
							where product_name='Samsung Galaxy Tab S3 Keyboard Cover')
				)

---List in ascending order the stores where both 
--"Samsung Galaxy Tab S3 Keyboard Cover" and "Apple - Pre-Owned iPad 3 - 64GB - Black" are stocked.
--(Use SampleRetail Database and paste your result in the box below.)
--Hem "Samsung Galaxy Tab S3 Klavye Kýlýfý" hem de "Apple - Ýkinci El iPad 3 - 64GB - Siyah" 
--stoklarýnýn bulunduðu maðazalarý artan sýrada listeleyin.

select store_name
from sale.store
WHERE store_id IN(
				SELECT store_id
				FROM product.stock
				where product_id=
							(SELECT product_id
							FROM product.product	
							where product_name ='Apple - Pre-Owned iPad 3 - 64GB - Black')
				INTERSECT

				SELECT store_id
				FROM product.stock
				where product_id=
							(SELECT product_id
							FROM product.product	
							where product_name ='Samsung Galaxy Tab S3 Keyboard Cover')
				)
ORDER BY store_name ASC

--List counts of orders on the weekend and weekdays. Submit your answer in a single row with two columns. 
--For example: 164 161. First value is for weekend.
--(Use SampleRetail Database and paste your result in the box below.)
--Hafta sonu ve hafta içi sipariþ sayýlarýný listeleyin. 
--Cevabýnýzý iki sütunlu tek bir satýrda gönderin. Örneðin: 164 161. Ýlk deðer hafta sonu içindir.

SELECT order_date
FROM SALE.orders

SELECT order_date, DATENAME(weekday, order_date)
FROM SALE.orders

create  View A
AS 
SELECT order_date, 
DATENAME(weekday, order_date) AS day_name,
				CASE WHEN DATENAME(weekday, order_date)='Saturday' THEN 'WEEKEND'
					 WHEN DATENAME(weekday, order_date)='Sunday' THEN 'WEEKEND'
					 ELSE  'WEEKDAY'
				END AS day_name2
FROM SALE.orders

SELECT * FROM A


SELECT *
FROM (SELECT --order_date, 
		 --DATENAME(weekday, order_date) AS day_name,
						CASE WHEN DATENAME(weekday, order_date)='Sunday' THEN 'WEEKEND'
							 WHEN DATENAME(weekday, order_date)='Saturday' THEN 'WEEKEND'
							 ELSE  'WEEKDAYS'
						END AS day_name
						
		FROM SALE.orders)
as day_name2
PIVOT 
(  COUNT(day_name) 
   fOR  day_name IN
			([WEEKEND],[WEEKDAYS])
) AS pivot_table;


--Classify staff according to the count of orders they receive as follows:
--a) 'High-Performance Employee' if the number of orders is greater than 400
--b) 'Normal-Performance Employee' if the number of orders is between 100 and 400
--c) 'Low-Performance Employee' if the number of orders is between 1 and 100
--d) 'No Order' if the number of orders is 0
--Then, list the staff's first name, last name, employee class, and count of orders.  (Count of orders and first names in ascending order)

--Personeli aldýklarý sipariþ sayýsýna göre aþaðýdaki gibi sýnýflandýrýn:
--a) Sipariþ sayýsý 400'den fazla ise 'Yüksek Performanslý Çalýþan'
--b) Sipariþ sayýsý 100 ile 400 arasýnda ise 'Normal Performanslý Çalýþan'
--c) Sipariþ sayýsý 1 ile 100 arasýnda ise 'Düþük Performanslý Çalýþan'
--d) Emir sayýsý 0 ise 'Sipariþ Yok'
--Ardýndan, personelin adýný, soyadýný, çalýþan sýnýfýný ve sipariþ sayýsýný listeleyin. (Sipariþlerin ve isimlerin artan sýrada sayýsý)

SELECT staff_id,count(order_id) STAFF_COUNT
FROM sale.orders
group by staff_id


SELECT DISTINCT staff_id
FROM sale.orders

select A.first_name, A.last_name, count(B.order_id) as Count_of_ordersfrom sale.staff Aleft join sale.orders Bon A.staff_id = B.staff_idgroup by A.first_name, A.last_name
select A.first_name, A.last_name,    CASE        WHEN count(B.order_id) > 400 THEN 'High-Performance Employee'		WHEN count(B.order_id) > 100 and count(B.order_id) < = 400 THEN 'Normal-Performance Employee'		WHEN count(B.order_id) > = 1 and count(B.order_id) < = 100 THEN 'Low-Performance Employee'		WHEN count(B.order_id) = 0 THEN 'No Order'    END AS employee_class, count(B.order_id) as Count_of_ordersfrom sale.staff Aleft join sale.orders Bon A.staff_id = B.staff_idgroup by A.first_name, A.last_nameorder by Count_of_orders, A.first_name
use SampleRetailselect A.first_name, A.last_name, count(B.order_id) as Count_of_ordersfrom sale.staff Aleft join sale.orders Bon A.staff_id = B.staff_idgroup by A.first_name, A.last_nameselect A.first_name, A.last_name, count(B.order_id) as Count_of_orders,    CASE        WHEN count(B.order_id) > 400 THEN 'High-Performance Employee'		WHEN count(B.order_id) > 100 and count(B.order_id) < = 400 THEN 'Normal-Performance Employee'		WHEN count(B.order_id) > = 1 and count(B.order_id) < = 100 THEN 'Low-Performance Employee'		WHEN count(B.order_id) = 0 THEN 'No Order'    END AS employee_classfrom sale.staff Aleft join sale.orders Bon A.staff_id = B.staff_idgroup by A.first_name, A.last_nameorder by Count_of_orders, A.first_name




SELECT staff_id,count(staff_id) STAFF_COUNT,
					CASE    WHEN count(staff_id)> 400 THEN 'High-Performance Employee'
							WHEN count(staff_id) BETWEEN 100 AND 400  THEN  'Normal-Performance Employee'
							WHEN count(staff_id) BETWEEN 1 AND 100  THEN  'Low-Performance Employee'
							ELSE   'No Order'
					END AS STAFF_PERF
FROM sale.orders
group by staff_id



SELECT  b.first_name,b.last_name,
					CASE    WHEN count(a.staff_id)> 400 THEN 'High-Performance Employee'
							WHEN count(a.staff_id) BETWEEN 100 AND 400  THEN  'Normal-Performance Employee'
							WHEN count(a.staff_id) BETWEEN 1 AND 100  THEN  'Low-Performance Employee'
							ELSE   'No Order'
					END AS STAFF_PERF,count(a.staff_id) 
FROM sale.orders A, SALE.staff B
WHERE A.staff_id=B.staff_id
group by b.first_name,b.last_name
order by count(a.staff_id) ,b.first_name 