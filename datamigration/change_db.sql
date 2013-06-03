# Docs
rename table docs to documents;
update documents set created_at="2000-01-01 00:00:00" where created_at is null;
update documents set updated_at="2000-01-01 00:00:00" where updated_at is null;

# Gradings
alter table gradings drop column expert_person_id;
alter table gradings drop column teacher_person_id;
alter table gradings drop column program_id;
update gradings set created_at="2000-01-01 00:00:00" where created_at is null;
update gradings set updated_at="2000-01-01 00:00:00" where updated_at is null;

# Bills
alter table bills change mail_firstname bill_firstname varchar(255);
alter table bills change mail_lastname bill_lastname varchar(255);
alter table bills change street bill_street varchar(255);
alter table bills change kind bill_type varchar(255);
alter table bills drop column salutation1;
alter table bills change salutation2 salutation varchar(255);
alter table bills add column bill_zipcity varchar(255);
create table bill_temp (id int, zip varchar(255), city varchar(255));
insert into bill_temp (id, zip, city) select id, zip, city from bills;
update bills set bill_zipcity = (select concat(zip, " ", city) from bill_temp where bills.id=bill_temp.id);
alter table bills drop column zip;
alter table bills drop column city;
drop table bill_temp;
update bills set bill_type="Erste Mahnung" where bill_type="Mahnung 1";
update bills set bill_type="Zweite Mahnung" where bill_type="Mahnung 2";
update bills set created_at="2000-01-01 00:00:00" where created_at is null;
update bills set updated_at="2000-01-01 00:00:00" where updated_at is null;

# People
alter table people change mail_firstname bill_firstname varchar(255);
alter table people change mail_lastname bill_lastname varchar(255);
alter table people add column bill_street varchar(255);
alter table people add column bill_zipcity varchar(255);
alter table people add column bill_email varchar(255);
alter table people add column image varchar(255);
alter table people drop column salutation1;
alter table people change salutation2 salutation varchar(255);
update people set salutation = "Herr" where salutation = "Herrn";
alter table people drop column email_allowed;
alter table people drop column sex;
alter table people drop column belt;
alter table people drop column has_qualitopsheet;
alter table people drop column pass_location;
alter table people drop column parent_email;
alter table people drop column parent_email_allowed;
alter table people change people.entry entry_date date;
alter table people change people.leave leave_date date;
update people set leave_date = NULL where leave_date="0000-00-00";
alter table people drop column training_group;
alter table people drop column is_teacher;
alter table people drop column is_expert;
alter table people drop column is_assistant;
alter table people add column zipcity varchar(255);
create table p_temp (id int, zip varchar(255), city varchar(255));
insert into p_temp (id, zip, city) select id, zip, city from people;
update people set zipcity = (select concat(zip, " ", city) from p_temp where people.id=p_temp.id);
alter table people drop column zip;
alter table people drop column city;
drop table p_temp;
update people set created_at="2000-01-01 00:00:00" where created_at is null;
update people set updated_at="2000-01-01 00:00:00" where updated_at is null;

# Notes
alter table notes drop column note_author;
alter table notes drop column note_date;

# Tables that are already filled in new DB
drop table articles;
drop table schema_migrations;
drop table grades;
