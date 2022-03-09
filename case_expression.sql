use preclass;

select * from departments

SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
        ELSE 'others'
    END AS category           -- category isimli yeni bir s�tun yarat�r
FROM departments;
-- dept name e bak when den sonra yazd���msa kar��s�na then den sonra yazd���m� yaz
-- yok �yle de�ilse else den sonra yazd���m� (else yaz�lmam��sa null koyar)

SELECT dept_name,
    CASE dept_name
        WHEN 'Computer Science' THEN 'IT'
    END AS category
FROM departments;
-- Else yaz�lmam��sa di�erlerine null koyar.


-- �al��anlar�n maa�lar�n� Y�ksek, Orta, D���k olmak �zere �� kategoriye ay�raca��z.
SELECT name, salary,
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END AS category
FROM departments;
-- category s�tunu olu�turdu. when ile ba�layan ifadeleri �al��t�rd�, kar��l�klar�n� bu s�tuna yazd�.

-- where kullan�lan bir case �rne�i
SELECT name, salary
FROM departments
WHERE 
    CASE
        WHEN salary <= 55000 THEN 'Low'
        WHEN salary > 55000 AND salary < 80000 THEN 'Middle'
        WHEN salary >= 80000 THEN 'High'
    END = 'High'
;

-- agg functions ile case �rne�i
SELECT name,
       SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) AS Seniority,
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) AS Graduation
FROM departments
GROUP BY name
HAVING SUM (CASE WHEN seniority = 'Experienced' THEN 1 ELSE 0 END) > 0
	     AND
       SUM (CASE WHEN graduation = 'BSc' THEN 1 ELSE 0 END) > 0
;


