use gotham_zoo;

-- Demonstrate model first (9 tables inc audit log)
-- Idea: Gotham Zoo database allows the zoo to store and manage data on their animal inventory, enclosures, keepers, conservation programme, animal adoptions and ticket sales. Dataset is fictitious - put together to showcase the project.

-- Demonstrate sample table data

select * 
from animal_inventory;

select * 
from adoption;

select *
from species;

-- VIEWS & Queries

-- Basic Adoption View with Species Info & Query with a subquery to ascertain good future candidate species for adoption programme

-- create view Adoption_Species_Info
-- as
-- select 
-- t1.Adoption_Pack, t1.Species_ID, t2.Species_Name, t1.Sales_Income, t1.Sales_Volume, t2.Conservation_Status
-- from gotham_zoo.adoption t1
-- left join gotham_zoo.species t2
-- on t1.Species_ID = t2.Species_ID;

select * from adoption_species_info;

select 
species_id, species_name, conservation_status
from gotham_zoo.species
where Species_ID not in 
(select Species_ID
from adoption_species_info)
having Conservation_Status
in ('CR', 'EN', 'VU')
;

-- Animal view with Species Name, Con Status and Origin Country for analysis

select *
from gotham_zoo.animal_inventory;

select *
from gotham_zoo.species;

--create view Animal_Inventory_w_Species_Info
as
select 
t1.Animal_ID, t1.Animal_Name, t1.Species_ID, t2.Species_Name, t2. Conservation_Status, t1.Origin_Country, t2.Species_Class, t2.Species_Order
from gotham_zoo.animal_inventory t1
left join gotham_zoo.species t2
on t1.Species_ID = t2.Species_ID;

select * 
from Animal_Inventory_w_Species_Info;

-- Query from Animal_Inventory_w_Species_Info view to ascertain representation of 'at risk' species
select 
conservation_status, count(conservation_status) as Con_Status_Count
from Animal_Inventory_w_Species_Info
group by conservation_status
having conservation_status in ('EW', 'CR', 'EN', 'VU', 'NT');

-- Query from Animal_Inventory_w_Species_Info view to ascertain representation of origin zoos by country
select origin_Country, count(Origin_Country) as Origin_Country_Count
from Animal_Inventory_w_Species_Info
group by origin_Country;

-- TABLEAU DASHBOARDS At Risk Species & Origin Zoos By Country


-- HR View Responsible Keepers (HR view joining 4 tables to demonstrate the keepers responsible for each paddock with the relevant species information ordered by keeper ID)

--create view HR_Responsible_Keepers
as
select
t1.Paddock_ID, t3.Species_ID, t4.Species_Name, t1.Responsible_Keeper, t2.First_Name, t2.Surname, t2.Status
from 
gotham_zoo.paddocks t1
left join 
gotham_zoo.keepers t2
on
t1.Responsible_Keeper = t2.Keeper_ID
right join 
gotham_zoo.animal_inventory t3
on t1.Paddock_ID = t3.Paddock_ID
left join
gotham_zoo.species t4
on t3.Species_ID = t4.Species_ID
group by t1.Paddock_ID
order by t1.Responsible_Keeper asc
;

select *
from hr_responsible_keepers;

select 
responsible_keeper, first_name, surname, status, count(paddock_id) as Total_Paddocks
from hr_responsible_keepers
group by responsible_keeper;

-- Query to ascertain total paddocks for each Senior Keeper (query with group by and having to demonstrate how to extract data from your DB for analysis)

select 
responsible_keeper, first_name, surname, status, count(paddock_id) as Total_Paddocks
from hr_responsible_keepers
group by responsible_keeper
having status in ('head', 'senior');

-- TABLEAU DASHBOARD Paddocks per Keeper

-- FUNCTIONS
-- Stored function to determine no. of years employed for each zoo keeper from the start dates

select *
from gotham_zoo.keepers;

show function status 
where db = 'gotham_zoo';

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

-- TABLEAU DASHBOARD Keepers Years Employed


-- PROCEDURES
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

-- TRIGGERS & EVENT

show triggers;

-- Demonstrate adoption table audit log w. triggers and event
-- Triggers create audit log entry for any rows inserted, updated or deleted in the adoption table

-- create insert audit trigger
Delimiter //
create trigger adoption_insert_audit
after insert on gotham_zoo.adoption
for each row
begin
insert into gotham_zoo.adoption_audit_log (
adoption_pack,
old_row_data,
new_row_data,
dml_type,
dml_timestamp)
values
(new.adoption_pack,
null,
json_object(
'species_id', new.species_id,
'adoption_cost', new.adoption_cost,
'sales_volume', new.sales_volume,
'sales_income', new.sales_income),
'insert',
current_timestamp);
end//

-- example data to be inserted into table 
insert into
gotham_zoo.adoption
(adoption_pack, species_id, adoption_cost, sales_volume, sales_income)
values
(9, 'SP7', 50.00, 0, 0.00);

select *
from gotham_zoo.adoption;

select *
from gotham_zoo.adoption_audit_log;

delete from gotham_zoo.adoption where species_id ='SP7';


-- Scheduled Event to clear audit log on annual basis

show events;

Delimiter //
create event annual_delete_audit_rows
on schedule every 1 year
starts current_timestamp
do 
delete from gotham_zoo.adoption_audit_log
where dml_timestamp < now() - interval 1 year; 
end//

-- Can add one-time delete to demo (if time) - will be auto-dropped from events as one-time event

Delimiter //
create event one_time_delete_audit_rows
on schedule at current_timestamp
do 
delete from gotham_zoo.adoption_audit_log
where dml_timestamp < now() - interval 1 day; 
end//

