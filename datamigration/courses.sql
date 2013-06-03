create table courses_people (course_id int, person_id int);
insert into courses_people (course_id, person_id) select "1", id from people where training_group="Jugend/Erwachsene";
insert into courses_people (course_id, person_id) select "2", id from people where training_group="Oberstufe";
insert into courses_people (course_id, person_id) select "3", id from people where training_group="Unterstufe";
insert into courses_people (course_id, person_id) select "4", id from people where training_group="Mini 1";
insert into courses_people (course_id, person_id) select "5", id from people where training_group="Mini 2";
insert into courses_people (course_id, person_id) select "6", id from people where training_group="Bonsai 1";
insert into courses_people (course_id, person_id) select "7", id from people where training_group="Bonsai 2";
insert into courses_people (course_id, person_id) select "8", id from people where training_group="Bonsai 3";
insert into courses_people (course_id, person_id) select "9", id from people where training_group="Best Age";


