/*
--CREATING TABLES FOR IN-CLASS

--CREATE DATABASE departments
--USE departments

CREATE TABLE employees_A
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);



INSERT employees_A VALUES
 (17679,  'Robert'    , 'Gilmore'       ,   110000 ,  'Operations Director', 'Male')
,(26650,  'Elvis'    , 'Ritter'        ,   86000 ,  'Sales Manager', 'Male')
,(30840,  'David'   , 'Barrow'        ,   85000 ,  'Data Scientist', 'Male')
,(49714,  'Hugo'    , 'Forester'    ,   55000 ,  'IT Support Specialist', 'Male')
,(51821,  'Linda'    , 'Foster'     ,   95000 ,  'Data Scientist', 'Female')
,(67323,  'Lisa'    , 'Wiener'      ,   75000 ,  'Business Analyst', 'Female')





CREATE TABLE employees_B
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job_title VARCHAR (30),
gender VARCHAR(10),
);


INSERT employees_B VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')

CREATE TABLE employees_C
(
emp_id BIGINT,
first_name VARCHAR(20),
last_name VARCHAR(20),
salary BIGINT,
job VARCHAR (30),
gender VARCHAR(10),
);


INSERT employees_C VALUES
 (49714,  'Hugo'    , 'Forester'       ,   55000 ,  'IT Support Specialist', 'Male')
,(67323,  'Lisa'    , 'Wiener'        ,   75000 ,  'Business Analyst', 'Female')
,(70950,  'Rodney'   , 'Weaver'        ,   87000 ,  'Project Manager', 'Male')
,(71329,  'Gayle'    , 'Meyer'    ,   77000 ,  'HR Manager', 'Female')
,(76589,  'Jason'    , 'Christian'     ,   99000 ,  'Project Manager', 'Male')
,(97927,  'Billie'    , 'Lanning'      ,   67000 ,  'Web Developer', 'Female')
*/

--SET OPERATORS
--G??R????
/*  
	???	Both SELECT statements must contain the same number of columns.
	???	Her iki SELECT ifadesi de ayn?? say??da s??tun i??ermelidir.
	???	In the SELECT statements, the corresponding columns must have the same data type.
	???	SELECT ifadelerinde, kar????l??k gelen s??tunlar ayn?? veri tipine sahip olmal??d??r.
	???	Performans a????s??ndan, UNION ALL, UNION'a k??yasla daha iyi performans g??sterir, ????nk?? kaynaklar yinelenenleri filtrelemek ve sonu?? k??mesini s??ralamak i??in bo??a harcanmaz.
	???	Set operat??rleri alt sorgular??n bir par??as?? olabilir.
*/
SELECT * FROM employees_A --S??tun say??lar?? e??it ve ayn?? data tipine sahipler
SELECT * FROM employees_B -- B VE C TABLOLARI AYNIDIR
SELECT * FROM employees_C --job_title s??tunun ismini job olarak de??i??tirdim

--1. UNION
/* The UNION set operator returns the combined results of the two SELECT statements. 
Essentially, It removes duplicates from the results i.e. only one row will be listed for each duplicated result.
	UNION set operat??r??, iki SELECT ifadesinin birle??tirilmi?? sonu??lar??n?? d??nd??r??r. 
Esasen, sonu??lardan yinelenenleri kald??r??r, yani yinelenen her sonu?? i??in yaln??zca bir sat??r listelenir.*/ 

--EXAMPLE 1:
SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job
  FROM employees_C
  -- sonu??ta gelen s??tun ismi job_title, ilk yaz??lan tabloya ait s??tun isimlerini ald??.
  -- s??tun ismi farkl?? olsa da birle??tirdi, ????nk?? s??tun say??lar?? ve s??tun veri tipleri ayn??
  -- Hepsini alt alta s??ralad??
  -- A da 6 sat??r  B de 6 sat??r varken tekrar eden (duplicated) sat??rlar?? sildi??i i??in UNION da 10 sat??r sonu?? geldi
  --Y??NELENEN(duplicated) sat??rlar emp_id 49714 and emp_id 67323 sat??rlar?? B??R KEZ geldi

--EXAMPLE 2:
 SELECT emp_id, first_name, last_name, job--sonu??ta gelen s??tun ismi job, ilk yaz??lan TABLOYA g??re birle??tirildi
  FROM employees_C --??????nc?? bir tablo olu??turdum
  UNION
 SELECT emp_id, first_name, last_name, job_title
  FROM employees_A

  --EXAMPLE 3:
SELECT *  --??K?? YILDIZ OLURSA KABUL ED??YOR
  FROM employees_A
UNION
SELECT *
  FROM employees_C

  --EXAMPLE 4:
SELECT *  --TEK YILDIZ KULLANILIRSA HATA VER??YOR. E????T SAYIDA S??TUN YOK D??YE
  FROM employees_A
UNION
SELECT emp_id, first_name, last_name, job
  FROM employees_C
   
--EXAMPLE 5:  
SELECT first_name, last_name --??STED??????M??Z S??TUN ??S??MLER??N?? ??A??IRAB??L??R??Z
  FROM employees_A
UNION
SELECT first_name, last_name --??STED??????M??Z S??TUN ??S??MLER??N?? ??A??IRAB??L??R??Z
  FROM employees_B

--EXAMPLE 6:  
SELECT emp_id, first_name --??STED??????M??Z S??TUN ??S??MLER??N?? ??A??IRAB??L??R??Z AMA DATA T??PLER?? AYNI OLMALI
  FROM employees_A
UNION
SELECT first_name, last_name ----??STED??????M??Z S??TUN ??S??MLER??N?? ??A??IRAB??L??R??Z AMA DATA T??PLER?? AYNI OLMALI
  FROM employees_B

  --EXAMPLE 7:
SELECT emp_id, first_name, last_name  --JOB TITLE S??LD??M --E????T SAYIDA S??TUN OLMALI YOKSA HATA VER??YOR
  FROM employees_B
UNION
SELECT emp_id, first_name, last_name, job_title
  FROM employees_A

-- Difference from JOIN 
SELECT *
  FROM employees_A 
LEFT JOIN employees_C
  ON employees_A.emp_id = employees_C.emp_id

SELECT * 
  FROM employees_A 
INNER JOIN employees_C
  ON employees_A.emp_id = employees_C.emp_id

  --2 UNION ALL
  /*The UNION ALL clause is used to print all the records including duplicate records when combining the two tables.
  UNION ALL yan t??mcesi, iki tabloyu birle??tirirken yinelenen kay??tlar dahil t??m kay??tlar?? yazd??rmak i??in kullan??l??r.*/
  
SELECT 'Employees A' AS [Type], emp_id, first_name, last_name, job_title 
--maviden kurtarmak i??in Type k????eli paranteze ald??m
FROM employees_A
UNION ALL
SELECT 'Employees B' AS Type2, emp_id, first_name, last_name, job_title 
FROM employees_B; --farkl?? s??tun ismi versem de data tipleri ayn?? oldu??u i??in
					--ilk tablondaki s??tun ismi ile birle??tirdi 

  --UNION DA 10 SATIR VARKEN BURADA 12 SATIR VAR. 
  --Y??NELENEN(duplicated) sat??rlar emp_id 49714 and emp_id 67323 HER TABLO ??????N AYRI AYRI geldi

  -- 3.INTERSECT
  /*INTERSECT lists only records that are common to both the SELECT queries; 
INTERSECT, yaln??zca her iki SELECT sorgusu i??in ortak olan kay??tlar?? listeler;
 !!! YAN?? HER ??K?? TABLODAK?? ORTAK SATIRLARI GET??R??R*/

SELECT emp_id, first_name, last_name, job_title
  FROM employees_A
INTERSECT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B
 ORDER BY emp_id;

 -- HER ??K?? TABLODAK?? ORTAK emp_id 49714 and emp_id 67323 GELD?? SADECE

 /*--4 EXCEPT
EXCEPT operator compares the result sets of the two queries and 
returns the rows of the previous query that differ from the next query.
EXCEPT operat??r??, iki sorgunun sonu?? k??melerini kar????la??t??r??r ve 
??nceki sorgunun sonraki sorgudan farkl?? olan sat??rlar??n?? d??nd??r??r.*/

-- EXAMPLE 1
SELECT emp_id, first_name, last_name, job_title --A TABLOSUNUN, B TABLOSUNDAN FARKLI OLAN SATIRLARI GELD??
  FROM employees_A
EXCEPT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B;

-- EXAMPLE 2 -- B'N??N A'DAN FARKLI OLAN SATIRLARI GELD??
SELECT emp_id, first_name, last_name, job_title
  FROM employees_B
EXCEPT
SELECT emp_id, first_name, last_name, job_title
  FROM employees_A;

--??K??DEN FAZLA TABLO B??RLE??T??RME M??MK??N
--EXAMPLE 1: TEKRAR EDEN SATIRLARI S??LEREK UN??ONLA B??RLE??T??RD??
SELECT *
  FROM employees_A
UNION
SELECT *
  FROM employees_B
UNION
SELECT *
  FROM employees_C

--EXAMPLE 2: ???? S??TUNU B??RLE??T??RD??. UNIONALL TEKRAR EDEN SATIRLARI DA GET??RD?????? ??????N 18 SATIR GELD??
SELECT *
  FROM employees_A
UNION ALL
SELECT *
  FROM employees_B
UNION ALL
SELECT *
FROM employees_C

--EXAMPLE 1: --A B VE C S??TUNLARINDA ORTAK OLAN SATIRLARI GET??RD??
SELECT *
  FROM employees_A  
INTERSECT	
SELECT *
  FROM employees_B
INTERSECT
SELECT *
  FROM employees_C

--EXAMPLE 1: --A'NIN B VE C S??TUNLARINDAN FARKLI OLAN SATIRLARI GELD??
SELECT *
  FROM employees_A  
EXCEPT
SELECT *
  FROM employees_B
EXCEPT
SELECT *
  FROM employees_C

  --EXAMPLE 1:
  --B'N??N A VE C S??TUNLARINDAN FARKLI OLAN SATIRLARINI ??STED??K. 
  --B'N??N A'DAN FARKLI SATIRLARI VAR FAKAT C TABLOSU ??LE AYNI SATIRLARI ????ERD?????? ??????N VER?? GET??RMED??
SELECT *
  FROM employees_B
EXCEPT
SELECT *
  FROM employees_A
EXCEPT
SELECT *
  FROM employees_C;