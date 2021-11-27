-- Lab | SQL Advanced queries

-- 1.List each pair of actors that have worked together.
select f1.actor_id, a.first_name, a.last_name, f2.actor_id, a1.first_name, a1.last_name
from film_actor f1
join film_actor f2
on f1.film_id = f2.film_id
and f1.actor_id <> f2.actor_id
join actor a
on a.actor_id = f1.actor_id
join actor a1
on a1.actor_id = f2.actor_id

-- 2.For each film, list actor that has acted in most films
select actor_id, film_id
from film_actor 
order by film_id

create or replace view counts_actor_films as
select actor_id, count(film_id) as counts
from film_actor
group by actor_id
order by count(film_id)

select * from counts_actor_films 

create or replace view film_id_counts as
select f.film_id, f.actor_id, max(c.counts) as counts
from film_actor f
join counts_actor_films c
on f.actor_id = c.actor_id
group by f.film_id, f.actor_id
order by max(counts);

create or replace view counting as
select a.first_name, a.last_name, counts, film_id, max(counts) OVER (PARTITION BY film_id) max_for_film
from film_id_counts f
join actor a
on a.actor_id = f.actor_id;

-- final result
select * from counting
where counts = max_for_film;

