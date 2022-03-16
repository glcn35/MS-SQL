--List the products ordered the last 10 orders in Buffalo city.
-- Buffalo þehrinde son 10 sipariþte sipariþ verilen ürünleri listeleyin.
SELECT A.product_id,B.product_name
FROM product.product B,sale.order_item A
WHERE A.product_id=B.product_id
		AND A.order_id in(
							SELECT TOP 10 B.order_id
							FROM sale.customer A,sale.orders B
							WHERE A.customer_id=B.customer_id AND A.city='Buffalo'
							order by order_date DESC)


--Müþterilerin sipariþ sayýlarýný, sipariþ ettikleri ürün sayýlarýný ve ürünlere ödedikleri toplam net miktarý raporlayýnýz.
SELECT  A.customer_id,SUM(B.quantity),
SUM(B.quantity*B.list_price*(1-B.discount)) AS total_price
FROM sale.orders A,sale.order_item B
GROUP BY  A.customer_id

SELECT DISTINCT A.customer_id,A.first_name,a.last_name,	
SUM(c.quantity*(c.list_price*(1-c.discount))) OVER (partition by a.customer_id) As total_price,
COUNT(c.product_id) OVER (partition by a.customer_id) As total_product,
COUNT( b.order_id) OVER (partition by a.customer_id) As total_order
FROM sale.customer A, sale.orders B, sale.order_item C
WHERE A.customer_id = B.customer_id
	AND B.order_id = C.order_id

SELECT distinct A.first_name, A.last_name,
				COUNT(C.order_id) OVER(PARTITION BY  A.customer_id, C.order_id) "sipariþ",
				COUNT(C.product_id) OVER(PARTITION BY  A.customer_id) "ürün_sayýsý",
				SUM(C.list_price*(1-C.discount)*C.quantity) OVER(PARTITION BY  A.customer_id) "toplam_ödenen"
FROM sale.customer A, sale.orders B, sale.order_item C
WHERE A.customer_id=B.customer_id AND
	  B.order_id=C.order_id

SELECT	A.customer_id, A.first_name, A.last_name, c.*, b.product_id, B.quantity, b.list_price, b.discount, quantity*list_price*(1-discount)
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
AND A.customer_id = 1

SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  A.customer_id, A.first_name, A.last_name

--Hiç sipariþ vermemiþ müþteriler de rapora dahil olsun.
SELECT	A.customer_id, A.first_name, A.last_name,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(C.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A
		LEFT JOIN sale.orders B ON A.customer_id = B.customer_id
		LEFT JOIN sale.order_item C ON B.order_id = C.order_id
GROUP BY  A.customer_id, A.first_name, A.last_name
ORDER BY 1 DESC
SELECT 
    C.customer_id,
    C.first_name,
    C.last_name, 
    COUNT(DISTINCT O.order_id) orders,
    SUM(I.quantity) total_products,
    SUM(I.quantity*list_price*(1-discount)) net_amount
FROM sale.customer C
LEFT JOIN sale.orders O
ON O.customer_id = C.customer_id
LEFT JOIN sale.order_item I
ON O.order_id = I.order_id
GROUP BY C.customer_id, C.first_name, C.last_name
ORDER BY 1;


--Þehirlerde verilen sipariþ sayýlarýný, sipariþ edilen ürün sayýlarýný ve ürünlere ödenen toplam net miktarlarý raporlayýnýz.

SELECT city
FROM sale.customer
group by

SELECT	 A.state,A.city,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  A.state, A.city

--Eyaletlerde verilen sipariþ sayýlarýný, sipariþ edilen ürün sayýlarýný ve ürünlere ödenen toplam net miktarlarý raporlayýnýz.
SELECT	a.state,
		COUNT (DISTINCT C.order_id) AS cnt_order,
		SUM(B.quantity) cnt_product,
		SUM(quantity*list_price*(1-discount)) net_amount
FROM	sale.customer A, sale.order_item B, sale.orders C
WHERE	A.customer_id = C.customer_id
AND		B.order_id = C.order_id
GROUP BY  a.state
order by 1

----State ortalamasýnýn altýnda ortalama ciroya sahip þehirleri listeleyin.
--Neye göre gruplamak istiyorsak (  Window'larý hangi alan(larý) gruplayarak oluþturmak istiyorsak) PARTITION BY keyword'ünden sonra o alan(larý) yazýyoruz. Yani PARTITION BY'dan sonra gruplamak istediðimiz alan adlarýný yazýyoruz.
-- OVER keyword'ünden önceki fonksiyon  ise her bir window a ayrý ayrý uygulanacaktýr.
SELECT A.state,a.city,	
		AVG(quantity*list_price*(1-discount)) net_amount
		FROM	sale.customer A, sale.order_item B, sale.orders C
		WHERE	A.customer_id = C.customer_id
		AND		B.order_id = C.order_id
		GROUP BY  a.state,a.city
		order by 1


SELECT A.state,	
		AVG(quantity*list_price*(1-discount)) net_amount
		FROM	sale.customer A, sale.order_item B, sale.orders C
		WHERE	A.customer_id = C.customer_id
		AND		B.order_id = C.order_id
		GROUP BY  a.state
		order by 1

select *
from
	  (
	   select distinct a.state,a.city,
		   avg((list_price - list_price*discount)*quantity) over (partition by city) city_avg,
		   avg((list_price - list_price*discount)*quantity) over (partition by [state]) state_avg
	   from sale.customer a, sale.orders b, sale.order_item c
	   where a.customer_id = b.customer_id and b.order_id = c.order_id
	  ) A
where a.city_avg < a.state_avg

WITH t1 AS( 
SELECT DISTINCT  a.state, a.city,
AVG(quantity*list_price*(1-discount)) OVER (PARTITION BY a.state  ) as average_state, 
AVG(quantity*list_price*(1-discount)) OVER (PARTITION BY a.city ) as average_city 
FROM  sale.customer A, sale.order_item B, sale.orders C
WHERE   A.customer_id = C.customer_id
AND     B.order_id = C.order_id
) 
SELECT *
FROM t1
WHERE average_city <average_state

SELECT  DATENAME(weekday, order_date),SUM(quantity*list_price*(1-discount)) 
FROM sale.store A,sale.order_item B, sale.orders C
WHERE  A.store_id = C.store_id
AND     B.order_id = C.order_id and store_name='The BFLO Store'
GROUP BY DATENAME(weekday, order_date)

SELECT *
FROM (
		SELECT DATENAME(weekday, order_date) [days] ,SUM(quantity*list_price*(1-discount)) net_amount
		FROM sale.store A,sale.order_item B, sale.orders C
		WHERE  A.store_id = C.store_id
		AND     B.order_id = C.order_id and store_name='The BFLO Store'
		GROUP BY DATENAME(weekday, order_date)
) BFL
PIVOT
(SUM(net_amount)
for  [days] in 
([Friday],[Monday],[Saturday],[Sunday],[Thursday],[Tuesday],[Wednesday]) 
)as pivottable



SELECT *
FROM
(
SELECT	DATENAME(WEEKDAY, order_date) dayofweek_, quantity*list_price*(1-discount) net_amount, datepart(ISOWW, order_date) WEEKOFYEAR
FROM	sale.store A, sale.orders B, sale.order_item C
WHERE	A.store_name = 'The BFLO Store'
AND		A.store_id = B.store_id
AND		B.order_id = C.order_id
AND		YEAR(B.order_date) = 2018
) A
PIVOT
(
SUM (net_amount)
FOR dayofweek_
IN ([Monday],[Tuesday],[Wednesday],[Thursday],[Friday],[Saturday],[Sunday] )
) AS PIVOT_TABLE




SELECT DATEPART(dw,B.order_date) [days], DATENAME(dw,B.order_date) days_of_week, SUM(quantity*list_price*(1-discount)) turnover
FROM sale.store A, sale.orders B, sale.order_item C
WHERE A.store_id = B.store_id AND
B.order_id = C.order_id AND
A.store_name = 'The BFLO Store'
GROUP BY DATENAME(dw,B.order_date), DATEPART(dw,B.order_date)
ORDER BY DATEPART(dw,B.order_date)


WITH bflo
AS (
SELECT S.store_name, DATENAME(WEEKDAY,O.order_date) week_day, I.list_price, I.quantity, I.discount
FROM sale.store S, sale.orders O, sale.order_item I 
WHERE O.store_id = S.store_id
AND O.order_id = I.order_id
AND S.store_name = 'The BFLO Store')

SELECT week_day, SUM(list_price*quantity*(1-discount)) net_amount
FROM bflo
GROUP BY week_day
ORDER BY 2 DESC;


WITH  tb as
(
select A.staff_id ,B.order_date,
		ROW_NUMBER() over(partition by A.staff_id order by order_date)  row_num,
		LEAD(order_date) OVER (PARTITION BY A.staff_id ORDER BY B.order_id) next_ord_date
		from sale.staff A,sale.orders B
		WHERE A.staff_id=B.staff_id )
select *
from tb
where row_num = 4 OR row_num=3





WITH T1 AS
(
SELECT staff_id, order_date, order_id,
		LEAD(order_date) OVER (PARTITION BY staff_id ORDER BY order_id) next_ord_date,
		ROW_NUMBER () OVER (PARTITION BY staff_id ORDER BY order_id) row_num
FROM sale.orders
)
SELECT *, DATEDIFF(DAY, order_date, next_ord_date) DIFF_OFDATE
FROM T1
WHERE row_num = 3 




--Calculate 7-day moving average of the number of products sold between '2018-03-12' and '2018-04-12'.
--'2018-03-12' ve '2018-04-12' arasýnda satýlan ürün sayýsýnýn 7 günlük hareketli ortalamasýný hesaplayýn.