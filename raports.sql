--we wszystkich raportach bierzemy pod uwage tylko seanse w pelni zakonczone


--pierwsze zapytanie

define start_date1 = to_date('31-12-21','DD-MM-YY');
define end_date1 = to_date('31-12-22','DD-MM-YY');

select m.title, sum(price) as "ticket_revenue" from
screenings s join movies m on m.movie_id=s.movie_id join tickets t on t.screening_id=s.screening_id
where s.start_time > &&start_date1 and s.end_time < &&end_date1 and t.paid=1
group by title;


--drugie zapytanie

define start_date2 = to_date('31-12-21','DD-MM-YY');
define end_date2 = to_date('31-12-22','DD-MM-YY');

select
avg((r.no_seats-s.free_seats)/r.no_seats) as "frequency", title from
screenings s join movies m on m.movie_id=s.movie_id join rooms r on s.room_id=r.room_id
where s.start_time > &&start_date2 and s.end_time < &&end_date2
group by title
order by avg((r.no_seats-s.free_seats)/r.no_seats) desc
fetch next 1 rows only;



--trzecie zapytanie

define start_date3 = to_date('31-12-21','DD-MM-YY');
define end_date3 = to_date('31-12-22','DD-MM-YY');
define room = 1;
define row_limit = 3;

select t.seat_number, count(*) as "times_reserved"  from
tickets t join screenings s on t.screening_id=s.screening_id
where s.start_time > &&start_date3 and s.end_time < &&end_date3 and t.room_id = &&room
group by t.seat_number
order by count(*) desc
fetch next &&row_limit rows only;





















