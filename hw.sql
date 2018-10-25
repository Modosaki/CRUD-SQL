use sakila;

select FIRST_NAME, LAST_NAME
FROM ACTOR;

SELECT CONCAT (FIRST_NAME ,' ',LAST_NAME) AS 'ACTOR NAME'
FROM ACTOR;


SELECT ACTOR_ID, FIRST_NAME , LAST_NAME
FROM ACTOR
WHERE FIRST_NAME= 'Joe';

SELECT ACTOR_ID, FIRST_NAME , LAST_NAME
FROM ACTOR
WHERE last_NAME like '%GEN%';


SELECT COUNTRY_ID, COUNTRY
FROM COUNTRY
WHERE COUNTRY IN ('afghanistan', 'bangladesh', 'china');

ALTER TABLE actor
ADD `description` blob;

ALTER TABLE actor
DROP COLUMN `description`;


SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;


SELECT last_name , COUNT(last_name)
FROM actor
GROUP BY last_name
having count(last_name) >=2;

--  4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.
UPDATE actor
SET First_name = 'GROUCHO'
WHERE First_name= 'HARPO' and last_name='WILLIAMS';

UPDATE actor
SET First_name = 'HARPO'
WHERE First_name= 'GROUCHO' and last_name='WILLIAMS';


-- 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?

SHOW CREATE TABLE address;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:
Select * From address where address_id IN (3, 4);



select staff.first_name, staff.last_name, address.address
from staff
join address on
staff.address_id = address.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

select staff.first_name, staff.last_name, sum(payment.amount) 
from staff
join payment on
staff.staff_id = payment.staff_id
where payment.payment_date like '2005-08%'
group by staff.last_name;

-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

select film.title, count(film_actor.actor_id)
from film
inner join film_actor on
film.film_id=film_actor.film_id
group by film.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

select film.title, count(inventory.inventory_id)
from film
join inventory on
film.film_id=inventory.film_id
where film.title ="Hunchback Impossible"
group by film.title;

-- 6e. Using the tables `payment` and `customer` and 
-- the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:
 
 select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid' 
 from customer
 join payment on
 customer.customer_id=payment.customer_id
 group by customer.customer_id
 order by Last_name;
 
 -- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
 -- films starting with the letters `K` and `Q` have also soared in popularity.
 -- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.
select film.title
from film
where (title like 'Q%' or  title like 'K%') and language_id in
(select language_id
from language
where name='english');

--  7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select actor.first_name, actor.last_name
from actor
where actor_id in
(select actor_id
from film_actor
where film_id in
(select film_id
from film
where film.title ='Alone Trip'
)
);

-- 7c. You want to run an email marketing campaign in Canada,
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.


select customer.first_name, customer.last_name, customer.email
from customer
join address on
customer.address_id=address.address_id 
where address.address_id in
(select address_id
from address
where city_id in
(select city_id 
from city
where country_id in
(select country_id
from country
where country = "canada"
)));

-- * 7d. Sales have been lagging among young families,
-- and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title
from film
where film_id in
(select film_id 
from film_category
where category_id in
(select category_id
from category
where name = 'family'
));

--  7e. Display the most frequently rented movies in descending order.

select* from film;
select* from inventory;
select* from rental;

select film.title, count(rental_id) 
from film
join inventory on
film.film_id = inventory.film_id
join rental on
inventory.inventory_id = rental.inventory_id
group by film.title 
order by count(rental_id) DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

select staff.store_id, sum(payment.amount)
from staff
join payment on
payment.staff_id = staff.staff_id
group by staff.store_id;

--  7g. Write a query to display for each store its store ID, city, and country.

select store.store_id, city.city, country.country
from store
join address on 
store.address_id = address.address_id
join city on
address.city_id = city.city_id
join country on
city.country_id = country.country_id
group by store.store_id;

-- * 7h. List the top five genres in gross revenue in descending order.
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

 select category.name, sum(payment.amount)
 from category
 join film_category on
 category.category_id =film_category.category_id
 join inventory on
 film_category.film_id = inventory.film_id
 join rental on
 inventory.inventory_id= rental.inventory_id
 join payment on 
 rental.rental_id= payment.rental_id
 group by category.name
 order by sum(payment.amount) DESC
 limit 5;
 
 -- 8a. In your new role as an executive, 
 -- you would like to have an easy way of viewing the Top five genres by gross revenue. 
 -- Use the solution from the problem above to create a view. If you haven't solved 7h,
 -- you can substitute another query to create a view.
 
 
CREATE VIEW top5 AS
select category.name, sum(payment.amount)
 from category
 join film_category on
 category.category_id =film_category.category_id
 join inventory on
 film_category.film_id = inventory.film_id
 join rental on
 inventory.inventory_id= rental.inventory_id
 join payment on 
 rental.rental_id= payment.rental_id
 group by category.name
 order by sum(payment.amount) DESC
 limit 5;
 
 select* from top5;
 
 drop view top5;
 