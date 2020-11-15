SELECT * FROM covid19.download;
ALTER TABLE covid19.download 
      ADD id INT NOT NULL AUTO_INCREMENT 
      PRIMARY KEY FIRST;
      
      USE covid19;
	CREATE TABLE countries
       AS(SELECT DISTINCT countriesAndTerritories as name, geoId as code,   
          popData2019 as population_count FROM covid19.download);
          
	ALTER TABLE covid19.countries
       ADD id INT NOT NULL AUTO_INCREMENT 
       PRIMARY KEY FIRST;
       
       
       select * from countries;
       select * from cases;
       desc table countries;
       desc table cases;
       
       
       USE covid19;
      CREATE TABLE cases
      AS(SELECT cases AS confirmed_case, deaths AS death_toll, dateRep AS  
         occurred_at, DENSE_RANK() OVER (ORDER BY    
         countriesAndTerritories)country_id
      FROM covid19.download);
	  ALTER TABLE covid19.cases
      ADD id INT NOT NULL AUTO_INCREMENT
      PRIMARY KEY FIRST;
      
      show tables;
      describe table cases;
      
      use covid19;
      SELECT cases.occurred_at, cases.confirmed_case
	  FROM cases 
	  ORDER BY confirmed_case DESC
      LIMIT 5;
      
      SELECT distinct ca.occurred_at, ca.death_toll 
	  FROM cases as ca
	  WHERE ca.death_toll  > 500
      order by ca.death_toll desc
	  LIMIT 20;
     
      SELECT name
	  FROM countries
	  WHERE name LIKE '%Republic%';
    
    
	  SELECT co.name, max(ca.death_toll), ca.occurred_at
	  FROM cases ca
	  JOIN countries co
	  ON co.id = ca.country_id
	  WHERE co.name in ('Ireland', 'United Kingdom', 'India');
    
    SELECT co.name, ca.confirmed_case, ca.death_toll, ca.occurred_at
	FROM countries co
	JOIN cases ca
	ON ca.country_id = co.id
	WHERE co.name LIKE 'I%' or co.name LIKE 'K%'
	ORDER BY co.name;
    
    
    Select distinct co.name, SUM(ca.death_toll) as total_deaths
    from cases as ca
    join countries as co
    ON ca.country_id = co.id
    where co.name = 'IRELAND';
    
    SELECT SUM(ca.confirmed_case)- SUM(ca.death_toll) as Ongoing_Cases 
	FROM cases ca;	
    
    SELECT co.name, count(ca.confirmed_case), count(ca.death_toll)
	FROM cases ca
    JOIN countries co
	ON co.id = ca.country_id
    where co.name = 'IRELAND';
    
    SELECT SUM(ca.confirmed_case) Confimed_cases, 
	SUM(ca.death_toll) Deaths
	FROM cases ca;
    
    SELECT co.name, ca.confirmed_case, ca.occurred_at
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
    where (ca.death_toll is null and ca.confirmed_case is null)
	ORDER BY co.name DESC;
	
    SELECT co.name, ca.confirmed_case, ca.death_toll, ca.occurred_at
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	WHERE co.name LIKE 'Sp%'
	ORDER BY co.name;
    
    SELECT co.name, ca.confirmed_case, ca.death_toll, ca.occurred_at
	FROM cases ca
    JOIN countries co
	ON co.id = ca.country_id
	WHERE (ca.confirmed_case > 2500 AND ca.death_toll > 250) AND (ca.confirmed_case < 4000 AND ca.death_toll > 400);
 
	SELECT co.name, AVG(ca.death_toll) as avg_death
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	WHERE co.name = 'Ireland' ;
    

    SELECT co.name, AVG(ca.death_toll) as avgdeaths, Avg(ca.confirmed_case) as confirmedcase
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	GROUP BY co.name
	ORDER BY co.name DESC
	LIMIT 50;
    
    SELECT co.name,max(ca.confirmed_case),ca.occurred_at
	FROM cases as ca
	JOIN countries as co
	ON co.id = ca.country_id
	GROUP BY co.name
    having max(ca.confirmed_case)>1000;
    
    SELECT co.name,  max(population_count) as total_PopulationIRELAND, MAX(ca.confirmed_case), MAX(death_toll)
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	WHERE co.name = 'Ireland' ;
    
	SELECT co.name, MAX(ca.confirmed_case) as Max_daycount
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	GROUP BY co.name
	ORDER BY Max_daycount ASC
    Limit 20;
    
    SELECT co.name, MAX(ca.confirmed_case) confirmed_case, MAX(ca.death_toll)
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	GROUP BY co.name
	ORDER BY confirmed_case DESC
    limit 10;
    
    SELECT co.name, SUM(ca.death_toll) death_toll
	FROM cases ca
	JOIN countries co
	ON co.id = ca.country_id
	GROUP BY co.name
	ORDER BY death_toll DESC
    limit 10;
    
    select co.name, AVG(ca.confirmed_case) 
    from countries as co
    join cases as ca
    on ca.country_id = co.id
    Group by co.name
    Having AVG(ca.confirmed_case) > 1500;
    
	select co.name, AVG(ca.death_toll) 
    from countries as co
    join cases as ca
    on ca.country_id = co.id
    Group by ca.death_toll
    Having AVG(ca.death_toll) >500;


	select name, count(occurred_at) as ZeroCountOccured from	
	(select co.name, ca.occurred_at, sum(ca.confirmed_case) as casescount
    from countries as co
    join cases as ca
    on ca.country_id = co.id
    Group by co.name, ca.occurred_at
    Having sum(ca.confirmed_case)=0) as zc  
    group by name 
    order by count(occurred_at) desc
    ;

	select name, concat(DeathToPopulationRatio,'%') from 
	(select co.name, sum(ca.death_toll)/avg(co.population_count) * 100 as DeathToPopulationRatio
    from countries as co
    join cases as ca
    on ca.country_id = co.id
    Group by co.name order by sum(ca.death_toll)/avg(co.population_count) * 100 desc limit 10) as dtp;  
    
   
select co.name, ca.occurred_at, sum(ca.confirmed_case) as casescount
    from countries as co
    join cases as ca
    on ca.country_id = co.id
    Group by co.name, ca.occurred_at
    Having sum(ca.confirmed_case)=0;
    
SELECT DISTINCT co.name, co.population_count 
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE co.population_count > 100000000
ORDER BY population_count  DESC;


SELECT  co.name, max(ca.death_toll)
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE co.population_count > 100000000
group by co.name
order by max(ca.death_toll) desc
;

SELECT  co.name, ca.occurred_at , ca.death_toll
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE  co.name ='Ireland' and ca.death_toll in (select max(death_toll) from cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='Ireland');

SELECT  co.name, ca.occurred_at , ca.confirmed_case
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE  ca.confirmed_case in (select confirmed_case from cases ca
JOIN countries co
ON co.id = ca.country_id where ca.confirmed_case>5000)
;

SELECT  co.name, ca.occurred_at , ca.death_toll
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE  co.name ='Ireland' and ca.death_toll in (select max(death_toll) from cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='Ireland') 
UNION 
SELECT  co.name, ca.occurred_at , ca.death_toll
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE  co.name ='India' and ca.death_toll in (select max(death_toll) from cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='India')
UNION 
SELECT  co.name, ca.occurred_at , ca.death_toll
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE  co.name ='France' and ca.death_toll in (select max(death_toll) from cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='France');



SELECT  co.name, ca.occurred_at , ca.death_toll
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
WHERE  co.name ='Ireland' and (ca.death_toll in (select max(death_toll) from cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='Ireland') or ca.death_toll in (select min(death_toll) from cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='Ireland'));

#query for view 3 diff 

create view IrelandCases as 
select co.name, ca.death_toll, co.population_count, ca.confirmed_case FROM cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='Ireland'; 

create view IndiaCases as 
select co.name, ca.death_toll, co.population_count, ca.confirmed_case FROM cases ca
JOIN countries co
ON co.id = ca.country_id where co.name='India'; 

select name, concat(sum(death_toll)/sum(confirmed_case) * 100,'%') as DeathToConfirmedCases from 
(select * from IrelandCases 
UNION 
select * from IndiaCases) as IrelandIndiaView
group by name
;




insert into  countries 
values ('250', 'West_Indies', 'WI','2222222');

select * from countries where name='West_Indies'; 

update countries set population_count='11111', code='WE' where id=250 ;

select * from countries where name='West_Indies'; 

delete from countries where id='250';

select * from countries where name='West_Indies'; 

#Self join

select distinct c1.id as TableId1, c1.confirmed_case as CountryConfirmedCases1, 
c1.death_toll as CountryDeath1, c1.occurred_at as CountryDate1, c1.country_id as CountryId1,
c2.id as TableId2, c2.confirmed_case as CountryConfirmedCases2, 
c2.death_toll as CountryDeath2, c2.occurred_at as CountryDate2, c2.country_id as CountryId2
 from cases c1  join cases c2 on c1.country_id<>c2.country_id and 
c1.occurred_at=c2.occurred_at where 
c1.death_toll>=1000 and c2.death_toll>=1000 
order by c1.occurred_at  
;


SELECT DISTINCT co.name, co.population_count population_count, COUNT(confirmed_case)
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
GROUP BY co.id
HAVING COUNT(confirmed_case) > 100
ORDER BY COUNT(confirmed_case) DESC
LIMIT 5;

SELECT co.name, ca.confirmed_case confirmed_case, ca.death_toll, 
       occurred_at,
       CASE WHEN ca.confirmed_case > 2000 AND ca.death_toll > 175
       THEN 'High Risk' ELSE 'Low Risk' END AS Risk_level
FROM cases ca
JOIN countries co 
ON co.id = ca.country_id
ORDER BY confirmed_case DESC;
    
SELECT co.name, SUM(ca.death_toll) as deathcount,
CASE WHEN SUM(ca.death_toll) > 5000 THEN 'Fatal'
     WHEN  SUM(ca.death_toll) > 500 THEN 'Needs Attention'
     ELSE 'In control' END AS ACTION
FROM cases ca
JOIN countries co
ON co.id = ca.country_id
GROUP BY co.name
ORDER BY SUM(ca.death_toll) DESC;

SELECT name, mortality_rate
    FROM (SELECT co.name, SUM(ca.confirmed_case) as casesconfirmed,
               CASE WHEN SUM(ca.confirmed_case) > 100000 THEN 'worse affected'
               WHEN  SUM(ca.confirmed_case) > 10000 THEN 'mid level affected'
               ELSE 'controllable' END AS mortality_rate
               FROM cases ca
               JOIN countries co
               ON co.id = ca.country_id
               GROUP BY 1
               ORDER BY 2 DESC) temp_table
    WHERE mortality_rate = 'worse affected'
	IN  ('low risk', 'intermediate risk')
	ORDER BY 2 DESC;

WITH t1 AS (
  SELECT co.name , SUM(ca.death_toll) as totaldeaths,
       CASE WHEN SUM(ca.death_toll) > 2000 THEN 'Maximum '
       WHEN  SUM(ca.death_toll) > 200 THEN 'Intermediate'
       ELSE 'Minimum' END AS Deathrate
       FROM cases ca
       JOIN countries co
       ON co.id = ca.country_id
       GROUP BY 1), 
t2 AS (
       SELECT name, Deathrate, SUM(totaldeaths) 
       FROM t1
       GROUP BY 1)
SELECT t1.name, t1.totaldeaths, t1.Deathrate
FROM t1
JOIN t2
ON t1.Name = t2.name AND t1.Deathrate = t2.Deathrate
WHERE t1.Deathrate IN  ('Minimum', 'Intermediate')
ORDER BY 2 DESC;


    
    