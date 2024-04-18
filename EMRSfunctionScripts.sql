/* Edit/correct a patient's address */
DELIMITER //
CREATE PROCEDURE edit_patient_address
(
p_id_param	INT, /* patient id */
address_param	VARCHAR(100) /* correct address */
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
    UPDATE patients SET address = address_param WHERE id = p_id_param;
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//
# Test the procedure:
# CALL edit_patient_address(5, "560 Meadowmont Drive, Durham, NC 27707");

/* Edit/correct a patient's insurance ID */
DELIMITER //
CREATE PROCEDURE edit_patient_insurance_id
(
p_id_param	INT, /* patient id */
insurance_id_param	VARCHAR(20) /* correct insurance ID */
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
    UPDATE patients SET insurance_id = insurance_id_param WHERE id = p_id_param;
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Edit/correct a patient's insurance provider */
DELIMITER //
CREATE PROCEDURE edit_patient_insurance_provider
(
p_id_param	INT, /* patient id */
insurance_param	VARCHAR(100) /* correct insurance provider */
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
    UPDATE patients SET insurance = insurance_param WHERE id = p_id_param;
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Create an appointment */
DELIMITER //
CREATE PROCEDURE create_appointment
(
p_id_param	INT, 
date_param DATE,
time_param TIME,
facility_param INT,
room_param INT,
doctor_id_param INT
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
    INSERT INTO appointments (patient_id, date, time, facility_id, room, doctor_id) 
    VALUES (p_id_param, date_param, time_param, facility_param, room_param, doctor_id_param);
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Create a health Record */
DELIMITER //
CREATE PROCEDURE create_health_record
(
p_id_param	INT, 
date_param DATE,
diagnosis_param VARCHAR(100),
status_param VARCHAR(20),
description_param VARCHAR(256),
doctor_id_param INT
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
    INSERT INTO healthRecords (patient_id, date, diagnosis, status, description, doctor_id) 
    VALUES (p_id_param, date_param, diagnosis_param, status_param, description_param, doctor_id_param);
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Add notes to the description of a health record */
DELIMITER //
CREATE PROCEDURE add_notes
(
record_id_param	INT,
description_param VARCHAR(256)
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
    UPDATE healthRecords SET description = description + description_param WHERE id = record_id_param;
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Create a prescription */
DELIMITER //
CREATE PROCEDURE create_prescription
(
p_id_param	INT, 
date_param DATE,
med_id_param INT,
daily_amount_param VARCHAR(100),
record_id_param INT,
doctor_id_param INT
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
   INSERT INTO prescriptions (date, patient_id, med_id, daily_amount, healthRecord_id, doctor_id) 
   VALUES (date_param, p_id_param, med_id_param, daily_amount_param, record_id_param, doctor_id_param);
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Make an order (for a service : test or exam) */
DELIMITER //
CREATE PROCEDURE make_order
(
date_param VARCHAR(10),
service_code_param INT,
doctor_id_param INT,
p_id_param	INT
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    START TRANSACTION;
    
   INSERT INTO orders (date, service_code, doctor_id, patient_id) VALUES (date_param, service_code_param, doctor_id_param, p_id_param);
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//

/* Create an invoice */
DELIMITER //
CREATE PROCEDURE create_invoice
(
date_param DATE,
p_id_param	INT,
record_id_param INT,
amount_paid_param INT,
copay_param INT
)
BEGIN
	DECLARE sql_error TINYINT DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET sql_error = TRUE;
	
    IF amount_paid_param IS NULL THEN
		SET amount_paid_param = 0;
	END IF;
    
    START TRANSACTION;
    
   INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) 
   VALUES (date_param, calculate_invoice_total(p_id_param,record_id_param,copay_param), amount_paid_param, p_id_param, record_id_param);
        
    IF sql_error = FALSE THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;
END//
/* Test the procedure: 
CALL create_invoice(STR_TO_DATE('01 01 2023','%m %d %Y'), 4, 4, 25, 25); */

/* Calculate total payment due for the invoice. Must know the patient's co pay to use this function. */
DELIMITER //
    CREATE FUNCTION calculate_invoice_total
    (
        p_id_param	INT,
        record_id_param	INT,
        copay_param INT
	)
    RETURNS INT
    DETERMINISTIC READS SQL DATA
    BEGIN
		DECLARE med_price INT;
		DECLARE service_fee INT;
        DECLARE presc_id_var INT;
        DECLARE order_id_var INT;
        DECLARE invoice_total INT;
        
        SELECT prescriptions.id INTO presc_id_var FROM prescriptions WHERE healthRecord_id = record_id_param;
        
        IF presc_id_var IS NOT NULL THEN
			SELECT meds.price INTO med_price FROM meds, prescriptions WHERE prescriptions.id = presc_id_var AND prescriptions.med_id = meds.id;
        ELSE
			SET med_price = 0;
		END IF;
        
		SELECT orders.id INTO order_id_var FROM orders WHERE healthRecord_id = record_id_param;
        
        IF order_id_var IS NOT NULL THEN
			SELECT services.fee INTO service_fee FROM services, orders WHERE orders.id = order_id_var AND orders.service_code = services.code;
        ELSE
			SET service_fee = 0;
		END IF;

        SELECT med_price + service_fee + copay_param INTO invoice_total;
        
		RETURN(invoice_total);
	END//
/* Test the function: */
    /*INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) 
    VALUES (STR_TO_DATE('01 01 2023','%m %d %Y'), calculate_invoice_total(4,4,25), 25, 4, 4);*/
    /*INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) 
    VALUES (STR_TO_DATE('01 02 2023','%m %d %Y'), calculate_invoice_total(1,6,30), 30, 1, 6);*/
    /*INSERT INTO invoices (date, total_amount, amount_paid, patient_id, healthRecord_id) 
    VALUES (STR_TO_DATE('01 10 2023','%m %d %Y'), calculate_invoice_total(5,7,20), 0, 5, 7);*/


    
    