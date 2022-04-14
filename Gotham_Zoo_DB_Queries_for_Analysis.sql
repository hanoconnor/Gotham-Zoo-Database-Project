use gotham_zoo;

select 
conservation_status, count(conservation_status) as Con_Status_Count
from Animal_Inventory_w_Species_Info
group by conservation_status;


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