select database();
use sakila;
describe sakila.actor;
-- 1a.
select first_name,last_name from sakila.actor;
-- 1b.
select UPPER(CONCAT(first_name," ",last_name)) as "Actor Name" from sakila.actor;
-- 2a.
select actor_id,first_name,last_name from sakila.actor where first_name = "Joe";
-- 2b.
select actor_id,first_name,last_name from sakila.actor where last_name like "%GEN%";
-- 2c.
select last_name,first_name from sakila.actor where last_name like "%LI%";
-- 2d.
select country_id,country from sakila.country where country IN("Afghanistan", "Bangladesh","China");
-- 3a.
Alter table sakila.actor add column description blob;
-- 3b.
alter table sakila.actor drop column description;
-- 4a.
select last_name,count(last_name) as "Num of Actors" from sakila.actor group by last_name;
-- 4b.
select last_name,count(last_name) as "Actors Count" from sakila.actor group by last_name having count(last_name) >= 2 ;
-- 4c.
select first_name,last_name from sakila.actor where first_name = "GROUCHO"and last_name = "WILLIAMS"; 
update sakila.actor set first_name = "HARPO",last_name = "WILLIAMS" where first_name = "GROUCHO" and last_name = "WILLIAMS";
select first_name,last_name from sakila.actor where first_name = "HARPO"and last_name = "WILLIAMS";
-- 4d.
update sakila.actor set first_name = "GROUCHO" where first_name = "HARPO"and last_name = "WILLIAMS";
select first_name,last_name from sakila.actor where first_name = "GROUCHO"and last_name = "WILLIAMS";
-- 5a.
show create table sakila.address;
/*
CREATE TABLE `address` (\n  
`address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
\n  `address` varchar(50) NOT NULL,
\n  `address2` varchar(50) DEFAULT NULL,
\n  `district` varchar(20) NOT NULL,
\n  `city_id` smallint(5) unsigned NOT NULL,
\n  `postal_code` varchar(10) DEFAULT NULL,
\n  `phone` varchar(20) NOT NULL,
\n  `location` geometry NOT NULL,
\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
\n  PRIMARY KEY (`address_id`),
\n  KEY `idx_fk_city_id` (`city_id`),
\n  SPATIAL KEY `idx_location` (`location`),
\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'
*/
-- 6a.
select s.first_name,s.lassurfer11t_name,a.address from sakila.staff s  join sakila.address a  ON(s.address_id= a.address_id);
select count(*) from sakila.staff;

-- 6b.

select s.first_name,s.last_name,sum(p.amount) "Total Amount" from sakila.staff s join sakila.payment p 
on(s.staff_id=p.staff_id)  where payment_date like '2005-08-%' group by s.first_name,s.last_name;
select staff_id,(amount),payment_date from sakila.payment where payment_date 
like  '2005-08-%'  group by staff_id,payment_date ;

-- 6c.
select f.title,count(a.actor_id) from sakila.film f inner join sakila.film_actor a
on(f.film_id = a.film_id) group by f.title;
select * from sakila.film;
select * from sakila.film_actor;

-- 6d.
select * from sakila.inventory;
SELECT title, (SELECT COUNT(*) FROM sakila.inventory WHERE film.film_id = inventory.film_id ) AS 'Number of Copies'
FROM sakila.film where	title = 'Hunchback Impossible'; 
-- 6e.
select c.last_name,c.first_name,sum(p.amount) "Total Amount" from sakila.customer c  join sakila.payment p 
on(c.customer_id =p.customer_id)  group by c.first_name,c.last_name  order by c.last_name;
select * from sakila.customer;
use sakila;

-- 7a. 
select * from sakila.film limit 5;
select * from sakila.language where name ='English';
select title from sakila.film where (select language_id from sakila.language where name ='English')
and title like'K_%'  or title like 'Q%' ;

-- 7b.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
(
  SELECT actor_id
  FROM film_actor
  
WHERE film_id IN
  (
   SELECT film_id
   FROM film
   WHERE title = 'Alone Trip'
  )
);
-- 7c.
select * from sakila.customer_list where country = 'Canada' ;

select first_name,last_name,email from sakila.customer where address_id IN 
(select address_id from sakila.address where address_id IN 
(select city_id from sakila.city where country_id 
IN (select country_id from sakila.country where country = 'Canada')));

SELECT cntry.country_id,first_name, last_name, email,city,cntry.country 
FROM customer cu
JOIN address a ON (cu.address_id = a.address_id)
JOIN city cit ON (a.city_id=cit.city_id)
JOIN country cntry ON (cit.country_id=cntry.country_id)
where cntry.country='Canada';


-- 7 d.

select * from sakila.category;
select title from sakila.film where film_id IN (select film_id from sakila.film_category where category_id 
IN (select category_id from sakila.category where name ='Family'));

SELECT title, category
FROM film_list
WHERE category = 'Family';
-- 7 e.
SELECT title as Title, COUNT(f.film_id) AS 'Most_Frequently_Rented_Movies'
FROM  film f
JOIN inventory i ON (f.film_id= i.film_id)
JOIN rental r ON (i.inventory_id=r.inventory_id)
GROUP BY title ORDER BY Most_Frequently_Rented_Movies DESC;
-- 7f.
select * from sakila.sales_by_store;

SELECT s.store_id, SUM(p.amount) as '$Total'
FROM sakila.payment p
JOIN sakila.staff s ON (p.staff_id=s.staff_id)
GROUP BY store_id;
-- 7g.
select * from sakila.sales_by_store;
select store_id from sakila.store;

SELECT store_id, city, country FROM sakila.store s
JOIN sakila.address a ON (s.address_id=a.address_id)
JOIN sakila.city c ON (a.city_id=c.city_id)
JOIN sakila.country cn ON (c.country_id=cn.country_id);

-- 7h.

select category as 'Top Five',total_sales as Gross from sakila.sales_by_film_category 
order by Gross desc limit 5 ;

SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM sakila.category c
JOIN sakila.film_category fc ON (c.category_id=fc.category_id)
JOIN sakila.inventory i ON (fc.film_id=i.film_id)
JOIN sakila.rental r ON (i.inventory_id=r.inventory_id)
JOIN sakila.payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross desc LIMIT 5;

-- 8a.
CREATE  VIEW Top_Five AS
SELECT c.name AS "Top Five", SUM(p.amount) AS "Gross" 
FROM sakila.category c
JOIN sakila.film_category fc ON (c.category_id=fc.category_id)
JOIN sakila.inventory i ON (fc.film_id=i.film_id)
JOIN sakila.rental r ON (i.inventory_id=r.inventory_id)
JOIN sakila.payment p ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross desc LIMIT 5;

-- 8b.
select * from sakila.Top_Five;
-- 8c.
 DROP VIEW top_five_grossing_genres;
