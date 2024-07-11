SELECT * FROM album
SELECT * FROM EMPLOYEE
--question1
SELECT * from employee
order by levels desc
limit 1
--question2
select  count(*),billing_country from invoice
group by billing_country
order by billing_country desc
--question3
select total from invoice
order by total desc
limit 3
--question4
select sum(total) , billing_city from invoice
group by billing_city
order by billing_city desc
--question5
select customer.customer_id , customer.first_name, customer.last_name , sum(invoice.total) as total
from customer 
join invoice
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc 
limit 1
--question6
Select distinct email, first_name, last_name
from customer 
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock')
	
order by email asc
--question7

select count (assngs.artist_id), assngs.name from artist as assngs
join album on assngs.artist_id = album.artist_id 
join track on album.album_id = track.album_id 
join genre on track.genre_id = genre.genre_id
where genre.name like 'Rock'
group by assngs.artist_id
order by assngs desc
limit 10

--question8
select name, milliseconds from track
where milliseconds >( select avg(milliseconds ) from track)
order by milliseconds desc

--question9
select customer.first_name, customer.last_name, artist.name , invoice.total from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id 
join track on invoice_line.track_id = track.track_id
join album on track.album_id = album.album_id 
join artist on album.artist_id = artist.artist_id

--question10
WITH genre_ranked AS (
    SELECT 
        COUNT(invoice_line.quantity) AS purchase,
        customer.country,
        genre.name,
        genre.genre_id,
        ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS rowNo
    FROM 
        invoice_line
    JOIN 
        invoice ON invoice.invoice_id = invoice_line.invoice_id
    JOIN 
        customer ON customer.customer_id = invoice.customer_id
    JOIN 
        track ON track.track_id = invoice_line.track_id
    JOIN 
        genre ON genre.genre_id = track.genre_id
    GROUP BY 
        customer.country, genre.name, genre.genre_id
)
SELECT * FROM genre_ranked
ORDER BY country ASC, purchase DESC;


--question11
WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1






