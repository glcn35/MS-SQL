
--List the product names in ascending order where the part from the beginning to the first space character is
--"Samsung" in the product_name column.

-----�r�n adlar�n�, ba�lang��tan ilk bo�luk karakterine kadar olan k�sm�n bulundu�u artan s�rada listeleyin.
-- �r�n_ad� s�tununda "Samsung".


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

---Sokaklar� artan s�rada d�nd�ren bir sorgu yaz�n.
--Sokaklarda, soka��n sonundaki "#" karakterinden sonra 5'ten k���k bir tamsay� karakteri var.
--(sat��.m��teri tablosunu kullan�n)

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
--"Seagate" markal� �r�nlerin sipari�lerini d�nd�ren bir sorgu yaz�n.  
--Sipari� edilen veya verilmeyen t�m �r�nlerin �r�n adlar�  ve  sipari� numaralar� listelenmelidir  . ( artan s�rada order_id )


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
--"Sony - 5.1-Ch. 3D / Smart Blu-ray Ev Sinema Sistemi - Siyah" isimli �r�n�n sipari� tarihini d�nd�ren bir sorgu yaz�n�z.




select C.order_date
from  product.product A
	JOIN  sale.order_item B
			ON A.product_id=B.product_id
	JOIN sale.orders C
			ON B.order_id=C.order_id
WHERE product_name='Sony - 5.1-Ch. 3D / Smart Blu-ray Home Theater System - Black'



--Please write a query to return only the order ids that have an average amount of more than $2000. 
--Your result set should include order_id. Sort the order_id in ascending order.

--L�tfen yaln�zca ortalama tutar� 2000 ABD Dolar�ndan fazla olan sipari� kimliklerini d�nd�rmek i�in bir sorgu yaz�n. 
---Sonu� k�meniz order_id i�ermelidir. order_id'yi artan d�zende s�ralay�n.



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
--'2020-01-19' ve '2020-01-25' aras�ndaki her g�n�n sipari� say�s�n� d�nd�ren bir sorgu yaz�n. �zet Tabloyu kullanarak sonucu bildirin.
--Not : S�tun adlar� g�n adlar� olmal�d�r (Paz, Pzt, vb.).


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

--Stokunda "Samsung Galaxy Tab S3 Klavye K�l�f�" isimli �r�n� olmayan ma�azay� tespit edin.
--(Ma�aza ad�n� a�a��daki kutuya yap��t�r�n.)


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
--Hem "Samsung Galaxy Tab S3 Klavye K�l�f�" hem de "Apple - �kinci El iPad 3 - 64GB - Siyah" 
--stoklar�n�n bulundu�u ma�azalar� artan s�rada listeleyin.

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
--Hafta sonu ve hafta i�i sipari� say�lar�n� listeleyin. 
--Cevab�n�z� iki s�tunlu tek bir sat�rda g�nderin. �rne�in: 164 161. �lk de�er hafta sonu i�indir.

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

--Personeli ald�klar� sipari� say�s�na g�re a�a��daki gibi s�n�fland�r�n:
--a) Sipari� say�s� 400'den fazla ise 'Y�ksek Performansl� �al��an'
--b) Sipari� say�s� 100 ile 400 aras�nda ise 'Normal Performansl� �al��an'
--c) Sipari� say�s� 1 ile 100 aras�nda ise 'D���k Performansl� �al��an'
--d) Emir say�s� 0 ise 'Sipari� Yok'
--Ard�ndan, personelin ad�n�, soyad�n�, �al��an s�n�f�n� ve sipari� say�s�n� listeleyin. (Sipari�lerin ve isimlerin artan s�rada say�s�)

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