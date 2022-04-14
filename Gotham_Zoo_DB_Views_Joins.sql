use gotham_zoo;

-- REQUIREMENT: Using any type of the joins create a view that combines multiple tables in a logical way 
-- REQUIREMENT:  Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis 
-- Basic Adoption View with Animal Info & Query with a subquery to ascertain good future candidate species for adoption programme

select * from gotham_zoo.adoption;

select * from adoption_species_info;

create view Adoption_Species_Info
as
select 
t1.Adoption_Pack, t1.Species_ID, t2.Species_Name, t1.Sales_Income, t1.Sales_Volume, t2.Conservation_Status
from gotham_zoo.adoption t1
left join gotham_zoo.species t2
on t1.Species_ID = t2.Species_ID;

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

create view Animal_Inventory_w_Species_Info
as
select 
t1.Animal_ID, t1.Animal_Name, t1.Species_ID, t2.Species_Name, t2. Conservation_Status, t1.Origin_Country, t2.Species_Class, t2.Species_Order
from gotham_zoo.animal_inventory t1
left join gotham_zoo.species t2
on t1.Species_ID = t2.Species_ID;

-- Query to ascertain representation of 'at risk' species
select 
conservation_status, count(conservation_status) as Con_Status_Count
from Animal_Inventory_w_Species_Info
group by conservation_status
having conservation_status in ('EW', 'CR', 'EN', 'VU', 'NT');

-- Query to ascertain representation of origin zoos by country
select origin_Country, count(Origin_Country) as Origin_Country_Count
from Animal_Inventory_w_Species_Info
group by origin_Country;

-- REQUIREMENT ADV: Create a view that uses at least 3-4 base tables; prepare and demonstrate a query that uses the view to produce a logically arranged result set for analysis
-- HR View Responsible Keepers (HR view joining 4 tables to demonstrate the keepers responsible for each paddock with the relevant species information ordered by keeper ID)

select *
from gotham_zoo.paddocks;

select *
from gotham_zoo.keepers;

create view HR_Responsible_Keepers
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

-- REQUIREMENT ADV: Prepare an example query with group by and having to demonstrate how to extract data from your DB for analysis 
-- Query to ascertain total paddocks for each Senior Keeper (query with group by and having to demonstrate how to extract data from your DB for analysis)

select 
responsible_keeper, first_name, surname, status, count(paddock_id) as Total_Paddocks
from hr_responsible_keepers
group by responsible_keeper
having status in ('head', 'senior');




