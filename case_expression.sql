use preclass;

select * from departments

SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
        ELSE 'others'
    END AS category           -- category isimli yeni bir sütun yaratýr
FROM departments;
-- dept name e bak when den sonra yazdýðýmsa karþýsýna then den sonra yazdýðýmý yaz
-- yok öyle deðilse else den sonra yazdýðýmý (else yazýlmamýþsa null koyar)

SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
    END AS category
FROM departments;
-- Else yazýlmamýþsa diðerlerine null koyar.


-- Çalýþanlarýn maaþlarýný Yüksek, Orta, Düþük olmak üzere üç kategoriye ayýracaðýz.
SELECT name, salary,
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END AS category
FROM departments;
-- category sütunu oluþturdu. when ile baþlayan ifadeleri çalýþtýrdý, karþýlýklarýný bu sütuna yazdý.

-- where kullanýlan bir case örneði
SELECT name, salary
FROM departments
WHERE 
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END = 'High'
;

-- agg functions ile case örneði
SELECT name,
       SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) AS Seniority,
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) AS Graduation
FROM departments
GROUP BY name
HAVING SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) > 0
	     AND
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) > 0
;


