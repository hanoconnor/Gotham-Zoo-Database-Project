create database gotham_zoo;
use gotham_zoo;

-- REQUIREMENT: Create relational DB of your choice with minimum 5 tables (DB contains 9 tables - adoption audit log table built in Gotham_Zoo_Adoption_audit_log.sql)
-- REQUIREMENT: Set Primary and Foreign Key constraints to create relations between the tables 
-- REQUIREMENT: Create DB diagram where all table relations are shown (Model & EER Diagram created: Gotham_Zoo_Database_Model.mwb)

-- Keepers Table (Data added manually)

create table Keepers (
Keeper_ID varchar(3),
First_Name varchar(20),
Surname varchar(20),
Date_started date, 
Status varchar(10),
Speciality varchar(10),
Salary integer, 
DOB date,
primary key (Keeper_ID)
);

insert into 
gotham_zoo.keepers
(Keeper_ID, First_Name, Surname, Date_started, Status, Speciality, Salary, DOB)
values
('K1', 'Kate', 'Kane', '2019-01-01', 'Head', 'Mammals', 50000, '1990-01-26'),
('K2', 'Bruce', 'Wayne', '1995-12-31', 'Head', 'Bats', 50000, '1977-02-19'),
('K3', 'Selina', 'Kyle', '2005-04-01', 'Head', 'Big Cats', 50000, '1988-03-14'),
('K4', 'Renee', 'Montoya', '2006-06-01', 'Head', 'Mammals', 50000, '1985-02-14'),
('K5', 'Oswald', 'Cobblepot', '1995-01-01', 'Senior', 'Birds', 35000, '1941-12-01'),
('K6', 'Waylon', 'Jones', '1990-04-01', 'Senior', 'Reptiles', 35000, '1968-06-03'),
('K7', 'Maggie', 'Sawyer', '2008-09-05', 'Senior', 'General', 35000, '1987-03-29'),
('K8', 'Pamela', 'Isley', '2009-03-22', 'Senior', 'General', 35000, '1966-06-01'),
('K9', 'Dick', 'Grayson', '2011-06-12', 'Junior', 'General', 20000, '1996-12-01'),
('K10', 'Otis', 'Flanagan', '2012-06-05', 'Junior', 'General', 20000, '1988-04-01'),
('K11', 'Harley', 'Quinn', '2014-01-01', 'Junior', 'General', 20000, '1992-09-11'),
('K12', 'Beth', 'Kane', '2015-07-04', 'Junior', 'General', 20000, '1990-01-26');

select * 
from gotham_zoo.keepers;


-- Enclosures table (Data added manually)

create table Enclosures (
Enclosure_ID varchar(4),
Enclosure_Name varchar(10),
Head_Keeper varchar(3),
primary key (Enclosure_ID),
foreign key (Head_Keeper)
references Keepers(Keeper_ID)
);

insert into
gotham_zoo.enclosures
(enclosure_id, enclosure_name, head_keeper)
values
('EN1', 'Africa', 'K4'),
('EN2', 'Americas', 'K2'),
('EN3', 'Asia', 'K3'),
('EN4', 'Oceania', 'K1');

select *
from gotham_zoo.enclosures;


-- Paddocks table (Data imported from csv)

create table
paddocks (
Paddock_ID varchar(5),
Enclosure varchar(4),
Responsible_Keeper varchar(3),
primary key (Paddock_ID),
foreign key (Enclosure)
references Enclosures(Enclosure_ID),
foreign key (Responsible_Keeper)
references Keepers(Keeper_ID)
);

select *
from gotham_zoo.paddocks;


-- Species table (Data imported from CSV file)

create table 
Species (
Species_ID varchar(5),
Species_Name varchar(50),
Enclosure_ID varchar(4),
Species_Class varchar(50),
Species_Order varchar(50),
Family varchar(50),
Genus varchar(50),
Conservation_Status varchar(2),
primary key (Species_ID),
foreign key (Enclosure_ID)
references enclosures(enclosure_ID)
);

select *
from gotham_zoo.species;

-- Tickets table (Data added manually)
create table 
ticket_sales (
Ticket_ID integer,
Ticket_Type varchar(30),
Ticket_Price decimal(5,2),
Sales_Volume integer,
Ticket_Income decimal(10,2),
Ticket_Benefits_Species varchar(5),
primary key (Ticket_ID),
foreign key (Ticket_Benefits_Species)
references Species(Species_ID)
);

insert into
gotham_zoo.ticket_sales
(Ticket_ID, Ticket_Type, Ticket_Price, Sales_Volume, Ticket_Income, Ticket_Benefits_Species)
values
(1, 'Adult Day', 30.00, 100000, 3000000.00, 'SP2'),
(2, 'Child Day', 20.00, 75000, 1500000.00, 'SP31'),
(3, 'Infant Day', 0.00, 50000, 0.00, 'SP22'),
(4, 'Senior Day', 25.00, 40000, 1000000.00, 'SP1'),
(5, 'Student Day', 25.00, 25000, 625000.00, 'SP3'),
(6, 'Family Day', 75.00, 75000, 5625000.00, 'SP5'),
(7, 'Adult Annual Pass', 250.00, 5000, 1250000.00, 'SP12'),
(8, 'Child Annual Pass', 150.00, 4500, 675000.00, 'SP18'),
(9, 'Concession Annual Pass', 200, 2000, 400000.00, 'SP32'),
(10, 'Family Annual Pass', 600, 10000, 6000000.00, 'SP44');

select * 
from gotham_zoo.ticket_sales;


-- Adoption table (data added manually)

create table adoption (
Adoption_Pack integer,
Species_ID varchar(5),
Adoption_Cost decimal(5,2),
Sales_Volume integer,
Sales_Income decimal(10,2),
primary key (Adoption_Pack),
foreign key (Species_ID)
references Species(Species_ID)
);

insert into
gotham_zoo.adoption
(adoption_pack, species_id, adoption_cost, sales_volume, sales_income)
values
(1, 'SP44', 50.00, 300, 15000.00),
(2, 'SP5', 25.00, 250, 6250.00),
(3, 'SP38', 25.00, 500, 12500.00),
(4, 'SP1', 25.00, 400, 10000.00),
(5, 'SP2', 25.00, 250, 6250.00),
(6, 'SP16', 25.00, 550, 13750.00),
(7, 'SP39', 15.00, 100, 1500.00),
(8, 'SP42', 15.00, 50, 750.00);

select *
from gotham_zoo.adoption
;


-- Animal_Inventory table (Data imported from csv)

create table
animal_inventory (
Animal_ID varchar(6),
Species_ID varchar(5),
Animal_Name varchar(25),
Age integer,
Sex varchar(1),
Year_Arrived integer,
Origin_Zoo varchar(50),
Origin_Country varchar(50),
Paddock_ID varchar(5),
primary key (Animal_ID),
foreign key (Species_ID)
references species(Species_ID),
foreign key (Paddock_ID)
references Paddocks(Paddock_ID)
);

select *
from gotham_zoo.animal_inventory;


-- Conservation table (Data imported from csv)

create table 
conservation (
Conservation_ID varchar(5),
Animal_ID varchar(6),
Captive_Bred tinyint(1),
Offspring integer,
primary key (Conservation_ID),
foreign key (Animal_ID)
references animal_inventory(Animal_ID)
);

select *
from gotham_zoo.conservation;

