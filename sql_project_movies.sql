----------Movies_Analysis_project



CREATE TABLE movies (
    Title varchar(255),
    Rating decimal(3,1),
    BoxOfficeCollection bigint,
    Budget bigint,
    Director varchar(100),
    Producer varchar(100)
);



CREATE TABLE top_real_movies (
    id INT,
    movie_name varchar(255),
    year_of_release varchar(10),
    watch_time varchar(20),
    movie_rating decimal(3,1),
    meatscore_of_movie decimal(5,2),
    votes varchar(50),
    gross varchar(20),
    description text
);


select * from movies;

select * from top_real_movies;


1.which Movies directed by Peter Jackson?

 select title,director
 from movies 
 where director = 'Peter Jackson';



2.What are the Top 5 Movies with the highest imdb ratings.

 select movie_name,movie_rating
 from top_real_movies
 order by movie_rating desc
 limit 5;



3.Which movie has the highest boxoffice_collection?

 select title,boxofficecollection
 from movies
 order by boxofficecollection desc
 limit 1;



4.Which movie have the longest description?

  select movie_name,description
  from top_real_movies 
  order by length(description) desc 
  limit 1;                                 

  

5.How many movies have meatscore greater then 80?

 select count(meatscore_of_movie) as high_meatscore_movie
 from top_real_movies 
 where meatscore_of_movie > 80;



6.show movies that exists in both datasets with their ratings.

 select m.title,m.rating,t.movie_name,t.movie_rating
 from movies m
 inner join top_real_movies t
 on m.title = t.movie_name;



7.show all top_real_movies and thier matching records in movies.

  select t.movie_name,
  m.title as matched_title
  from top_real_movies t
  left join movies m
  on t.movie_name = m.title;



8.show all top_real_movies and thier unmatched matching records in movies.

  select t.movie_name,
  m.title as unmatched_records
  from top_real_movies t
  left join movies m
  on t.movie_name = m.title
  where m.title is null;



9.select all the records of both tables.

  select m.*,t.*
  from movies m
  full outer join top_real_movies t
  on m.title = t.movie_name;



10.Count the movies in each year.

  select count(m.title) as numbers_of_movies,
  t.year_of_release 
  from movies m
  inner join top_real_movies t 
  on m.title = t.movie_name
  group by t.year_of_release
  order by t.year_of_release;
  


11.show the releasing years of top ratings 5 movies.

  select m.rating,t.year_of_release
  from movies m
  inner join top_real_movies t
  on m.title = t.movie_name
  order by m.rating desc
  limit 5;



12.find same movie titles across both tables.

 select m.title,t.movie_name
 from movies m 
 inner join top_real_movies t
 on m.title = t.movie_name
 group by m.title,t.movie_name;
 


13.show all movies that release after 2010 and directed by David fincher.

 select m.title,m.director,t.year_of_release
 from movies m
 inner join top_real_movies t
 on m.title = t.movie_name
 where t.year_of_release  > '-2010' 
 and m.director = 'David Fincher';



14.Do movies with higher boxoffice collection recieve more votes of audience too or not?

  select m.title,t.movie_name,m.boxofficecollection,t.votes
  from movies m
  inner join top_real_movies t
  on m.title = t.movie_name
  order by m.boxofficecollection desc;



15.which top 10 movies earned more than they cost to make?

   select m.title,t.movie_name,m.budget,t.gross
   from movies m
   inner join top_real_movies t 
   on m.title = t.movie_name
   order by m.budget asc, t.gross desc
   limit 10;



16.find longest watchtime movie;

   select m.title,
   cast(REPLACE(t.watch_time,'min','') as integer ) as longest_watchtime
   from movies m
   inner join top_real_movies t
   on m.title = t.movie_name
   order by cast(REPLACE(t.watch_time,'min','') as integer ) desc
   limit 1;
   
      

17.Find all producers and thier movies with watch time more than 2 hours.

  select m.title,m.producer,t.watch_time
  from movies m
  inner join top_real_movies t
  on m.title = t.movie_name 
  where cast(REPLACE(t.watch_time,'min','') as integer ) > 120;
  

 
18.Find the total number of movies and the total gross earnings for each director?

   select m.director,
   count(m.title) as number_of_movies,
   sum(
       case
	   when t.gross like '%M%' then 
   cast(REGEXP_REPLACE(t.gross,'[^\d.]','','g') as numeric ) * 1000000
else 
   cast(REGEXP_REPLACE(t.gross,'[^\d.]','','g') as numeric )
   end
   )as total_earning
   from movies m
   inner join top_real_movies t 
   on m.title = t.movie_name
   group by m.director;



19.Which are the flops movies and how much loss did each of them receive?

  with movies_records as (
  select
  m.title,
  t.gross,
  m.budget,
  case
  when t.gross LIKE '%M%' then 
        cast(REGEXP_REPLACE(t.gross, '[^\d.]', '', 'g') as numeric) * 1000000
      else 
        cast(REGEXP_REPLACE(t.gross, '[^\d.]', '', 'g') as numeric)
    end as gross_numeric_total_earning
  from movies m
  inner join top_real_movies t 
    on m.title = t.movie_name
 )
 select 
  title,
  gross,
  budget,
  gross_numeric_total_earning,
  budget - gross_numeric_total_earning as total_loss
from movies_records
where gross_numeric_total_earning < budget;



20.Which are the hit movies and how much profit did each of them receive?

  
  with movies_records as (
  select
  m.title,
  t.gross,
  m.budget,
  case
  when t.gross LIKE '%M%' then 
        cast(REGEXP_REPLACE(t.gross, '[^\d.]', '', 'g') as numeric) * 1000000
      else 
        cast(REGEXP_REPLACE(t.gross, '[^\d.]', '', 'g') as numeric)
    end as gross_numeric_total_earning
  from movies m
  inner join top_real_movies t 
    on m.title = t.movie_name
 )
 select 
  title,
  gross,
  budget,
  gross_numeric_total_earning,
  gross_numeric_total_earning - budget as total_profit
from movies_records
where gross_numeric_total_earning > budget;






