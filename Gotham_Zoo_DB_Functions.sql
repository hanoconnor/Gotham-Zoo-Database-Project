use gotham_zoo;

-- REQUIREMENT: In your database, create a stored function that can be applied to a query in your DB 
-- Stored function to determine no. of years employed for each zoo keeper

select *
from gotham_zoo.keepers;

DELIMITER //

create function Years_Employed (date1 date) returns int deterministic
begin
 declare date2 date;
  Select current_date()into date2;
  return year(date2)-year(date1);
end 

//

DELIMITER ;

Select 
keeper_id, first_name, surname, Years_Employed(date_started) as 'years' 
from gotham_zoo.keepers;

show function status 
where db = 'gotham_zoo';

-- REQUIREMENT ADV: In your database, create a stored procedure and demonstrate how it runs
-- Stored Procedure to enable 'quick add' for species table

DELIMITER //
create procedure InsertSpecies(
in Species_ID varchar(5),
in Species_Name varchar(50),
in Enclosure_ID varchar(4),
in Species_Class varchar(50),
in Species_Order varchar(50),
in Family varchar(50),
in Genus varchar(50),
in Conservation_Status varchar(2))
begin
insert into species(Species_ID, Species_Name, Enclosure_ID, Species_Class, Species_Order, Family, Genus, Conservation_Status)
values (Species_ID, Species_Name, Enclosure_ID, Species_Class, Species_Order, Family, Genus, Conservation_Status);
end//
DELIMITER ;
​
-- EXAMPLE data to add: 
call InsertSpecies ('SP45', 'Guam Kingfisher', 'EN2', 'Aves', 'Coraciiformes', 'Alcedinidae', 'Todiramphus', 'EW' );
​
select *
from gotham_zoo.species;

delete from gotham_zoo.species where Species_ID='SP45';

-- REQUIREMENT ADV: In your database, create a trigger and demonstrate how it runs
-- Stored Trigger - ensures all entries for conservation status are upper case for consistency
DELIMITER //
create trigger Con_Status_Upper_Case
before insert on gotham_zoo.species
for each row
begin
	set new.Conservation_Status = UPPER(new.Conservation_Status);
end//


-- EXAMPLE data to add: 
CALL InsertSpecies ('SP45', 'Guam Kingfisher', 'EN2', 'Aves', 'Coraciiformes', 'Alcedinidae', 'Todiramphus', 'ew');

delete from gotham_zoo.species where Species_ID='SP45';

-- Stored Trigger Example - ensures title case for added species on species table

DELIMITER //
create trigger Species_Name_Title_Case
before insert on gotham_zoo.species
for each row
begin
	set new.Species_Name =  CONCAT(UPPER(SUBSTRING(new.Species_Name,1,1)),
						LOWER(SUBSTRING(new.Species_Name from 2)));
end//


-- EXAMPLE data to add: 
CALL InsertSpecies ('SP45', 'guam kingfisher', 'EN2', 'Aves', 'Coraciiformes', 'Alcedinidae', 'Todiramphus', 'ew');

delete from gotham_zoo.species where Species_ID='SP45';

