---- C-10 WEEKLY AGENDA-8 RD&SQL STUDENT
g�lcan
---- 1. List all the cities in the Texas and the numbers of customers in each city.----
---- 1. Teksas'taki t�m �ehirleri ve her �ehirdeki m��teri numaralar�n� listeleyin.----
SELECT * FROM sale.customer 
WHERE state='TX'

SELECT city, 
	COUNT(customer_id) as city_cust_num 
FROM sale.customer 
WHERE state='TX'
GROUP BY city

---- 2. List all the cities in the California which has more than 5 customer, 
--by showing the cities which have more customers first.  
--Kaliforniya'da 5'ten fazla m��terisi olan t�m �ehirleri 
--�nce en fazla m��terisi olan �ehirleri g�stererek listeleyiniz.------


SELECT city,
		count(city) AS city_cust_count
FROM sale.customer 
WHERE state='CA'
GROUP BY city 
HAVING count(city)>5
ORDER BY city_cust_count DESC





---- 3. List the top 10 most expensive products--
--3. En pahal� 10 �r�n� listeleyin-

SELECT  TOP 10  * 
FROM product.product 
ORDER BY list_price DESC; 




---- 4. List store_id, product name and list price and the quantity of the products which are 
--located in the store id 2 and the quantity is greater than 25----
----4. Ma�aza kimli�i, �r�n ad� ve liste fiyat� listesi ile
--ma�aza kimli�i 2'de bulunan ve miktar� 25'ten fazla olan �r�nlerin miktar�----


select B.store_id,C.product_name,C.list_price,B.quantity
from sale.store A 
join product.stock B 
	on A.store_id=B.store_id
JOIN product.product C 
	on C.product_id=B.product_id 
WHERE B.quantity>25 and B.store_id=2



---- 5. Find the sales order of the customers who lives in Boulder order by order date----
---5. Boulder'da ya�ayan m��terilerin sat�� sipari�lerini sipari� tarihine g�re bulun----


SELECT A.customer_id, A.first_name, A.last_name, B.order_date
FROM 
	sale.customer A
	JOIN sale.orders B
	ON A.customer_id=B.customer_id

WHERE A.city='Boulder'
ORDER BY B.order_date DESC



---- 6. Get the sales by staffs and years using the AVG() aggregate function.
---- 6. AVG() toplama i�levini kullanarak personele ve y�llara g�re sat��lar� al�n.

SELECT staff_id, 
	YEAR(order_date)AS date_year,
	count(YEAR(order_date)) as date_year_count
FROM sale.orders
group by   staff_id,YEAR(order_date)
ORDER BY staff_id
 


SELECT  B.staff_id,B.first_name,B.last_name,YEAR(A.order_date) as date_year,
		count(YEAR(A.order_date)) as date_year_count
FROM sale.orders A 
JOIN sale.staff B
ON A.staff_id=B.staff_id
GROUP BY  B.staff_id,B.first_name,B.last_name,YEAR(A.order_date)
ORDER BY staff_id


SELECT  B.staff_id,B.first_name,B.last_name,YEAR(A.order_date) as date_year,
		AVG(C.list_price*(1-C.discount)*C.quantity) AS SALES_AVG
FROM sale.orders A 
JOIN sale.staff B
ON A.staff_id=B.staff_id
JOIN SALE.order_item C
ON  A.order_id=C.order_id
GROUP BY  B.staff_id,B.first_name,B.last_name,YEAR(A.order_date)
ORDER BY staff_id

  




---- 7. What is the sales quantity of product according to the brands and sort them highest-lowest----
---- 7. �r�nlerin markalara g�re sat�� miktar� nedir ve bunlar� en y�ksek-en d���k olarak s�ralay�n---- 


SELECT A.brand_id,B.brand_name,SUM(C.quantity) AS total_quantity
FROM product.product A
	JOIN product.brand B
		ON A.brand_id=B.brand_id
	JOIN sale.order_item C
		ON A.product_id=C.product_id
GROUP BY A.brand_id,B.brand_name
ORDER BY  total_quantity DESC



SELECT A.brand_id,B.brand_name,SUM(list_price) AS total_price
FROM product.product A
	JOIN product.brand B
	ON A.brand_id=B.brand_id
GROUP BY A.brand_id,B.brand_name
ORDER BY  total_price DESC



SELECT A.brand_id,B.brand_name,SUM(C.list_price*(1-C.discount)*C.quantity) AS total_price
FROM product.product A
	JOIN product.brand B
		ON A.brand_id=B.brand_id
	JOIN sale.order_item C
		ON A.product_id=C.product_id
GROUP BY A.brand_id,B.brand_name
ORDER BY  total_price DESC



---- 8. What are the categories that each brand has?----
---- 8. Her markan�n sahip oldu�u kategoriler nelerdir?----



SELECT A.brand_id,B.brand_name,C.category_name,C.category_id
FROM product.product A
	JOIN product.brand B
		ON A.brand_id=b.brand_id
	JOIN product.category C
		ON A.category_id=C.category_id
GROUP BY  A.brand_id,B.brand_name,C.category_name,C.category_id



---- 9. Select the avg prices according to brands and categories----
---- 9. Markalara ve kategorilere g�re ortalama fiyatlar� se�in----


SELECT B.brand_id, B.brand_name, C.category_name, AVG(A.list_price) AS price_avg
FROM product.product A
	JOIN product.brand B
		ON A.brand_id=b.brand_id
	JOIN product.category C
		ON A.category_id=C.category_id
GROUP BY B.brand_id, B.brand_name,C.category_name
ORDER BY B.brand_id, price_avg DESC


---- 10. Select the annual amount of product produced according to brands----
---- 10. Markalara g�re y�ll�k �retilen �r�n miktar�n� se�in----

SELECT B.brand_id, B.brand_name, 
	YEAR(D.order_date) AS date_year, 
	SUM(c.quantity) AS total_quantity
FROM product.product A
	JOIN product.brand B
		ON A.brand_id=B.brand_id
	JOIN sale.order_item C
		ON A.product_id=C.product_id
	JOIN sale.orders D
		ON   C.order_id=D.order_id
GROUP BY B.brand_id,B.brand_name, YEAR(D.order_date)
ORDER BY B.brand_name,YEAR(D.order_date)





---- 11. Select the store which has the most sales quantity in 2016.----
---- 11. 2016 y�l�nda en �ok sat�� yapan ma�azay� se�in.----


SELECT A.store_name,
	YEAR(B.order_date) AS date_year,
	SUM(c.quantity) AS sum_quantity
FROM sale.store A
	JOIN sale.orders B
		ON A.store_id=B.store_id
	JOIN sale.order_item C
		ON B.order_id=C.order_id
--where YEAR(B.order_date)=2016
GROUP BY A.store_name, YEAR(B.order_date)





---- 12 Select the store which has the most sales amount in 2018.----
---- 12 2018 y�l�nda en �ok sat�� yapan ma�azay� se�in.----


SELECT TOP 1  A.store_name, 
	YEAR(B.order_date) AS date_year,
	SUM(c.quantity) AS sum_quantity
FROM sale.store A
	JOIN sale.orders B
		ON A.store_id=B.store_id
	JOIN sale.order_item C
		ON B.order_id=C.order_id
WHERE YEAR(B.order_date)= 2018
GROUP BY A.store_name, YEAR(B.order_date)
ORDER BY sum_quantity DESC



---- 13. Select the personnel which has the most sales amount in 2019.----
---- 13. 2019 y�l�nda en �ok sat�� yapan personeli se�in.----

SELECT TOP 1 A.staff_id, A.first_name, A.last_name,
	YEAR(B.order_date),
	COUNT(C.quantity)
FROM sale.staff A
	JOIN sale.orders B
		ON A.staff_id=B.staff_id
	JOIN sale.order_item C
		ON B.order_id=C.order_id
WHERE  YEAR(B.order_date)=2019
GROUP BY A.staff_id,A.first_name,A.last_name,YEAR(B.order_date)
ORDER BY COUNT(C.quantity) DESC