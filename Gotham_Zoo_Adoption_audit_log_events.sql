use gotham_zoo;

-- REQUIREMENT ADV: In your database, create an event and demonstrate how it runs 
-- Scheduled event created to automatically delete adoption audit log data after a 1 year period

-- set event scheduler to on
set global event_scheduler = on;

-- Scheduled Event to clear audit log annually
Delimiter //
create event annual_delete_audit_rows
on schedule every 1 year
starts current_timestamp
do 
delete from gotham_zoo.adoption_audit_log
where dml_timestamp < now() - interval 1 year; 
end//

show events;

-- Can add one-time delete to demo

Delimiter //
create event one_time_delete_audit_rows
on schedule at current_timestamp
do 
delete from gotham_zoo.adoption_audit_log
where dml_timestamp < now() - interval 1 day; 
end//
