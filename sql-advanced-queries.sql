#List each pair of actors that have worked together.
select a1.actor_id, a1.film_id, a2.actor_id
from sakila.film_actor a1
join sakila.film_actor a2
on a1.actor_id <> a2.actor_id
and a1.film_id = a2.film_id
order by a1.film_id;


#For each film, list actor that has acted in more films.

with cte_number_of_films as
(
	select actor_id, count(film_id) as films_acted
	from sakila.film_actor
    group by actor_id
), 
cte_ranking as 
(
	select actor_id, film_id, films_acted, 
	row_number() over (partition by film_id order by films_acted desc) as Ranking
	from film_actor
	join cte_number_of_films using (actor_id)
)
select title, concat(a.first_name, ' ', a.last_name) as Full_Name, films_acted
from cte_ranking
join actor as a using (actor_id)
join film as f using (film_id)
where Ranking = 1;
