USE myPro
SELECT * FROM orders_dimen

-- we set PK for shipping_dimension(because I didn't add it before)
ALTER TABLE shipping_dimen ADD CONSTRAINT pk_shipping_dimen PRIMARY KEY (ship_id)

-- we must change the ship_date from nvarchar to date
SELECT * FROM shipping_dimen

 SET DATEFORMAT dmy;
 UPDATE dbo.shipping_dimen
 SET ship_date = CONVERT(varchar, CAST(ship_date AS date), 3);

ALTER TABLE dbo.shipping_dimen
ALTER COLUMN ship_date DATE

SELECT * 
FROM market_fact

-- ADD FK s to tables
ALTER TABLE market_fact ADD CONSTRAINT FK_1 FOREIGN KEY (ord_id)
REFERENCES orders_dimen (ord_id)

ALTER TABLE market_fact ADD CONSTRAINT FK_2 FOREIGN KEY (Cust_id)
REFERENCES cust_dimen (Cust_id)

ALTER TABLE market_fact ADD CONSTRAINT FK_5 FOREIGN KEY (Ship_id)
REFERENCES shipping_dimen (Ship_id)

ALTER TABLE market_fact ADD CONSTRAINT FK_4 FOREIGN KEY (prod_id)
REFERENCES prod_dimen (prod_id)

ALTER TABLE dbo.shipping_dimen
ADD PRIMARY KEY (Ship_id)
-- DROP TABLE shipping_dimen

-- alter table market_fact drop constraint FK_3


alter table company drop column CountryID