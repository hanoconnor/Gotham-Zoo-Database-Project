use gotham_zoo;

-- REQUIREMENT ADV: In your database, create a trigger and demonstrate how it runs 
-- Adoption table audit log created using triggers to populate data on any amendments (insert, update or delete) made to the adoption table

show triggers;

select *
from gotham_zoo.adoption;

-- Created Adoption table Audit log 

create table
adoption_audit_log (
adoption_pack int,
old_row_data json,
new_row_data json,
dml_type enum('Insert', 'Update', 'Delete') not null,
dml_timestamp timestamp not null,
primary key (adoption_pack, dml_type, dml_timestamp)
);


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

-- example data to be inserted
insert into
gotham_zoo.adoption
(adoption_pack, species_id, adoption_cost, sales_volume, sales_income)
values
(9, 'SP7', 50.00, 0, 0.00);

select *
from gotham_zoo.adoption;

select *
from gotham_zoo.adoption_audit_log;

-- delete from gotham_zoo.adoption_audit_log where Species_ID ='SP7';
-- delete from gotham_zoo.adoption where species_id ='SP7';

-- create update audit trigger
Delimiter //
create trigger adoption_update_audit
after update on gotham_zoo.adoption
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
json_object(
'species_id', old.species_id,
'adoption_cost', old.adoption_cost,
'sales_volume', old.sales_volume,
'sales_income', old.sales_income),
json_object(
'species_id', new.species_id,
'adoption_cost', new.adoption_cost,
'sales_volume', new.sales_volume,
'sales_income', new.sales_income),
'update',
current_timestamp);
end//

-- example update data
update gotham_zoo.adoption
set adoption_cost = 75.00
where species_id ='SP7';

select *
from gotham_zoo.adoption;

select *
from gotham_zoo.adoption_audit_log;

-- create delete audit trigger
Delimiter //
create trigger adoption_delete_audit
after delete on gotham_zoo.adoption
for each row
begin
insert into gotham_zoo.adoption_audit_log (
adoption_pack,
old_row_data,
new_row_data,
dml_type,
dml_timestamp)
values
(old.adoption_pack,
json_object(
'species_id', old.species_id,
'adoption_cost', old.adoption_cost,
'sales_volume', old.sales_volume,
'sales_income', old.sales_income),
null,
'delete',
current_timestamp);
end//

delete from gotham_zoo.adoption where species_id ='SP7';

select *
from gotham_zoo.adoption;

select *
from gotham_zoo.adoption_audit_log;

-- delete from gotham_zoo.adoption_audit_log where Species_ID ='SP7';


