/* Electronic Medical Records System (EMRS) for NovoCare, a primary care provider/clinic for all ages */
DROP DATABASE IF EXISTS emrs;
CREATE DATABASE emrs;
USE emrs;

DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS appointments CASCADE;
DROP TABLE IF EXISTS meds CASCADE;
DROP TABLE IF EXISTS healthRecords CASCADE;
DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS invoices CASCADE;

CREATE TABLE patients (
    id INT NOT NULL auto_increment,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    sex VARCHAR(8),
    age INT,
    address VARCHAR(100),
    phone VARCHAR(10),
    email  VARCHAR(100), 
    insurance VARCHAR(100),
    insurance_id VARCHAR(20),
    PRIMARY KEY (id)
);

INSERT INTO patients (first_name, last_name, sex, age, address, phone, email, insurance, insurance_id)
VALUES  ('Noble', 'Obodum', 'Male', 22, '300 Northbend Drive, Raleigh, NC 27602', '7042322233', 'nobleo@gmail.com', 'Blue Cross Blue Shield', 'YPYX23832483'),
('Eden', 'Obodum', 'Male', 18, '232 Middlebury Lane, Durham, NC 27713', '9196838885', 'eden123@gmail.com', 'Aetna', 'ZDHC623724632'),
('Jaden', 'Obodum', 'Male', 17, '232 Middlebury Lane, Durham, NC 27713', '9192329967', 'jadenkwame@gmail.com', 'Aetna', 'ZDHC23623743'),
('Gia', 'Wakefield', 'Female', 14, '3950 Ravenscroft Court, Raleigh, NC 27602', '9195436573', 'gia.wakefield@hotmail.com', 'United Healthcare', 'UNQA08978878'),
('Alena', 'Smith', 'Female', 32, '560 Meadowmont Drive, Chapel Hill, NC 27516', '9193935167', 'asmith@yahoo.com', 'Cigna', 'PHTS9062378864'),
('Zoey', 'Johnson', 'Female', 25, '300 Aviator Court, Raleigh, NC 27602', '9194897680', 'zoeyjohn@hotmail.com', 'Blue Cross Blue Shield', 'YPYX69878891');

CREATE TABLE facilities (
    id INT NOT NULL auto_increment,
    name VARCHAR(100),
    PRIMARY KEY (id)
); 
INSERT INTO facilities (name) VALUES ('Novocare Durham');
INSERT INTO facilities (name) VALUES ('Novocare Raleigh');

CREATE TABLE doctors (
    id INT NOT NULL auto_increment,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    specialty VARCHAR(100),
    phone VARCHAR(10),
    email VARCHAR(100),
    facility_id INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_doctors_facilities FOREIGN KEY (facility_id) REFERENCES facilities(id)
); 

INSERT INTO doctors (first_name, last_name, specialty, phone, email, facility_id) 
VALUES ('Mike', 'Folken', 'primary care', '9199494181', 'mike.folken@novocare.com', 1),
('Tabitha', 'Holiday', 'pediatrician', '9196838075', 'tabitha.holiday@novocare.com', 1),
('Briana', 'Alexander', 'OB-GYN', '9193455805', 'briana.alexander@novocare.com', 1),
('Steve', 'Perry', 'pediatrician', '9192211287', 'steve.perry@novocare.com', 2),
('Marcus', 'Lee', 'primary care', '9199223585', 'marcus.lee@novocare.com', 2),
('Brenda', 'Agyemang', 'OB-GYN', '9198962972', 'brenda.agyemang@novocare.com', 2);

CREATE TABLE appointments (
    id INT NOT NULL auto_increment,
    patient_id INT NOT NULL,
    date DATE,
    time TIME,
    facility_id INT,
    room INT,
    doctor_id INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_appointments_patients FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_appointments_facilities FOREIGN KEY (facility_id) REFERENCES facilities(id),
    CONSTRAINT fk_appointments_doctors FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (5, STR_TO_DATE('04 26 2023','%m %d %Y'), MAKETIME(12,30,00), 1, 114, 3);
INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (6, STR_TO_DATE('04 27 2023','%m %d %Y'), MAKETIME(10,00,00), 2, 110, 6);
INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (3, STR_TO_DATE('04 28 2023','%m %d %Y'), MAKETIME(11,30,00), 1, 112, 2);
INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (2, STR_TO_DATE('05 01 2023','%m %d %Y'), MAKETIME(10,30,00), 1, 114, 1);
INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (4, STR_TO_DATE('05 01 2023','%m %d %Y'), MAKETIME(13,30,00), 2, 120, 4);
INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (1, STR_TO_DATE('05 02 2023','%m %d %Y'), MAKETIME(9,30,00), 2, 110, 5);
INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) VALUES (5, STR_TO_DATE('05 03 2023','%m %d %Y'), MAKETIME(0,30,00), 1, 112, 3);

CREATE TABLE meds (
    id INT NOT NULL auto_increment,
    name VARCHAR(100),
    price INT,
    PRIMARY KEY (id)
);

INSERT INTO meds (name, price) VALUES  ('Tamiflu', 35); /* flu antiviral */
INSERT INTO meds (name, price) VALUES  ('Zanamivir', 45); /* another flu antiviral */
INSERT INTO meds (name, price) VALUES  ('Paxlovid', 100); /* COVID-19 antiviral */
INSERT INTO meds (name, price) VALUES  ('Lagevrio', 200); /* another COVID-19 antiviral (ages 18+) */
INSERT INTO meds (name, price) VALUES  ('Azithromycin', 30); /* antibiotic for various things */
INSERT INTO meds (name, price) VALUES  ('Doxycycline', 20); /* general antibiotic */
INSERT INTO meds (name, price) VALUES  ('Ciprofloxacin', 40); /* as ear drops, antibiotic for ear infections */
INSERT INTO meds (name, price) VALUES ('Amoxicillin', 40); /* pnemonia, bronchitis, etc. */
CREATE INDEX medPrice ON meds (price);
show index in meds;

CREATE TABLE healthRecords (
    id INT NOT NULL auto_increment,
    date DATE, 
    patient_id INT NOT NULL,
    doctor_id INT,
    status VARCHAR(20), /* checkup OR treatment OR preventative OR referral (to a specialist) */
    diagnosis VARCHAR(100),
    description VARCHAR(256), /* signs and symptoms go here, along with any other notes and information */
    PRIMARY KEY (id),
    CONSTRAINT fk_healthRecords_patients FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_healthRecords_doctors FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('04 26 2023','%m %d %Y'), 5, 3, "influenza", "treatment", "Patient tested positive for influenza. Prescribed Tamiflu");
INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('04 27 2023','%m %d %Y'), 6, 6, "ear infection", "treatment", "Patient suffering middle ear infection - prescribed Ciprofloxacin");
INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('04 28 2023','%m %d %Y'), 3, 2, null, "referral", "Patient dealing with persistent acne - refered to dermatologist");
INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 4, 4, "COVID-19", "treatment", "Sore throat, runny nose, loss of taste, fever, body aches. COVID-19 test positive. prescribed Paxlovid");
INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 2, 1, "pnemonia", "treatment", "Patient complaining of severe cough with phlegm, joint aches and pains, sweating, fever, chest pain and difficulty breathing. prescribed Amoxicillin for pneumonia");
INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('05 02 2023','%m %d %Y'), 1, 5, null, "preventative", "Patient traveling abroad, prescribed Doxycycline for malaria");
INSERT INTO healthRecords (date, patient_id, doctor_id, diagnosis, status, description)
VALUES (STR_TO_DATE('05 03 2023','%m %d %Y'), 5, 3, null, "checkup", "pregnancy checkup. everything is looking good - baby is developing normally and mom is healthy.");

CREATE TABLE prescriptions (
    id INT NOT NULL auto_increment,
    date DATE,
    patient_id INT NOT NULL,
    med_id INT NOT NULL,
    daily_amount VARCHAR(100),
    healthRecord_id INT NOT NULL,
    doctor_id INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_prescriptions_patients FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_prescriptions_meds FOREIGN KEY (med_id) REFERENCES meds(id),
    CONSTRAINT fk_prescriptions_healthRecords FOREIGN KEY (healthRecord_id) REFERENCES healthRecords(id),
    CONSTRAINT fk_prescriptions_doctors FOREIGN KEY (doctor_id) REFERENCES doctors(id)
);

INSERT INTO prescriptions (date, patient_id, med_id, daily_amount, healthRecord_id, doctor_id) 
VALUES (STR_TO_DATE('04 26 2023','%m %d %Y'), 5, 1, 'once a day with food', 1, 3);
INSERT INTO prescriptions (date, patient_id, med_id, daily_amount, healthRecord_id, doctor_id) 
VALUES (STR_TO_DATE('04 27 2023','%m %d %Y'), 6, 7, 'one drop in each ear twice a day', 2, 6);
INSERT INTO prescriptions (date, patient_id, med_id, daily_amount, healthRecord_id, doctor_id) 
VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 2, 8, 'one tablet once a day', 5, 1);
INSERT INTO prescriptions (date, patient_id, med_id, daily_amount, healthRecord_id, doctor_id) 
VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 4, 3, 'one tablet twice a day with food', 4, 4);
INSERT INTO prescriptions (date, patient_id, med_id, daily_amount, healthRecord_id, doctor_id) 
VALUES (STR_TO_DATE('05 02 2023','%m %d %Y'), 1, 6, 'two tablets, once a day', 6, 5);

CREATE TABLE services ( /* Services are the exams and tests a doctor can order for a patient. */
	code INT NOT NULL,
    name VARCHAR(100),
    fee INT,
    PRIMARY KEY (code)
);

INSERT INTO services (code, name, fee) VALUES (764534, 'flu test', 20);
INSERT INTO services (code, name, fee) VALUES (289694, 'covid-19 test (RAPID)', 30);
INSERT INTO services (code, name, fee) VALUES (123365, 'yearly checkup labs', 50);
INSERT INTO services (code, name, fee) VALUES (654634, 'pneumonia test', 40);
INSERT INTO services (code, name, fee) VALUES (367852, 'ultrasound', 70);
INSERT INTO services (code, name, fee) VALUES (544465, 'pregnancy checkup tests', 35);
CREATE INDEX serviceFee ON services (fee);
show index in services;

CREATE TABLE orders (
   id INT NOT NULL auto_increment,
   date DATE,
   service_code INT NOT NULL,
   doctor_id INT,
   patient_id INT NOT NULL,
   healthRecord_id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_orders_services FOREIGN KEY (service_code) REFERENCES services(code),
    CONSTRAINT fk_orders_doctors FOREIGN KEY (doctor_id) REFERENCES doctors(id),
    CONSTRAINT fk_orders_patients FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_orders_healthRecords FOREIGN KEY (healthRecord_id) REFERENCES healthRecords(id)
); 

INSERT INTO orders (date, service_code, doctor_id, patient_id, healthRecord_id) VALUES (STR_TO_DATE('04 26 2023','%m %d %Y'), 764534, 3, 5, 1);
INSERT INTO orders (date, service_code, doctor_id, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 654634, 1, 2, 5); 
INSERT INTO orders (date, service_code, doctor_id, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 289694, 4, 4, 4);
INSERT INTO orders (date, service_code, doctor_id, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 03 2023','%m %d %Y'), 544465, 3, 5, 7);

CREATE TABLE invoices (
    id INT NOT NULL auto_increment,
    date DATE,
    total_amount INT,
    amount_paid INT,
	patient_id INT,
    healthRecord_id INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_invoices_patients FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_invoices_healthRecords FOREIGN KEY (healthRecord_id) REFERENCES healthRecords(id)
);

INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('04 26 2023','%m %d %Y'), 75, 75, 5, 1); /* copay: $20 */
INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('04 27 2023','%m %d %Y'), 70, 30, 6, 2); /* copay: $30 */
INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('04 28 2023','%m %d %Y'), 15, 15, 3, 3); /* copay: $15 */
INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 155, 25, 4, 4); /* copay: $25 */
INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 01 2023','%m %d %Y'), 115, 0, 2, 5); /* copay: $35 */
INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 02 2023','%m %d %Y'), 50, 30, 1, 6); /* copay: $30 */
INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) VALUES (STR_TO_DATE('05 03 2023','%m %d %Y'), 55, 0, 5, 7); /* copay: $20 */

