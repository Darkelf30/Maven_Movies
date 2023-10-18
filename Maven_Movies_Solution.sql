/* Each Store and its manager full name, address, district, city and Country */
SELECT sto.store_id AS store_id,
       CONCAT(first_name, ' ', last_name) AS manager_full_name,
	   adr.address AS store_address,
	   adr.district AS district,
	   ct.city AS city,
	   cou.country AS country
FROM country AS cou
JOIN city AS ct
ON cou.country_id = ct.country_id
JOIN address AS adr
ON ct.city_id = adr.city_id
JOIN store AS sto
ON adr.address_id = sto.address_id
JOIN staff as stf
ON sto.manager_staff_id = stf.staff_id
ORDER BY sto.store_id;

/* Inventory along with store_id, inventory_id, film_name, film_rating, rental_rate and replacement_cost */
SELECT inv.store_id AS store_id,
       inv.inventory_id AS inventory_id,
	   ft.title AS film_name,
	   f.rating AS film_rating,
	   f.rental_rate AS rental_rate,
	   f.replacement_cost AS replacement_cost
FROM film AS f
JOIN film_text AS ft
ON f.film_id = ft.film_id
JOIN inventory as inv
ON ft.film_id = inv.film_id;

/* At each store, what is the inventory count as well as the average rating */
WITH sub_store AS 
     (SELECT inv.store_id AS store_id,
             inv.inventory_id AS inventory_id,
			 ft.title AS film_name,
		     f.rating AS film_rating,
	         f.rental_rate AS rental_rate,
	         f.replacement_cost AS replacement_cost
      FROM film AS f
      JOIN film_text AS ft
      ON f.film_id = ft.film_id
      JOIN inventory as inv
      ON ft.film_id = inv.film_id)

SELECT store_id,
       film_rating,
       COUNT(inventory_id) AS inventory_count
FROM sub_store
GROUP BY store_id, film_rating
ORDER BY store_id, film_rating


/* Number of films, average replacement cost and total replacement cost by store and film category */
SELECT inv.store_id AS store,
       c.name AS category,
	   COUNT(*) As film_count,
	   ROUND(AVG(fm.replacement_cost), 2) AS avg_replacement_cost,
	   SUM(fm.replacement_cost) AS total_replacement_cost
FROM category AS c
JOIN film_category AS fc
ON c.category_id = fc.category_id
JOIN inventory AS inv
ON fc.film_id = inv.film_id
JOIN film as fm
ON inv.film_id = fm.film_id
GROUP BY inv.store_id, c.name
ORDER BY store, category

/* Customer names, the stores they go to, whether active or not, full addresses
(street address, city, country) */
SELECT c.customer_id AS cutomer_id,
       CONCAT(first_name, ' ', last_name) AS customer_name,
	   c.store_id AS store_id,
	   CASE WHEN active = 1 THEN 'Yes'
	        ELSE 'No' END AS is_active,
	   adr.address AS street_address,
	   ct.city AS city,
	   cou.country AS country

FROM customer AS c
JOIN address AS adr
ON c.address_id = adr.address_id
JOIN city AS ct
ON adr.city_id = ct.city_id
JOIN country AS cou
ON ct.country_id = cou.country_id
ORDER BY store_id, customer_id

/* Each customer, total lifetime rentals and sum of all payments ordered by 
total lifetime rentals in descending order */
SELECT c.customer_id,
       CONCAT(first_name, ' ', last_name) AS full_name,
	   COUNT(*) AS lifetime_rentals,
	   SUM(p.amount) AS total_payments
FROM customer AS c
JOIN payment AS p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id, CONCAT(first_name, ' ', last_name)
ORDER BY lifetime_rentals DESC, total_payments DESC;

/* names of investors and advisors, designation(either as investor/advisor) and 
company name that investor works with */
SELECT CONCAT(first_name, ' ', last_name), 'advisor' AS designation, 'No company available' AS company_name
FROM advisor
UNION ALL 
SELECT CONCAT(first_name, ' ', last_name), 'investor', company_name
FROM investor;

/* Group actors by number of awards - 3, 2, 1 and note what percentage we carry a film for */
SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END


