-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;

SELECT title, i.inventory_id, count(*) as Total FROM inventory as i
JOIN film as f
ON f.film_id=i.film_id
WHERE title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.

SELECT title  FROM film
WHERE length > (
  SELECT round(avg(length),2)
  FROM film
);
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT last_name, first_name
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = "Alone Trip"));

-- 4.Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT film_id, title 
FROM film
WHERE film_id in
(SELECT film_id FROM film_category
WHERE category_id in
	(SELECT category_id FROM category
	 WHERE name='Family'));
-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct 
-- tables with their primary keys and foreign keys, that will help you get the relevant
-- information.

SELECT c.first_name, c.last_name, c.email
FROM customer AS c
JOIN address AS a 
on c.address_id = a.address_id
JOIN city AS ci 
ON a.city_id = ci.city_id
JOIN country AS co 
ON co.country_id = ci.country_id
WHERE co.country = 'Canada';

SELECT last_name, first_name, email
FROM customer
WHERE address_id IN
(SELECT address_id FROM address
	WHERE city_id IN
	(SELECT city_id FROM city
		WHERE country_id IN
		(SELECT country_id FROM country
			WHERE country='Canada')));
 -- 6. Which are films starred by the most prolific actor? 
 -- Most prolific actor is defined as the actor that has acted in the most number of films. 
 -- First you will have to find the most prolific actor 
 -- and then use that actor_id to find the different films that he/she starred.  
 
SELECT a.actor_id, a.first_name, a.last_name, count(a.actor_id) AS total
from actor AS a
JOIN film_actor AS fa
ON fa.actor_id=a.actor_id
GROUP BY a.actor_id
ORDER BY total desc
limit 1; 

SELECT f.film_id, f.title FROM film as f
JOIN film_actor AS fa
ON f.film_id=fa.film_id
WHERE actor_id=107;

-- 7. Films rented by most profitable customer. You can use the customer table and payment table
-- to find the most profitable customer ie the customer that has made the
--  largest sum of payments
SELECT c.first_name, c.last_name, c.customer_id, sum(p.amount) as Total
FROM customer AS c
JOIN payment AS p
ON p.customer_id=c.customer_id
GROUP BY c.customer_id 
ORDER BY Total desc
limit 1;
-- 8. Customers who spent more than the average payments.

SELECT c.customer_id, c.first_name, c.last_name,
    (CASE WHEN p.amount > (SELECT AVG(p2.amount) FROM Payment AS p2
                                WHERE p2.customer_id = c.customer_id)
               THEN 1 END) AS Number
FROM Customer AS c
INNER JOIN Payment AS p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY Number DESC;