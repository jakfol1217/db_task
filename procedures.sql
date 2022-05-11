ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY HH24:MI:SS';
create or replace package procedury
is
reduced_fare number := 20;
normal_fare number := 35;
procedure add_movie(title varchar2,
director_name varchar2 default NULL,
director_last_name varchar2 default NULL,
running_time number default NULL);
procedure reserve_seat(seat_n number,
r_id number,
s_id number,
red number);
procedure buy_ticket(seat_n number,
r_id number,
s_id number, 
red number);

end procedury;
create or replace package body procedury
is

--dodawanie nowego filmu
procedure add_movie(title varchar2,
director_name varchar2 default NULL,
director_last_name varchar2 default NULL,
running_time number default NULL)
as
begin
insert into movies(title, director_name, director_last_name, running_time)
values (title, director_name, director_last_name, running_time);
end;


--rezerwowanie miejsca  
procedure reserve_seat(seat_n number,
r_id number,
s_id number,
red number)

as

date_ex exception;
pragma exception_init(date_ex, -20001);

taken_ex exception;
pragma exception_init(taken_ex, -20002);

startdate date;
validto date;
currentdate date;

begin

select start_time into startdate
from screenings
where screening_id=s_id;

begin
select valid_to into validto
from tickets
where ticket_id=(select max(ticket_id) from tickets where screening_id=s_id and seat_number=seat_n and room_id=r_id);
exception
   when NO_DATA_FOUND then
   validto:=NULL;
end;
select CURRENT_DATE into currentdate
from dual;

if validto is not null and validto > currentdate then
    raise_application_error(-20001, 'Seat is already taken');
elsif startdate < currentdate then
    raise_application_error(-20002, 'Screening has already started');
else
--tworzymy nowy nieoplacony bilet na dany seans, numer siedzenia i sali, wazny do poczatku seansu
insert into tickets(screening_id, room_id, seat_number, price, reduced, paid, valid_from, valid_to)
values (s_id, r_id, seat_n, case when red=1 then procedury.reduced_fare else procedury.normal_fare end, red, 0, currentdate, startdate);

end if;
end;


--zakup wczesniej zarezerwowanego miejsca
procedure buy_ticket(seat_n number,
r_id number,
s_id number, 
red number)

as

date_ex exception;
pragma exception_init(date_ex, -20001);

paid_ex exception;
pragma exception_init(paid_ex, -20002);

enddate date;
validto date;
paid number;
currentdate date;
  
begin

begin
select paid into paid
from tickets
where ticket_id=(select max(ticket_id) from tickets where screening_id=s_id and seat_number=seat_n and room_id=r_id);

select valid_to into validto
from tickets
where ticket_id=(select max(ticket_id) from tickets where screening_id=s_id and seat_number=seat_n and room_id=r_id);

exception
   when NO_DATA_FOUND then
   validto := NULL;
   paid := 0;
end;

select end_time into enddate
from screenings
where screening_id=s_id;

select CURRENT_DATE into currentdate
from dual;

if validto is null then
--jesli nie byl rezerwowany, to zostaje zarezerwowany
    reserve_seat(seat_n, r_id, s_id, red);
elsif enddate < currentdate then
    raise_application_error(-20001, 'Screening has already ended');
elsif paid=1 then
    raise_application_error(-20001, 'Ticket is already paid');
end if;
--ostatni zarezerwonany ale nieoplacony bilet na to miejsce zamieniamy na oplacony

update tickets
set paid=1, valid_to=enddate
where ticket_id=(select max(ticket_id) from tickets where screening_id=s_id and seat_number=seat_n and room_id=r_id);


--zmniejszamy liczbe wolnych miejsc w seansie (jest to czynione dopiero po tym, jak bilet zostal zakupiony)
update screenings
set free_seats = free_seats - 1
where screening_id=s_id;

end;

end procedury;



