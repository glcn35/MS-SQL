
/*
Discount Effects

Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.

In this assignment, you are expected to generate a solution using SQL with a logical approach. 

Ýndirim oranýndaki artýþýn ürünler için sipariþ sayýsýný olumlu etkileyip etkilemediðine dair ürün kimliklerini ve indirim etkilerini içeren bir rapor oluþturun.

Bu ödevde mantýksal bir yaklaþýmla SQL kullanarak bir çözüm üretmeniz beklenmektedir.
Sample Result:
Product_id	Discount Effect
1			Positive
2			Negative
3			Negative
4			Neutral
*/

select product_id, discount, quantity 
from sale.order_item
order by product_id


select product_id, discount, sum(quantity) as sale_quantity
from sale.order_item
group by product_id, discount
order by product_id

CREATE  VIEW tbl
AS   (
SELECT	product_id, discount,
		lead(discount) over (partition by product_id order by discount )as next_discount,
		sum(quantity) as sale_quantity,
		lead(sum(quantity)) over (partition by product_id order by discount ) as next_sale_quantity	
FROM sale.order_item
GROUP BY product_id, discount
)

WITH  tbl_1 AS (
SELECT product_id,
		sum(( next_sale_quantity-sale_quantity)/(next_discount-discount)) as eðim		
FROM tbl
GROUP BY product_id)

SELECT product_id,
	CASE 
		WHEN eðim>0 THEN 'Positive'
		WHEN eðim=0 THEN 'Neutral'
		WHEN eðim<0 THEN 'Negative'
end as Discount_Effect
FROM tbl_1