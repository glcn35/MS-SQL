--List the product names in ascending order where the part from the beginning to the first space character is "Samsung" in the product_name column.
SELECT  product_name from  product.product
where product_name like 'Samsung %' 
order by product_name asc

select PATINDEX('Samsung %' ,product_name) 
from product.product
order by PATINDEX('Samsung %' ,product_name) asc 

select charINDEX('Samsung ' ,product_name) 
from product.product

SELECT  product_name from product.product
where product_name in (select charINDEX('Samsung ' ,product_name) 
from product.product)

SELECT  product_name  ,substring(product_name,len('Samsung ')+1,len(product_name)) as pro_name
from  product.product 
where product_name like 'Samsung %' 
order by pro_name

---Write a query that returns streets in ascending order.
--The streets have an integer character lower than 5 after the "#" character end of the street.
--(use sale.customer table)
select street from sale.customer

SELECT street ,substring(street,1,charindex('#', street)+1 )
FROM sale.customer

select charindex('#', street) from sale.customer

SELECT street ,substring(street,charindex('#', street)+1 , len(street)) 
FROM sale.customer
where street in (substring(street,charindex('#', street)+1 , len(street)) )


SELECT CAST(substring(street,charindex('#', street)+1 , len(street)) AS int)
FROM sale.customer
where street not in (substring(street,charindex('#', street)+1 , len(street)))
ORDER BY CAST(substring(street,charindex('#', street)+1 , len(street)) AS int) ASC

SELECT street ,substring(street,charindex('#', street)+1 , len(street)) 
FROM sale.customer

SELECT street ,substring(street,charindex('#', street)+1 , len(street)) as street_no
FROM sale.customer
where street not in (substring(street,charindex('#', street)+1 , len(street)))

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
having avg (list_price*(1-discount)*quantity)>2000
order by order_id asc

--Write a query that returns the count of orders of each day between '2020-01-19' and '2020-01-25'. Report the result using Pivot Table.
--Note: The column names should be day names (Sun, Mon, etc.).
--(Use SampleRetail DB on SQL Server and paste the result in the answer box.
--'2020-01-19' ve '2020-01-25' arasýndaki her günün sipariþ sayýsýný döndüren bir sorgu yazýn. Özet Tabloyu kullanarak sonucu bildirin.
--Not : Sütun adlarý gün adlarý olmalýdýr (Paz, Pzt, vb.).


SELECT order_date
FROM sale.orders
where order_date between '2020-01-19'and  '2020-01-25' 

SELECT order_date,DATENAME( WEEKDAY, order_date)
FROM sale.orders
where order_date between '2020-01-19'and  '2020-01-25' 

SELECT order_date,DATENAME( WEEKDAY, order_date),COUNT( order_date)
FROM sale.orders
where order_date between '2020-01-19'and  '2020-01-25'
group by order_date,DATENAME( WEEKDAY, order_date)


SELECT [order_date], [Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday]
FROM 
(
SELECT order_date,order_id
  FROM sale.orders
  )
PIVOT 
(  
  COUNT(order_date)
  FOR DATENAME( WEEKDAY, order_date) IN
     ([Sunday],[Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday])
	 ) AS pivot_table;