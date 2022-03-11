----ASSIGNMENT_3 (CONVERSION RATE)
--a.Create above table (Actions) and insert values
--a.Yukarýdaki tabloyu (Eylemler) oluþturun ve deðerleri ekleyin,

CREATE TABLE Actions
(
Visitor_ID BIGINT,
Adv_Type VARCHAR(20),
[Action] VARCHAR(20),
);
INSERT Actions VALUES
 (1,'A', 'Left')
,(2,'A', 'Order')
,(3,'B', 'Left')
,(4,'A', 'Order')
,(5,'A', 'Review')
,(6,'A', 'Left')
,(7,'B', 'Left')
,(8,'B', 'Order')
,(9,'B', 'Review')
,(10,'A', 'Review')



select * from Actions

--b. Retrieve count of total Actions and Orders for each Advertisement Type,
--B. Her Reklam Türü için toplam Ýþlem ve Emir sayýsýný alma,

CREATE VIEW A_TOTAL
AS
SELECT Adv_Type, COUNT(Action) Total, Action
FROM Actions
WHERE Action = 'Order'
GROUP BY Adv_Type, Action 


CREATE VIEW A_ORDER
AS
SELECT Adv_Type, COUNT(Action) Total_Order
FROM Actions
GROUP BY Adv_Type


SELECT A_TOTAL.Adv_Type, Total_Order, Total
FROM A_TOTAL,A_ORDER
WHERE A_TOTAL.Adv_Type = A_ORDER.Adv_Type



--c. Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.
--C. Her bir Reklam Türü için Sipariþ (Dönüþüm) oranlarýný, 1.0 ile çarparak deðiþken olarak yayýnlanan toplam eylem sayýsýna bölerek hesaplayýn.

SELECT A_TOTAL.Adv_Type, ROUND(CAST(Total AS float)/CAST(Total_Order AS float), 2) AS Conversion_Rate
FROM A_TOTAL,A_ORDER
WHERE A_TOTAL.Adv_Type = A_ORDER.Adv_Type



SELECT A_TOTAL.Adv_Type, ROUND(CONVERT(float,Total)/CONVERT(float,Total_Order), 2) AS Conversion_Rat
FROM A_TOTAL, A_ORDER
WHERE A_TOTAL.Adv_Type = A_ORDER.Adv_Type


---2.YOL
WITH Order_Count AS (
		SELECT Adv_Type, COUNT([Action]) Number_Order
		FROM Actions
		WHERE [Action] = 'Order'
		GROUP BY Adv_Type
	)

SELECT *
FROM Order_Count;

WITH Action_Count AS (
		SELECT Adv_Type, COUNT([Action]) Number_Action
		FROM Actions
		GROUP BY Adv_Type
	)

SELECT *
FROM Action_Count;

SELECT *
FROM Order_Count,Action_Count
WHERE Order_Count.Adv_Type = Action_Count.Adv_Type



WITH Order_Count AS (
		SELECT Adv_Type, COUNT([Action]) Number_Order
		FROM Actions
		WHERE [Action] = 'Order'
		GROUP BY Adv_Type
	),
Action_Count AS (
		SELECT Adv_Type, COUNT([Action]) Number_Action
		FROM Actions
		GROUP BY Adv_Type
	)

SELECT *
FROM Order_Count,Action_Count
WHERE Order_Count.Adv_Type = Action_Count.Adv_Type