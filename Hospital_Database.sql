DROP DATABASE IF EXISTS HOSPITAL;
CREATE DATABASE HOSPITAL CHARACTER SET utf8mb4;
USE hospital;

DROP TABLE IF EXISTS departments;
CREATE TABLE departments(
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE);

DROP TABLE IF EXISTS doctors;
CREATE TABLE doctors (
    doc_id INT AUTO_INCREMENT PRIMARY KEY,
    doc_fname VARCHAR(50) NOT NULL,
    doc_lname VARCHAR(50) NOT NULL,
    doc_SSN VARCHAR(20) UNIQUE NOT NULL,
    doc_bdate DATE NOT NULL,
    doc_pn VARCHAR(20) NOT NULL,
    doc_sex CHAR(1) NOT NULL,
    doc_salary INT,
    doc_hire_date DATE NOT NULL,
    doc_leave_date DATE DEFAULT NULL,  
    doc_dept_id INT NOT NULL,
    CONSTRAINT fk_doc_dept FOREIGN KEY (doc_dept_id) REFERENCES departments(dept_id),
    CONSTRAINT chk_doc_ssn CHECK (doc_SSN REGEXP '^[0-9]{7,11}$'),
    CONSTRAINT chk_doc_pn CHECK (doc_pn REGEXP '^[0-9]{6,15}$'),
    CONSTRAINT chk_doc_sex CHECK (doc_sex IN ('M','F')),
    CONSTRAINT chk_doc_salary CHECK (doc_salary >= 0 AND doc_salary IS NOT NULL),
    CONSTRAINT chk_doc_age CHECK (doc_hire_date >= DATE_ADD(doc_bdate, INTERVAL 18 YEAR)),
    CONSTRAINT chk_doc_leave CHECK (doc_leave_date IS NULL OR doc_leave_date >= doc_hire_date)
) AUTO_INCREMENT=100;

DROP TABLE IF EXISTS nurses;
CREATE TABLE nurses (
    nurse_id INT PRIMARY KEY AUTO_INCREMENT,
    nurse_fname VARCHAR(50) NOT NULL,
    nurse_lname VARCHAR(50) NOT NULL,
    nurse_works_with INT DEFAULT NULL,
    nurse_SSN VARCHAR(20) UNIQUE NOT NULL,
    nurse_bdate DATE NOT NULL,
    nurse_pn VARCHAR(20) NOT NULL,
    nurse_sex CHAR(1) NOT NULL,
    nurse_salary INT,
    nurse_hire_date DATE NOT NULL,
    nurse_leave_date DATE DEFAULT NULL,
    CONSTRAINT fk_nurse_doc FOREIGN KEY (nurse_works_with) REFERENCES doctors(doc_id) ON DELETE SET NULL,
    CONSTRAINT chk_nurse_ssn CHECK (nurse_SSN REGEXP '^[0-9]{7,11}$'),
    CONSTRAINT chk_nurse_pn CHECK (nurse_pn REGEXP '^[0-9]{6,15}$'),
    CONSTRAINT chk_nurse_sex CHECK (nurse_sex IN ('M','F')),
    CONSTRAINT chk_nurse_salary CHECK (nurse_salary >= 0),
    CONSTRAINT chk_nurse_age CHECK (nurse_hire_date >= DATE_ADD(nurse_bdate, INTERVAL 18 YEAR)),
    CONSTRAINT chk_nurse_leave CHECK (nurse_leave_date IS NULL OR nurse_leave_date >= nurse_hire_date)
) AUTO_INCREMENT=100;

DROP TABLE IF EXISTS management;
CREATE TABLE management(
    manager_id INT PRIMARY KEY AUTO_INCREMENT,
    manager_fname VARCHAR(50) NOT NULL,
    manager_lname VARCHAR(50) NOT NULL,
    manager_SSN VARCHAR(20) UNIQUE NOT NULL,
    manager_bdate DATE NOT NULL,
    manager_pn VARCHAR(20) NOT NULL,
    manager_sex CHAR(1) NOT NULL,
    manager_salary INT,
    manager_hire_date DATE NOT NULL,
    manager_leave_date DATE DEFAULT NULL,
    CONSTRAINT chk_mgr_ssn CHECK (manager_SSN REGEXP '^[0-9]{7,11}$'),
    CONSTRAINT chk_mgr_pn CHECK (manager_pn REGEXP '^[0-9]{6,15}$'),
    CONSTRAINT chk_mgr_sex CHECK (manager_sex IN ('M','F')),
    CONSTRAINT chk_mgr_salary CHECK (manager_salary >= 0),
    CONSTRAINT chk_mgr_age CHECK (manager_hire_date >= DATE_ADD(manager_bdate, INTERVAL 18 YEAR)),
    CONSTRAINT chk_mgr_leave CHECK (manager_leave_date IS NULL OR manager_leave_date >= manager_hire_date)
) AUTO_INCREMENT=100;

DROP TABLE IF EXISTS personnels;
CREATE TABLE personnels (
    pers_id INT PRIMARY KEY AUTO_INCREMENT,
    pers_fname VARCHAR(50) NOT NULL,
    pers_lname VARCHAR(50) NOT NULL,
    pers_SSN VARCHAR(20) UNIQUE NOT NULL,
    pers_bdate DATE NOT NULL,
    pers_pn VARCHAR(20) NOT NULL,
    pers_sex CHAR(1) NOT NULL,
    pers_salary INT,
    pers_cleaning CHAR(1) DEFAULT NULL,   -- if yes, fill in 'Y'
    pers_security CHAR(1) DEFAULT NULL,   -- if yes, fill in 'Y'
    pers_hire_date DATE NOT NULL,
    pers_leave_date DATE DEFAULT NULL,
    CONSTRAINT chk_pers_ssn CHECK (pers_SSN REGEXP '^[0-9]{7,11}$'),
    CONSTRAINT chk_pers_pn CHECK (pers_pn REGEXP '^[0-9]{6,15}$'),
    CONSTRAINT chk_pers_sex CHECK (pers_sex IN ('M','F')),
    CONSTRAINT chk_pers_salary CHECK (pers_salary >= 0),
    CONSTRAINT chk_pers_age CHECK (pers_hire_date >= DATE_ADD(pers_bdate, INTERVAL 18 YEAR)),
    CONSTRAINT chk_pers_leave CHECK (pers_leave_date IS NULL OR pers_leave_date >= pers_hire_date),
    CONSTRAINT chk_pers_role CHECK ((pers_cleaning = 'Y' AND pers_security IS NULL) OR (pers_security = 'Y' AND pers_cleaning IS NULL))
) AUTO_INCREMENT=100;

DROP TABLE IF EXISTS patients;
CREATE TABLE patients(
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    patient_fname VARCHAR(50) NOT NULL,
    patient_lname VARCHAR(50) NOT NULL,
    patient_SSN VARCHAR(20) UNIQUE NOT NULL,
    patient_bdate DATE NOT NULL,
    patient_pn VARCHAR(20) NOT NULL,
    patient_relative_pn VARCHAR(20) DEFAULT NULL,
    patient_sex CHAR(1) NOT NULL,
    CONSTRAINT chk_pat_ssn CHECK (patient_SSN REGEXP '^[0-9]{7,11}$'),
    CONSTRAINT chk_pat_pn CHECK (patient_pn REGEXP '^[0-9]{6,15}$'),
    CONSTRAINT chk_pat_rpn CHECK (patient_relative_pn IS NULL OR patient_relative_pn REGEXP '^[0-9]{6,15}$'),
    CONSTRAINT chk_pat_sex CHECK (patient_sex IN ('M','F'))
) AUTO_INCREMENT=100;

DROP TABLE IF EXISTS operations;
CREATE TABLE operations(
    op_id INT PRIMARY KEY AUTO_INCREMENT,
    doc_id INT NOT NULL,
    patient_id INT NOT NULL,
    prescription_name VARCHAR(100) DEFAULT NULL,
    op_type VARCHAR(100) NOT NULL,                   -- Consultation / Treatment / Control
    op_date DATE NOT NULL,
    surgery VARCHAR(5) NOT NULL DEFAULT 'NO',        -- if surgery needed, fill in  'YES'
    status VARCHAR(15) NOT NULL DEFAULT 'PLANNED',   -- PLANNED / DONE / CANCELLED
    CONSTRAINT fk_op_doc FOREIGN KEY (doc_id) REFERENCES doctors(doc_id),
    CONSTRAINT fk_op_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT chk_op_type CHECK (op_type IN ('Consultation','Treatment','Control')),
    CONSTRAINT chk_op_surgery CHECK (surgery IN ('YES','NO')),
    CONSTRAINT chk_op_status CHECK (status IN ('PLANNED','DONE','CANCELLED'))
);

DROP TABLE IF EXISTS surgeries;
CREATE TABLE surgeries(
    op_id INT PRIMARY KEY,
    dept_id INT NOT NULL DEFAULT 0,        -- auto-fills via triggers
    surgery_room VARCHAR(50) NOT NULL,
    doc_id INT NOT NULL DEFAULT 0,         -- auto-fills via triggers
    works_with INT DEFAULT NULL,           -- the other doctor's id in the operation
    patient_id INT NOT NULL DEFAULT 0,     -- auto-fills via triggers
    surgery_date DATE NOT NULL,
    surgery_start TIME NOT NULL,
    surgery_end TIME NOT NULL,
    CONSTRAINT fk_surg_op FOREIGN KEY (op_id) REFERENCES operations(op_id),
    CONSTRAINT fk_surg_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id),
    CONSTRAINT fk_surg_assist FOREIGN KEY (works_with) REFERENCES doctors(doc_id) ON DELETE SET NULL,
    CONSTRAINT fk_surg_doc FOREIGN KEY (doc_id) REFERENCES doctors(doc_id),
    CONSTRAINT fk_surg_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT chk_surg_time CHECK (surgery_end > surgery_start)
);

DROP TABLE IF EXISTS revenues;
CREATE TABLE revenues(
    rev_id INT PRIMARY KEY AUTO_INCREMENT,
    op_id INT NOT NULL UNIQUE,             
    revenue_surgery INT NOT NULL,
    CONSTRAINT fk_rev_op FOREIGN KEY (op_id) REFERENCES operations(op_id),
    CONSTRAINT chk_rev_amount CHECK (revenue_surgery >= 0)
);

DROP TABLE IF EXISTS expenses;
CREATE TABLE expenses(
    exp_id INT AUTO_INCREMENT PRIMARY KEY,
    exp_date DATE NOT NULL,
    exp_description VARCHAR(250) DEFAULT NULL,
    exp_medical INT DEFAULT NULL,
    exp_electricity INT DEFAULT NULL,
    exp_water INT DEFAULT NULL,
    exp_cleaning INT DEFAULT NULL,
    exp_catering INT DEFAULT NULL,
    exp_heating INT DEFAULT NULL,
    exp_fuel INT DEFAULT NULL,
    exp_taxes INT DEFAULT NULL,
    exp_stationery INT DEFAULT NULL,
    CONSTRAINT chk_exp_nonneg CHECK (exp_medical >= 0 AND exp_electricity >= 0 AND exp_water >= 0 AND exp_cleaning >= 0 AND exp_catering >= 0 AND exp_heating >= 0
        AND exp_fuel >= 0 AND exp_taxes >= 0 AND exp_stationery >= 0),
    CONSTRAINT chk_exp_any CHECK (
        exp_medical IS NOT NULL OR exp_electricity IS NOT NULL OR exp_water IS NOT NULL OR
        exp_cleaning IS NOT NULL OR exp_catering IS NOT NULL OR exp_heating IS NOT NULL OR
        exp_fuel IS NOT NULL OR exp_taxes IS NOT NULL OR exp_stationery IS NOT NULL)
);

DROP TABLE IF EXISTS emergency;
CREATE TABLE emergency(
    emerg_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT DEFAULT NULL,               -- if the patient is not signed up before, sets NULL
    patient_fname VARCHAR(50) DEFAULT NULL,
    patient_lname VARCHAR(50) DEFAULT NULL,
    patient_SSN VARCHAR(20) DEFAULT NULL,      -- FIRST question to ask if necessary!
    doc_id INT DEFAULT NULL,
    works_with INT DEFAULT NULL,
    nurse_id INT DEFAULT NULL,
    emerg_date DATE NOT NULL,
    diagnosis VARCHAR(250) DEFAULT NULL,
    intensive_care VARCHAR(15) DEFAULT NULL,   -- YES / NO
    discharge_status VARCHAR(50) DEFAULT NULL,
    CONSTRAINT fk_em_patient FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    CONSTRAINT fk_em_doc FOREIGN KEY (doc_id) REFERENCES doctors(doc_id) ON DELETE SET NULL,
    CONSTRAINT fk_em_assist FOREIGN KEY (works_with) REFERENCES doctors(doc_id) ON DELETE SET NULL,
    CONSTRAINT fk_em_nurse FOREIGN KEY (nurse_id) REFERENCES nurses(nurse_id) ON DELETE SET NULL,
    CONSTRAINT chk_em_icu CHECK (intensive_care IS NULL OR intensive_care IN ('YES','NO'))
) AUTO_INCREMENT=1;

DROP TABLE IF EXISTS off_days;
CREATE TABLE off_days(
    order_ INT AUTO_INCREMENT PRIMARY KEY,
    off_day_date_start DATE NOT NULL,
    off_day_date_end DATE NOT NULL,
    leave_type VARCHAR(50) NOT NULL,                 -- Annual, Sick, Excuse, Unpaid, Other
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',   -- Pending, Approved, Rejected
    reason VARCHAR(255) DEFAULT NULL,
    doc_id INT DEFAULT NULL,
    nurse_id INT DEFAULT NULL,
    pers_id INT DEFAULT NULL,
    manager_id INT DEFAULT NULL,
    approved_by_manager_id INT DEFAULT NULL,
    CONSTRAINT fk_off_doc FOREIGN KEY (doc_id) REFERENCES doctors(doc_id) ON DELETE SET NULL,
    CONSTRAINT fk_off_pers FOREIGN KEY (pers_id) REFERENCES personnels(pers_id) ON DELETE SET NULL,
    CONSTRAINT fk_off_nurse FOREIGN KEY (nurse_id) REFERENCES nurses(nurse_id) ON DELETE SET NULL,
    CONSTRAINT fk_off_mgr FOREIGN KEY (manager_id) REFERENCES management(manager_id) ON DELETE SET NULL,
    CONSTRAINT fk_off_appr FOREIGN KEY (approved_by_manager_id) REFERENCES management(manager_id) ON DELETE SET NULL,
    CONSTRAINT chk_off_type CHECK (leave_type IN ('Annual','Sick','Excuse','Unpaid','Other')),
    CONSTRAINT chk_off_status CHECK (status IN ('Pending','Approved','Rejected')),
    CONSTRAINT chk_off_dates CHECK (off_day_date_start <= off_day_date_end)
);

-- Population Counters
DROP TABLE IF EXISTS personnels_count;
CREATE TABLE personnels_count (total_personnels INT NOT NULL DEFAULT 0);
INSERT INTO personnels_count VALUES (0);

DROP TABLE IF EXISTS patients_count;
CREATE TABLE patients_count (total_patients INT NOT NULL DEFAULT 0);
INSERT INTO patients_count VALUES (0);

DROP TABLE IF EXISTS nurses_count;
CREATE TABLE nurses_count (total_nurses INT NOT NULL DEFAULT 0);
INSERT INTO nurses_count VALUES (0);

DROP TABLE IF EXISTS doctors_count;
CREATE TABLE doctors_count (total_doctors INT NOT NULL DEFAULT 0);
INSERT INTO doctors_count VALUES (0);

DROP TABLE IF EXISTS mgr_count;
CREATE TABLE mgr_count (total_mgr INT NOT NULL DEFAULT 0);
INSERT INTO mgr_count VALUES (0);


-- ---------------------------------------------------------------------
--  TRIGGERS
-- ---------------------------------------------------------------------
DELIMITER $$

-- ===================== COUNTERS=====================
-- Counts the only 'active' members (where leave_date IS NULL)

CREATE TRIGGER doctors_counter AFTER INSERT ON doctors FOR EACH ROW
BEGIN
    IF NEW.doc_leave_date IS NULL THEN
        UPDATE doctors_count SET total_doctors = total_doctors + 1;
    END IF;
END $$

CREATE TRIGGER nurses_counter AFTER INSERT ON nurses FOR EACH ROW
BEGIN
    IF NEW.nurse_leave_date IS NULL THEN
        UPDATE nurses_count SET total_nurses = total_nurses + 1;
    END IF;
END $$

CREATE TRIGGER mgr_counter AFTER INSERT ON management FOR EACH ROW
BEGIN
    IF NEW.manager_leave_date IS NULL THEN
        UPDATE mgr_count SET total_mgr = total_mgr + 1;
    END IF;
END $$

CREATE TRIGGER personnels_counter AFTER INSERT ON personnels FOR EACH ROW
BEGIN
    IF NEW.pers_leave_date IS NULL THEN
        UPDATE personnels_count SET total_personnels = total_personnels + 1;
    END IF;
END $$

CREATE TRIGGER patients_counter AFTER INSERT ON patients FOR EACH ROW
    UPDATE patients_count SET total_patients = total_patients + 1 $$

-- =========== Already deleted person must not affect the total number!===========

CREATE TRIGGER patients_counter_deleter AFTER DELETE ON patients FOR EACH ROW
    UPDATE patients_count SET total_patients = total_patients - 1 $$

CREATE TRIGGER doctors_counter_delete AFTER DELETE ON doctors FOR EACH ROW
BEGIN
    IF OLD.doc_leave_date IS NULL THEN
        UPDATE doctors_count SET total_doctors = total_doctors - 1;
    END IF;
END $$

CREATE TRIGGER nurses_counter_delete AFTER DELETE ON nurses FOR EACH ROW
BEGIN
    IF OLD.nurse_leave_date IS NULL THEN
        UPDATE nurses_count SET total_nurses = total_nurses - 1;
    END IF;
END $$

CREATE TRIGGER mgr_counter_delete AFTER DELETE ON management FOR EACH ROW
BEGIN
    IF OLD.manager_leave_date IS NULL THEN
        UPDATE mgr_count SET total_mgr = total_mgr - 1;
    END IF;
END $$

CREATE TRIGGER personnels_counter_delete AFTER DELETE ON personnels FOR EACH ROW
BEGIN
    IF OLD.pers_leave_date IS NULL THEN
        UPDATE personnels_count SET total_personnels = total_personnels - 1;
    END IF;
END $$

-- =========== More update triggers ===========

CREATE TRIGGER doctors_status_check AFTER UPDATE ON doctors FOR EACH ROW
BEGIN
    IF OLD.doc_leave_date IS NULL AND NEW.doc_leave_date IS NOT NULL THEN
        UPDATE doctors_count SET total_doctors = total_doctors - 1;
    ELSEIF OLD.doc_leave_date IS NOT NULL AND NEW.doc_leave_date IS NULL THEN
        UPDATE doctors_count SET total_doctors = total_doctors + 1;
    END IF;
END $$

CREATE TRIGGER nurses_status_check AFTER UPDATE ON nurses FOR EACH ROW
BEGIN
    IF OLD.nurse_leave_date IS NULL AND NEW.nurse_leave_date IS NOT NULL THEN
        UPDATE nurses_count SET total_nurses = total_nurses - 1;
    ELSEIF OLD.nurse_leave_date IS NOT NULL AND NEW.nurse_leave_date IS NULL THEN
        UPDATE nurses_count SET total_nurses = total_nurses + 1;
    END IF;
END $$

CREATE TRIGGER mgr_status_check AFTER UPDATE ON management FOR EACH ROW
BEGIN
    IF OLD.manager_leave_date IS NULL AND NEW.manager_leave_date IS NOT NULL THEN
        UPDATE mgr_count SET total_mgr = total_mgr - 1;
    ELSEIF OLD.manager_leave_date IS NOT NULL AND NEW.manager_leave_date IS NULL THEN
        UPDATE mgr_count SET total_mgr = total_mgr + 1;
    END IF;
END $$

CREATE TRIGGER personnels_status_check AFTER UPDATE ON personnels FOR EACH ROW
BEGIN
    IF OLD.pers_leave_date IS NULL AND NEW.pers_leave_date IS NOT NULL THEN
        UPDATE personnels_count SET total_personnels = total_personnels - 1;
    ELSEIF OLD.pers_leave_date IS NOT NULL AND NEW.pers_leave_date IS NULL THEN
        UPDATE personnels_count SET total_personnels = total_personnels + 1;
    END IF;
END $$


-- ===================== DOCTORS / NURSES =====================

-- if the leave_date is NOT NULL, then that person must NOT work anymore. Let's see if there's any unassigned operations, surgeries etc.
CREATE TRIGGER doctors_before_update BEFORE UPDATE ON doctors FOR EACH ROW
BEGIN
    IF NEW.doc_leave_date IS NOT NULL AND OLD.doc_leave_date IS NULL THEN
        IF EXISTS (SELECT 1 FROM operations WHERE doc_id = NEW.doc_id AND status = 'PLANNED' AND op_date > NEW.doc_leave_date) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor has planned operations after the leave date. Reassign them first!';
        END IF;
        IF EXISTS (SELECT 1 FROM surgeries s JOIN operations o ON o.op_id = s.op_id
            WHERE (s.doc_id = NEW.doc_id OR s.works_with = NEW.doc_id) AND o.status = 'PLANNED' AND s.surgery_date > NEW.doc_leave_date) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor has planned surgeries after the leave date. Reassign them first!';
        END IF;
    END IF;
END $$


CREATE TRIGGER doctor_resign_nurses AFTER UPDATE ON doctors FOR EACH ROW
BEGIN
    IF OLD.doc_leave_date IS NULL AND NEW.doc_leave_date IS NOT NULL THEN
        UPDATE nurses SET nurse_works_with = NULL WHERE nurse_works_with = NEW.doc_id;
    END IF;
END $$

CREATE TRIGGER nurses_before_insert BEFORE INSERT ON nurses FOR EACH ROW
BEGIN
    IF NEW.nurse_leave_date IS NOT NULL THEN
        SET NEW.nurse_works_with = NULL;
    ELSEIF NEW.nurse_works_with IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM doctors
            WHERE doc_id = NEW.nurse_works_with AND doc_hire_date <= CURDATE() AND (doc_leave_date IS NULL OR doc_leave_date >= CURDATE())) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor does not exist or has already left!';
        END IF;
    END IF;
END $$

CREATE TRIGGER nurses_before_update BEFORE UPDATE ON nurses FOR EACH ROW
BEGIN
    IF NEW.nurse_leave_date IS NOT NULL THEN
        SET NEW.nurse_works_with = NULL;
    ELSEIF NEW.nurse_works_with IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM doctors
            WHERE doc_id = NEW.nurse_works_with AND doc_hire_date <= CURDATE() AND (doc_leave_date IS NULL OR doc_leave_date >= CURDATE())) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor does not exist or has already left!';
        END IF;
    END IF;
END $$

-- ===================== OPERATIONS =====================

CREATE TRIGGER operations_before_insert BEFORE INSERT ON operations FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM doctors
        WHERE doc_id = NEW.doc_id AND doc_hire_date <= NEW.op_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.op_date)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor does not exist or was not working on the operation date!';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM patients
        WHERE patient_id = NEW.patient_id AND patient_bdate <= NEW.op_date) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The patient does not exist or was not born yet on the operation date!';
    END IF;

    IF NEW.status = 'DONE' AND NEW.op_date > CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A future operation cannot be DONE!';
    END IF;

    IF NEW.status <> 'CANCELLED' THEN
        IF EXISTS (SELECT 1 FROM off_days
            WHERE doc_id = NEW.doc_id AND status = 'Approved' AND NEW.op_date BETWEEN off_day_date_start AND off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor is on approved leave on the operation date!';
        END IF;
    END IF;
END $$

CREATE TRIGGER operations_before_update BEFORE UPDATE ON operations FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM surgeries WHERE op_id = OLD.op_id) THEN
        IF NEW.surgery <> 'YES' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A surgery record exists for this operation, surgery must stay YES!';
        END IF;
        IF NEW.status = 'CANCELLED' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Delete the surgery record before cancelling the operation!';
        END IF;
        IF NEW.doc_id <> OLD.doc_id OR NEW.patient_id <> OLD.patient_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Doctor/patient cannot be changed while a surgery record exists!';
        END IF;
    END IF;

    
    IF EXISTS (SELECT 1 FROM revenues WHERE op_id = OLD.op_id) THEN
        IF NEW.status <> 'DONE' OR NEW.surgery <> 'YES' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A revenue record exists, operation must stay DONE and surgery YES!';
        END IF;
    END IF;

    
    IF NEW.doc_id <> OLD.doc_id OR NEW.patient_id <> OLD.patient_id OR NEW.op_date <> OLD.op_date OR NEW.status <> OLD.status THEN

        IF NOT EXISTS (SELECT 1 FROM doctors
            WHERE doc_id = NEW.doc_id AND doc_hire_date <= NEW.op_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.op_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor does not exist or was not working on the operation date!';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM patients
            WHERE patient_id = NEW.patient_id AND patient_bdate <= NEW.op_date) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The patient does not exist or was not born yet on the operation date!';
        END IF;

        IF NEW.status = 'DONE' AND NEW.op_date > CURDATE() THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A future operation cannot be DONE!';
        END IF;

        IF NEW.status <> 'CANCELLED' THEN
            IF EXISTS (SELECT 1 FROM off_days
                WHERE doc_id = NEW.doc_id AND status = 'Approved' AND NEW.op_date BETWEEN off_day_date_start AND off_day_date_end) THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor is on approved leave on the operation date!';
            END IF;
        END IF;
    END IF;
END $$


-- ===================== SURGERIES =====================
-- auto fills the spaces

CREATE TRIGGER surgeries_before_insert BEFORE INSERT ON surgeries FOR EACH ROW
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_doc INT;
    DECLARE v_pat INT;
    DECLARE v_dept INT;
    DECLARE v_surgery VARCHAR(5);
    DECLARE v_status VARCHAR(15);
    DECLARE v_op_date DATE;

    SELECT COUNT(*) INTO v_cnt FROM operations WHERE op_id = NEW.op_id;
    IF v_cnt = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The operation does not exist!';
    END IF;

    SELECT doc_id, patient_id, surgery, status, op_date INTO v_doc, v_pat, v_surgery, v_status, v_op_date FROM operations WHERE op_id = NEW.op_id;

    IF v_surgery <> 'YES' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Patient does not need a surgery due to operations.surgery';
    END IF;
    IF v_status = 'CANCELLED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The operation is cancelled!';
    END IF;
    IF NEW.surgery_date < v_op_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Surgery date cannot be before the operation date!';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM doctors
        WHERE doc_id = v_doc AND doc_hire_date <= NEW.surgery_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.surgery_date)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The surgeon was not working on the surgery date!';
    END IF;
    IF EXISTS (SELECT 1 FROM off_days
        WHERE doc_id = v_doc AND status = 'Approved' AND NEW.surgery_date BETWEEN off_day_date_start AND off_day_date_end) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The surgeon is on approved leave on the surgery date!';
    END IF;

    IF NEW.works_with IS NOT NULL THEN
        IF NEW.works_with = v_doc THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant cannot be the surgeon!';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM doctors WHERE doc_id = NEW.works_with AND doc_hire_date <= NEW.surgery_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.surgery_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant does not exist or was not working on the surgery date!';
        END IF;

        IF EXISTS (SELECT 1 FROM off_days 
            WHERE doc_id = NEW.works_with AND status = 'Approved' AND NEW.surgery_date BETWEEN off_day_date_start AND off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant is on approved leave on the surgery date!';
        END IF;
    END IF;

    
    SELECT doc_dept_id INTO v_dept FROM doctors WHERE doc_id = v_doc;

    IF EXISTS (SELECT 1 FROM surgeries 
        WHERE op_id <> NEW.op_id 
        AND surgery_date = NEW.surgery_date
        AND surgery_start < NEW.surgery_end 
        AND NEW.surgery_start < surgery_end
        AND surgery_room = NEW.surgery_room) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The surgery room is already booked in this time range!';
    END IF;

    IF EXISTS (SELECT 1 FROM surgeries 
        WHERE op_id <> NEW.op_id 
        AND surgery_date = NEW.surgery_date
        AND surgery_start < NEW.surgery_end AND NEW.surgery_start < surgery_end
        AND (doc_id = v_doc  OR works_with = v_doc OR (NEW.works_with IS NOT NULL  AND (doc_id = NEW.works_with OR works_with = NEW.works_with)))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A doctor is already in another surgery in this time range!';
    END IF;

    IF EXISTS (SELECT 1 FROM surgeries 
        WHERE op_id <> NEW.op_id 
        AND surgery_date = NEW.surgery_date
        AND surgery_start < NEW.surgery_end AND NEW.surgery_start < surgery_end
        AND patient_id = v_pat) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The patient already has a surgery in this time range!';
    END IF;

    SET NEW.doc_id = v_doc;
    SET NEW.patient_id = v_pat;
    SET NEW.dept_id = v_dept;
END $$

CREATE TRIGGER surgeries_before_update BEFORE UPDATE ON surgeries FOR EACH ROW
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_doc INT;
    DECLARE v_pat INT;
    DECLARE v_dept INT;
    DECLARE v_surgery VARCHAR(5);
    DECLARE v_status VARCHAR(15);
    DECLARE v_op_date DATE;

    IF NEW.op_id <> OLD.op_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! op_id of a surgery cannot be changed!';
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM operations WHERE op_id = NEW.op_id;
    IF v_cnt = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The operation does not exist!';
    END IF;

    SELECT doc_id, patient_id, surgery, status, op_date INTO v_doc, v_pat, v_surgery, v_status, v_op_date FROM operations WHERE op_id = NEW.op_id;

    IF v_surgery <> 'YES' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Patient does not need a surgery due to operations.surgery';
    END IF;

    IF v_status = 'CANCELLED' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The operation is cancelled!';
    END IF;

    IF NEW.surgery_date < v_op_date THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Surgery date cannot be before the operation date!';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM doctors
        WHERE doc_id = v_doc AND doc_hire_date <= NEW.surgery_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.surgery_date)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The surgeon was not working on the surgery date!';
    END IF;

    IF EXISTS (SELECT 1 FROM off_days
        WHERE doc_id = v_doc AND status = 'Approved' AND NEW.surgery_date BETWEEN off_day_date_start AND off_day_date_end) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The surgeon is on approved leave on the surgery date!';
    END IF;

    IF NEW.works_with IS NOT NULL THEN
        IF NEW.works_with = v_doc THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant cannot be the surgeon!';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM doctors
            WHERE doc_id = NEW.works_with AND doc_hire_date <= NEW.surgery_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.surgery_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant does not exist or was not working on the surgery date!';
        END IF;
        IF EXISTS (SELECT 1 FROM off_days
            WHERE doc_id = NEW.works_with AND status = 'Approved' AND NEW.surgery_date BETWEEN off_day_date_start AND off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant is on approved leave on the surgery date!';
        END IF;
    END IF;

    SELECT doc_dept_id INTO v_dept FROM doctors WHERE doc_id = v_doc;

    IF EXISTS (SELECT 1 FROM surgeries
        WHERE op_id <> NEW.op_id AND surgery_date = NEW.surgery_date AND surgery_start < NEW.surgery_end AND NEW.surgery_start < surgery_end AND surgery_room = NEW.surgery_room) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The surgery room is already booked in this time range!';
    END IF;

    IF EXISTS (SELECT 1 FROM surgeries
        WHERE op_id <> NEW.op_id AND surgery_date = NEW.surgery_date
        AND surgery_start < NEW.surgery_end AND NEW.surgery_start < surgery_end
        AND (doc_id = v_doc OR works_with = v_doc
        OR (NEW.works_with IS NOT NULL
        AND (doc_id = NEW.works_with OR works_with = NEW.works_with)))) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A doctor is already in another surgery in this time range!';
    END IF;

    IF EXISTS (SELECT 1 FROM surgeries
        WHERE op_id <> NEW.op_id AND surgery_date = NEW.surgery_date AND surgery_start < NEW.surgery_end AND NEW.surgery_start < surgery_end AND patient_id = v_pat) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The patient already has a surgery in this time range!';
    END IF;

    SET NEW.doc_id = v_doc;
    SET NEW.patient_id = v_pat;
    SET NEW.dept_id = v_dept;
END $$


CREATE TRIGGER surgeries_before_delete BEFORE DELETE ON surgeries FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM revenues WHERE op_id = OLD.op_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A revenue record exists for this surgery, it cannot be deleted!';
    END IF;
END $$


-- ===================== REVENUES =====================

CREATE TRIGGER revenue_control BEFORE INSERT ON revenues FOR EACH ROW
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_status VARCHAR(15);
    DECLARE v_surgery VARCHAR(5);

    SELECT COUNT(*) INTO v_cnt FROM operations WHERE op_id = NEW.op_id;
    IF v_cnt = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The operation does not exist!';
    END IF;

    SELECT status, surgery INTO v_status, v_surgery FROM operations WHERE op_id = NEW.op_id;

    IF v_status <> 'DONE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Revenue cannot be added because the operation status is not DONE';
    END IF;
    IF v_surgery <> 'YES' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Revenue cannot be added because the surgery status is not YES';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM surgeries WHERE op_id = NEW.op_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Revenue cannot be added because there is no surgery record for this operation';
    END IF;
END $$

CREATE TRIGGER revenue_control_update BEFORE UPDATE ON revenues FOR EACH ROW
BEGIN
    IF NEW.op_id <> OLD.op_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! op_id of a revenue cannot be changed!';
    END IF;
END $$


-- ===================== EMERGENCY =====================
CREATE TRIGGER auto_fill_emergency_patient BEFORE INSERT ON emergency FOR EACH ROW
BEGIN
    DECLARE v_id INT;

    IF NEW.patient_SSN IS NOT NULL THEN
        SET NEW.patient_SSN = REPLACE(REPLACE(TRIM(NEW.patient_SSN), '-', ''), ' ', '');
        IF NEW.patient_SSN NOT REGEXP '^[0-9]{7,11}$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Invalid SSN format!';
        END IF;

        SET v_id = (SELECT patient_id FROM patients WHERE patient_SSN = NEW.patient_SSN);
        IF v_id IS NOT NULL THEN
            IF NEW.patient_id IS NOT NULL AND NEW.patient_id <> v_id THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! patient_id does not match the given SSN!';
            END IF;
            SET NEW.patient_id = v_id;
        ELSEIF NEW.patient_id IS NOT NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! patient_id was given but this SSN is not a registered patient!';
        END IF;
    END IF;

    IF NEW.patient_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM patients WHERE patient_id = NEW.patient_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The patient does not exist!';
        END IF;
        SET NEW.patient_fname = (SELECT patient_fname FROM patients WHERE patient_id = NEW.patient_id);
        SET NEW.patient_lname = (SELECT patient_lname FROM patients WHERE patient_id = NEW.patient_id);
        SET NEW.patient_SSN = (SELECT patient_SSN FROM patients WHERE patient_id = NEW.patient_id);
    END IF;

    IF NEW.doc_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM doctors 
            WHERE doc_id = NEW.doc_id AND doc_hire_date <= NEW.emerg_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.emerg_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor does not exist or was not working on the emergency date!';
        END IF;
    END IF;
    IF NEW.works_with IS NOT NULL THEN
        IF NEW.doc_id IS NOT NULL AND NEW.works_with = NEW.doc_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant cannot be the same doctor!';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM doctors 
            WHERE doc_id = NEW.works_with AND doc_hire_date <= NEW.emerg_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.emerg_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant does not exist or was not working on the emergency date!';
        END IF;
    END IF;

    IF NEW.nurse_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM nurses 
            WHERE nurse_id = NEW.nurse_id AND nurse_hire_date <= NEW.emerg_date
            AND (nurse_leave_date IS NULL OR nurse_leave_date >= NEW.emerg_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The nurse does not exist or was not working on the emergency date!';
        END IF;
    END IF;
END $$

CREATE TRIGGER emergency_before_update BEFORE UPDATE ON emergency FOR EACH ROW
BEGIN

    DECLARE v_id INT;

    IF NEW.patient_SSN IS NOT NULL THEN
        SET NEW.patient_SSN = REPLACE(REPLACE(TRIM(NEW.patient_SSN), '-', ''), ' ', '');
        IF NEW.patient_SSN NOT REGEXP '^[0-9]{7,11}$' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Invalid SSN format!';
        END IF;

        SET v_id = (SELECT patient_id FROM patients WHERE patient_SSN = NEW.patient_SSN);
        IF v_id IS NOT NULL THEN
            IF NEW.patient_id IS NOT NULL AND NEW.patient_id <> v_id THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! patient_id does not match the given SSN!';
            END IF;
            SET NEW.patient_id = v_id;
        ELSEIF NEW.patient_id IS NOT NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! patient_id was given but this SSN is not a registered patient!';
        END IF;
    END IF;

    IF NEW.patient_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM patients WHERE patient_id = NEW.patient_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The patient does not exist!';
        END IF;

        SET NEW.patient_fname = (SELECT patient_fname FROM patients WHERE patient_id = NEW.patient_id);
        SET NEW.patient_lname = (SELECT patient_lname FROM patients WHERE patient_id = NEW.patient_id);
        SET NEW.patient_SSN = (SELECT patient_SSN FROM patients WHERE patient_id = NEW.patient_id);
    END IF;

    IF NEW.doc_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM doctors WHERE doc_id = NEW.doc_id AND doc_hire_date <= NEW.emerg_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.emerg_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor does not exist or was not working on the emergency date!';
        END IF;
    END IF;
    IF NEW.works_with IS NOT NULL THEN
        IF NEW.doc_id IS NOT NULL AND NEW.works_with = NEW.doc_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant cannot be the same doctor!';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM doctors WHERE doc_id = NEW.works_with AND doc_hire_date <= NEW.emerg_date AND (doc_leave_date IS NULL OR doc_leave_date >= NEW.emerg_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The assistant does not exist or was not working on the emergency date!';
        END IF;
    END IF;
    IF NEW.nurse_id IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM nurses WHERE nurse_id = NEW.nurse_id AND nurse_hire_date <= NEW.emerg_date AND (nurse_leave_date IS NULL OR nurse_leave_date >= NEW.emerg_date)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The nurse does not exist or was not working on the emergency date!';
        END IF;
    END IF;
END $$

CREATE TRIGGER off_days_leave_control BEFORE INSERT ON off_days FOR EACH ROW
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_hire DATE;
    DECLARE v_leave DATE;

    SET v_cnt = (NEW.doc_id IS NOT NULL) + (NEW.nurse_id IS NOT NULL) + (NEW.pers_id IS NOT NULL) + (NEW.manager_id IS NOT NULL);
    IF v_cnt <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Exactly one of doc_id, nurse_id, pers_id, manager_id must be set!';
    END IF;

    IF NEW.off_day_date_start > NEW.off_day_date_end THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Start day of an off day can not be greater than its end day!';
    END IF;

    IF NEW.doc_id IS NOT NULL THEN
        SELECT doc_hire_date, doc_leave_date INTO v_hire, v_leave FROM doctors WHERE doc_id = NEW.doc_id;

    ELSEIF NEW.nurse_id IS NOT NULL THEN
        SELECT nurse_hire_date, nurse_leave_date INTO v_hire, v_leave FROM nurses WHERE nurse_id = NEW.nurse_id;
    ELSEIF NEW.pers_id IS NOT NULL THEN
        SELECT pers_hire_date, pers_leave_date INTO v_hire, v_leave FROM personnels WHERE pers_id = NEW.pers_id;
    ELSE
        SELECT manager_hire_date, manager_leave_date INTO v_hire, v_leave FROM management WHERE manager_id = NEW.manager_id;
    END IF;

    IF NEW.off_day_date_start < v_hire OR (v_leave IS NOT NULL AND NEW.off_day_date_end > v_leave) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The person was not working during the given off day period!';
    END IF;

   
    IF NEW.status = 'Pending' AND NEW.approved_by_manager_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A Pending request cannot have an approver!';
    END IF;

    IF NEW.status IN ('Approved','Rejected') AND NEW.approved_by_manager_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Approved/Rejected requests need approved_by_manager_id!';
    END IF;

    IF NEW.approved_by_manager_id IS NOT NULL THEN
        IF NEW.manager_id IS NOT NULL AND NEW.approved_by_manager_id = NEW.manager_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A manager cannot approve their own off day!';
        END IF;
        IF NOT EXISTS (SELECT 1 FROM management WHERE manager_id = NEW.approved_by_manager_id
            AND manager_hire_date <= NEW.off_day_date_start
            AND (manager_leave_date IS NULL OR manager_leave_date >= NEW.off_day_date_start)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The approving manager was not working at that time!';
        END IF;
    END IF;

    
    IF NEW.status <> 'Rejected' THEN
        IF EXISTS (SELECT 1 FROM off_days WHERE status <> 'Rejected'
            AND ((NEW.doc_id IS NOT NULL AND doc_id = NEW.doc_id)

            OR (NEW.nurse_id IS NOT NULL AND nurse_id = NEW.nurse_id)
            OR (NEW.pers_id IS NOT NULL AND pers_id = NEW.pers_id)
            OR (NEW.manager_id IS NOT NULL AND manager_id = NEW.manager_id))

            AND off_day_date_start <= NEW.off_day_date_end
            AND NEW.off_day_date_start <= off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! This person already has an overlapping off day!';
        END IF;
    END IF;

   
    IF NEW.status = 'Approved' AND NEW.doc_id IS NOT NULL THEN
        IF EXISTS (SELECT 1 FROM operations WHERE doc_id = NEW.doc_id AND status = 'PLANNED' AND op_date BETWEEN NEW.off_day_date_start AND NEW.off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor has planned operations in this period!';
        END IF;
        IF EXISTS (SELECT 1 FROM surgeries s JOIN operations o ON o.op_id = s.op_id WHERE (s.doc_id = NEW.doc_id OR s.works_with = NEW.doc_id) AND o.status = 'PLANNED'
            AND s.surgery_date BETWEEN NEW.off_day_date_start AND NEW.off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor has planned surgeries in this period!';
        END IF;
    END IF;
END $$

CREATE TRIGGER off_days_leave_control_update BEFORE UPDATE ON off_days FOR EACH ROW
BEGIN
    DECLARE v_cnt INT DEFAULT 0;
    DECLARE v_hire DATE;
    DECLARE v_leave DATE;

    SET v_cnt = (NEW.doc_id IS NOT NULL) + (NEW.nurse_id IS NOT NULL) + (NEW.pers_id IS NOT NULL) + (NEW.manager_id IS NOT NULL);
    IF v_cnt <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Exactly one of doc_id, nurse_id, pers_id, manager_id must be set!';
    END IF;

    IF NEW.off_day_date_start > NEW.off_day_date_end THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Start day of an off day can not be greater than its end day!';
    END IF;

    IF NEW.doc_id IS NOT NULL THEN
        SELECT doc_hire_date, doc_leave_date INTO v_hire, v_leave FROM doctors WHERE doc_id = NEW.doc_id;
    ELSEIF NEW.nurse_id IS NOT NULL THEN
        SELECT nurse_hire_date, nurse_leave_date INTO v_hire, v_leave FROM nurses WHERE nurse_id = NEW.nurse_id;
    ELSEIF NEW.pers_id IS NOT NULL THEN
        SELECT pers_hire_date, pers_leave_date INTO v_hire, v_leave FROM personnels WHERE pers_id = NEW.pers_id;
    ELSE
        SELECT manager_hire_date, manager_leave_date INTO v_hire, v_leave FROM management WHERE manager_id = NEW.manager_id;
    END IF;
    IF NEW.off_day_date_start < v_hire OR (v_leave IS NOT NULL AND NEW.off_day_date_end > v_leave) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The person was not working during the given off day period!';
    END IF;

    IF NEW.status = 'Pending' AND NEW.approved_by_manager_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A Pending request cannot have an approver!';
    END IF;

    IF NEW.status IN ('Approved','Rejected') AND NEW.approved_by_manager_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! Approved/Rejected requests need approved_by_manager_id!';
    END IF;

    IF NEW.approved_by_manager_id IS NOT NULL THEN
        IF NEW.manager_id IS NOT NULL AND NEW.approved_by_manager_id = NEW.manager_id THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! A manager cannot approve their own off day!';
        END IF;

        IF NOT EXISTS (SELECT 1 FROM management WHERE manager_id = NEW.approved_by_manager_id AND manager_hire_date <= NEW.off_day_date_start 
            AND (manager_leave_date IS NULL OR manager_leave_date >= NEW.off_day_date_start)) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The approving manager was not working at that time!';
        END IF;
    END IF;

   
    IF NEW.status <> 'Rejected' THEN
        IF EXISTS (SELECT 1 FROM off_days WHERE order_ <> NEW.order_ AND status <> 'Rejected' 
            AND ((NEW.doc_id IS NOT NULL AND doc_id = NEW.doc_id)
            OR (NEW.nurse_id IS NOT NULL AND nurse_id = NEW.nurse_id)
            OR (NEW.pers_id IS NOT NULL AND pers_id = NEW.pers_id)
            OR (NEW.manager_id IS NOT NULL AND manager_id = NEW.manager_id))
            AND off_day_date_start <= NEW.off_day_date_end
            AND NEW.off_day_date_start <= off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! This person already has an overlapping off day!';
        END IF;
    END IF;

    IF NEW.status = 'Approved' AND NEW.doc_id IS NOT NULL THEN
        IF EXISTS (SELECT 1 FROM operations WHERE doc_id = NEW.doc_id AND status = 'PLANNED' AND op_date BETWEEN NEW.off_day_date_start AND NEW.off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor has planned operations in this period!';
        END IF;
        IF EXISTS (SELECT 1 FROM surgeries s JOIN operations o ON o.op_id = s.op_id WHERE (s.doc_id = NEW.doc_id OR s.works_with = NEW.doc_id) AND o.status = 'PLANNED'
            AND s.surgery_date BETWEEN NEW.off_day_date_start AND NEW.off_day_date_end) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error! The doctor has planned surgeries in this period!';
        END IF;
    END IF;
END $$

DELIMITER ;

-- ===================== INSERTING AREA =====================

INSERT INTO departments (dept_id, dept_name) VALUES
    (1, 'Cardiology'),
    (2, 'Neurology'),
    (3, 'Orthopedics'),
    (4, 'Dermatology'),
    (5, 'Psychiatry'),
    (6, 'Gastroenterology'),
    (7, 'ENT'),
    (8, 'Urology'),
    (9, 'Oncology'),
    (10, 'Pediatrics'),
    (11, 'Obstetrics & Gynecology'),
    (12, 'Physiotherapy');

INSERT INTO doctors (doc_fname, doc_lname, doc_SSN, doc_bdate, doc_pn, doc_sex, doc_salary, doc_hire_date, doc_leave_date, doc_dept_id) VALUES
    ('Mary', 'Lawson', '670238751', '1982-04-23', '58934586', 'F', 50000, '2010-10-23', NULL, 1),
    ('Lewis', 'Connor', '652627120', '1991-11-12', '58934522', 'M', 50000, '2017-04-02', NULL, 2),
    ('Freja', 'Lindström', '781293481', '1985-09-02', '58934991', 'F', 55000, '2015-04-06', NULL, 3),
    ('Helena', 'Langdon', '47967923', '1989-07-20', '239682', 'F', 60000, '2021-10-30', NULL, 4),
    ('Ivan', 'Vdovichenkov', '30167923', '1984-09-19', '969346702', 'M', 60000, '2007-05-13', NULL, 5),
    ('Maria', 'Stevens', '675634051', '1995-04-17', '1127934016', 'F', 60000, '2025-08-02', NULL, 1),
    ('Carlos', 'Mendez', '512340981', '1979-02-11', '5521098', 'M', 62000, '2005-09-01', NULL, 6),
    ('Aylin', 'Demir', '612098437', '1987-06-30', '5532001', 'F', 58000, '2014-03-15', NULL, 7),
    ('Oskar', 'Nilsson', '718230945', '1980-12-05', '5543772', 'M', 65000, '2008-01-10', NULL, 8),
    ('Priya', 'Sharma', '829104356', '1990-10-19', '5554310', 'F', 61000, '2018-06-20', NULL, 9),
    ('Tomas', 'Novak', '930215467', '1983-03-27', '5565421', 'M', 59000, '2011-11-14', NULL, 10),
    ('Sofia', 'Rossi', '134506789', '1992-08-08', '5576534', 'F', 57000, '2020-02-03', NULL, 11),
    ('Daniel', 'Kim', '245617890', '1986-01-22', '5587645', 'M', 56000, '2013-09-09', NULL, 12),
    ('Elena', 'Petrova', '356728901', '1978-05-14', '5598756', 'F', 70000, '2003-04-21', '2023-12-31', 1);

INSERT INTO nurses (nurse_fname, nurse_lname, nurse_works_with, nurse_SSN, nurse_bdate, nurse_pn, nurse_sex, nurse_salary, nurse_hire_date, nurse_leave_date) VALUES
    ('Gabrielle', 'Lacroix', NULL, '145338751', '1997-03-15', '580904586', 'F', 30000, '2019-08-02', NULL),
    ('Bruce', 'Jameson', 102, '273006751', '1992-08-12', '1003904776', 'M', 30000, '2013-08-11', NULL),
    ('Janice Mary', 'Hamilton', 104, '12847855', '1988-08-12', '58458026', 'F', 35000, '2008-01-21', NULL),
    ('Julia', 'Lloyd', 102, '12800835', '1990-02-09', '12458026', 'F', 40000, '2015-09-12', NULL),
    ('Charlotte', 'Anderson', NULL, '52847029', '2000-05-03', '58008026', 'F', 30000, '2025-12-24', NULL),
    ('George', 'Elliott', 103, '4592023', '1985-11-20', '4958920', 'M', 20000, '2009-06-23', '2016-11-11'),
    ('Christopher', 'Aksoy', 100, '441112223', '1993-04-02', '5611001', 'M', 32000, '2016-05-01', NULL),
    ('Hannah', 'Humphrey', 101, '552223334', '1995-09-17', '5622002', 'F', 31000, '2018-09-10', NULL),
    ('Naomi', 'Weber', 103, '663334445', '1991-07-07', '5633003', 'F', 36000, '2014-02-02', NULL),
    ('Liam', 'Connolly', 106, '774445556', '1989-11-30', '5644004', 'M', 38000, '2012-12-12', NULL),
    ('Aisha', 'Khan', 107, '885556667', '1996-01-25', '5655005', 'F', 33000, '2019-03-03', NULL),
    ('Noah', 'Fischer', 108, '996667778', '1994-06-06', '5666006', 'M', 34000, '2017-07-07', NULL),
    ('Isabela', 'Costa', 109, '117778889', '1997-12-12', '5677007', 'F', 32000, '2021-01-18', NULL),
    ('Leon', 'Brook', 110, '228889990', '1990-03-03', '5688008', 'M', 35000, '2015-10-05', NULL);

INSERT INTO management (manager_fname, manager_lname, manager_SSN, manager_bdate, manager_pn, manager_sex, manager_salary, manager_hire_date, manager_leave_date) VALUES
    ('Tilda', 'Skyes', '79280122', '1963-08-15', '20344020', 'F', 120000, '2010-03-24', NULL),
    ('Annie', 'Watts', '10283524', '1969-11-25', '99344210', 'F', 100000, '2022-05-05', NULL),
    ('Nicholas', 'Bailey', '10721594', '1970-01-05', '11347810', 'M', 95000, '2016-02-19', NULL),
    ('Harvey', 'Holden', '88200024', '1960-11-25', '3244217', 'M', 100000, '2003-10-02', '2026-04-16'),
    ('Brynn', 'Cranes', '10201529', '1952-09-13', '2144210', 'F', 150000, '2000-07-12', '2015-06-06'),
    ('Val', 'Herring', '8301529', '1948-04-20', '2178210', 'M', 80000, '1998-02-22', '2006-12-01'),
    ('Oliver', 'Parks', '10241538', '1973-03-31', '2148218', 'M', 150000, '2012-07-30', NULL);

INSERT INTO personnels (pers_fname, pers_lname, pers_SSN, pers_bdate, pers_pn, pers_sex, pers_salary, pers_cleaning, pers_security, pers_hire_date, pers_leave_date) VALUES
    ('Akira', 'Smith', '46457312', '1985-06-13', '43563613', 'M', 20000, NULL, 'Y', '2009-03-17', NULL),
    ('Anna Marcia', 'Lopez', '8900234', '1979-09-01', '89589230', 'F', 25000, 'Y', NULL, '2000-11-11', NULL),
    ('Luke', 'Borrows', '3428587', '1991-01-07', '94583872', 'M', 15000, NULL, 'Y', '2009-03-26', NULL),
    ('Stacy', 'Burke', '47233021', '1987-06-24', '8023501', 'F', 25000, NULL, 'Y', '2010-07-24', NULL),
    ('Ted', 'Michaels', '13784290', '1994-08-26', '98002343', 'M', 17000, 'Y', NULL, '2023-07-01', NULL),
    ('Rudy', 'Yilmaz', '56789012', '1982-05-05', '5700001', 'M', 21000, 'Y', NULL, '2011-05-05', NULL),
    ('Cameron', 'Wallace', '67890123', '1990-09-09', '5700002', 'F', 21000, 'Y', NULL, '2016-09-09', NULL),
    ('Oliver', 'Grant', '78901234', '1988-02-14', '5700003', 'M', 22000, NULL, 'Y', '2014-02-14', NULL),
    ('Jade', 'Palmer', '89012345', '1993-11-11', '5700004', 'F', 20000, 'Y', NULL, '2019-11-11', NULL),
    ('Jack', 'Turner', '90123456', '1985-07-07', '5700005', 'M', 23000, NULL, 'Y', '2010-07-07', '2022-03-01'),
    ('Rosa', 'Garcia', '12345678', '1996-04-04', '5700006', 'F', 20500, 'Y', NULL, '2020-04-04', NULL),
    ('Viktor', 'Horvat', '23456789', '1991-12-12', '5700007', 'M', 22500, NULL, 'Y', '2017-12-12', NULL);

INSERT INTO patients (patient_fname, patient_lname, patient_SSN, patient_bdate, patient_pn, patient_relative_pn, patient_sex) VALUES
    ('Mark', 'Thomson', '45676682', '1965-12-12', '54356400', NULL, 'M'),
    ('Dennis', 'Montgomery', '489375348', '2005-05-28', '839478325', '58725892', 'F'),
    ('Brianna', 'Di Loreto', '4734872', '2008-07-24', '6238421', NULL, 'F'),
    ('Davide', 'Di Loreto', '4734002', '1973-01-04', '6238421', NULL, 'M'),
    ('Marisa', 'Patel', '2834270', '1960-02-13', '83347100', '54356401', 'F'),
    ('Marco', 'Goode', '11000001', '1980-03-15', '5800001', NULL, 'M'),
    ('Zoe', 'Anders', '11000002', '1992-07-21', '5800002', '5800102', 'F'),
    ('Michael', 'Brown', '11000003', '1955-11-02', '5800003', NULL, 'M'),
    ('Emma', 'Wilson', '11000004', '2001-01-30', '5800004', '5800104', 'F'),
    ('Timothy', 'Ozturk', '11000005', '1948-09-09', '5800005', '5800105', 'M'),
    ('Laura', 'Martinez', '11000006', '1987-05-18', '5800006', NULL, 'F'),
    ('Can', 'Polat', '11000007', '2012-04-12', '5800007', '5800107', 'M'),
    ('Nina', 'Kowalski', '11000008', '1975-08-23', '5800008', NULL, 'F'),
    ('Peter', 'Schmidt', '11000009', '1969-02-28', '5800009', NULL, 'M'),
    ('Daphney', 'Garrett', '11000010', '1999-10-10', '5800010', '5800110', 'F'),
    ('Robert', 'Taylor', '11000011', '1958-06-06', '5800011', NULL, 'M'),
    ('Lucy', 'Woodman', '11000012', '1983-12-01', '5800012', '5800112', 'F'),
    ('Olivia', 'Johnson', '11000013', '2015-03-03', '5800013', '5800113', 'F'),
    ('Matthew', 'Wells', '11000014', '1971-01-17', '5800014', NULL, 'M'),
    ('Chloe', 'Dubois', '11000015', '1994-09-29', '5800015', NULL, 'F');

INSERT INTO operations (doc_id, patient_id, prescription_name, op_type, op_date, surgery, status) VALUES
    (100, 104, 'Aspirin 100mg', 'Consultation', '2024-09-27', 'NO', 'DONE'),
    (101, 100, 'Ibuprofen 400mg', 'Consultation', '2025-01-15', 'NO', 'DONE'),
    (102, 107, 'Physiotherapy plan', 'Treatment', '2025-03-10', 'NO', 'DONE'),
    (103, 106, 'Hydrocortisone cream', 'Treatment', '2025-06-02', 'NO', 'DONE'),
    (104, 112, 'Sertraline 50mg', 'Consultation', '2025-07-21', 'NO', 'DONE'),
    (100, 109, 'Bypass surgery', 'Treatment', '2025-09-12', 'YES', 'DONE'),
    (102, 115, 'Knee replacement', 'Treatment', '2025-10-08', 'YES', 'DONE'),
    (106, 113, 'Appendectomy', 'Treatment', '2025-11-19', 'YES', 'DONE'),
    (108, 114, 'Kidney stone removal', 'Treatment', '2026-01-14', 'YES', 'DONE'),
    (101, 116, 'Craniotomy', 'Treatment', '2026-02-25', 'YES', 'DONE'),
    (111, 108, 'Cesarean section', 'Treatment', '2026-04-09', 'YES', 'DONE'),
    (105, 100, 'Angioplasty', 'Treatment', '2026-09-15', 'YES', 'DONE'),
    (110, 111, 'Pediatric checkup', 'Control', '2026-05-05', 'NO', 'DONE'),
    (110, 117, 'Vaccination', 'Control', '2026-06-18', 'NO', 'DONE'),
    (109, 110, 'Chemo cycle 1', 'Treatment', '2026-08-03', 'NO', 'DONE'),
    (107, 105, 'Tonsillectomy', 'Treatment', '2026-12-10', 'YES', 'PLANNED'),
    (100, 118, 'Cardiac checkup', 'Control', '2026-11-20', 'NO', 'PLANNED'),
    (106, 102, 'Gastroscopy', 'Consultation', '2026-11-25', 'NO', 'PLANNED'),
    (102, 101, 'Fracture follow-up', 'Control', '2026-12-02', 'NO', 'CANCELLED'),
    (108, 119, 'Antibiotic course', 'Treatment', '2026-12-15', 'NO', 'PLANNED'),
    (107,100,'Tonsillectomy','Treatment', '2026-02-10', 'YES', 'PLANNED');

INSERT INTO surgeries (op_id, surgery_room, works_with, surgery_date, surgery_start, surgery_end) VALUES
    (6, 'OR-1', 105, '2025-09-12', '08:00', '12:00'),
    (7, 'OR-2', 112, '2025-10-08', '09:00', '12:30'),
    (8, 'OR-1', 100, '2025-11-19', '10:00', '11:30'),
    (9, 'OR-3', 107, '2026-01-14', '13:00', '15:00'),
    (10, 'OR-2', 102, '2026-02-25', '07:30', '14:00'),
    (11, 'OR-1', 110, '2026-04-09', '11:00', '12:30'),
    (12, 'OR-1', 100, '2026-09-15', '08:00', '10:00'),
    (16, 'OR-3', 106, '2026-12-10', '09:00', '11:00'),
    (21,'OR-4',102,'2026-11-01','13:00','15:00');

INSERT INTO revenues (op_id, revenue_surgery) VALUES
    (6, 25000),
    (7, 18000),
    (8, 6500),
    (9, 9000),
    (10, 40000),
    (11, 12000),
    (12, 15000);

INSERT INTO expenses (exp_date, exp_description, exp_medical, exp_electricity, exp_water, exp_cleaning, exp_catering, exp_heating, exp_fuel, exp_taxes, exp_stationery) VALUES
    ('2026-01-31', 'January', 5200, 1500, 320, 850, 950, 1100, 200, 1000, 140),
    ('2026-02-28', 'February', 4900, 1450, 310, 840, 930, 1050, 180, 1000, 120),
    ('2026-03-31', 'March', 5600, 1300, 330, 860, 960, 800, 200, 1000, 160),
    ('2026-04-30', 'April', 5100, 1100, 340, 870, 970, 400, 220, 1000, 130),
    ('2026-05-31', 'May', 5300, 1000, 360, 880, 980, 150, 210, 1000, 150),
    ('2026-06-30', 'June', 5800, 1200, 400, 900, 990, 0, 230, 1000, 170),
    ('2026-07-31', 'July', 6100, 1600, 450, 910, 1000, 0, 240, 1000, 110),
    ('2026-08-31', 'August', 5900, 1650, 460, 905, 995, 0, 235, 1000, 125),
    ('2026-09-30', 'September', 5400, 1250, 380, 890, 985, 300, 225, 1000, 145),
    ('2026-10-31', 'October', 5000, 1200, 300, 800, 900, 400, 0, 1000, 150);

INSERT INTO emergency (patient_id, patient_fname, patient_lname, patient_SSN, doc_id, works_with, nurse_id, emerg_date, diagnosis, intensive_care, discharge_status) VALUES
    (NULL, NULL, NULL, '45676682', 100, NULL, 100, '2026-01-05', 'Chest pain', 'NO', 'Discharged'),
    (NULL, NULL, NULL, '489375348', 102, 100, 101, '2026-02-14', 'Broken wrist', 'NO', 'Discharged'),
    (NULL, 'John', 'Doe', NULL, 104, NULL, 102, '2026-03-02', 'Unknown trauma (unidentified patient)', 'YES', 'Transferred to ICU'),
    (107, NULL, NULL, NULL, 100, 105, 103, '2026-04-18', 'Heart attack', 'YES', 'Admitted'),
    (NULL, NULL, NULL, '11000006', 103, NULL, 108, '2026-05-22', 'Severe allergic rash', 'NO', 'Discharged'),
    (NULL, 'Maria', 'Santos', '99887766', 106, NULL, 109, '2026-06-30', 'Food poisoning', 'NO', 'Discharged'),
    (NULL, NULL, NULL, '11000007', 110, NULL, 110, '2026-07-12', 'High fever', 'NO', 'Discharged'),
    (NULL, NULL, NULL, '2834270', 101, 103, 100, '2026-08-08', 'Stroke symptoms', 'YES', 'Admitted'),
    (118, NULL, NULL, NULL, 108, NULL, 111, '2026-09-03', 'Kidney colic', 'NO', 'Discharged'),
    (NULL, NULL, NULL, '11000013', 110, 111, 112, '2026-09-27', 'Asthma attack', 'NO', 'Discharged'),
    (NULL, 'Unknown', 'Male', NULL, 105, 100, 104, '2026-10-02', 'Car accident', 'YES', 'Transferred to ICU'),
    (NULL, NULL, NULL, '11000003', 100, NULL, 106, '2026-10-20', 'Palpitations', 'NO', 'Discharged'),
    (NULL, NULL, NULL, '1100-0002', 107, NULL, 107, '2026-10-25', 'Ear infection', 'NO', 'Discharged');

INSERT INTO off_days (off_day_date_start, off_day_date_end, leave_type, status, reason, doc_id, nurse_id, pers_id, manager_id, approved_by_manager_id) VALUES
    ('2025-07-01', '2025-07-14', 'Annual', 'Approved', 'Summer holiday', 100, NULL, NULL, NULL, 100),
    ('2025-12-24', '2025-12-31', 'Annual', 'Approved', 'Christmas', NULL, 101, NULL, NULL, 101),
    ('2026-02-02', '2026-02-06', 'Sick', 'Approved', 'Flu', 103, NULL, NULL, NULL, 102),
    ('2026-03-16', '2026-03-20', 'Excuse', 'Approved', 'Family matter', NULL, NULL, 100, NULL, 100),
    ('2026-05-04', '2026-05-15', 'Annual', 'Approved', 'Vacation', 104, NULL, NULL, NULL, 106),
    ('2026-06-08', '2026-06-12', 'Sick', 'Approved', 'Surgery recovery', NULL, 104, NULL, NULL, 100),
    ('2026-07-20', '2026-07-31', 'Annual', 'Approved', 'Summer break', 101, NULL, NULL, NULL, 102),
    ('2026-08-17', '2026-08-21', 'Unpaid', 'Approved', 'Personal', NULL, NULL, 102, NULL, 101),
    ('2026-09-07', '2026-09-11', 'Annual', 'Rejected', 'Busy season', 100, NULL, NULL, NULL, 106),
    ('2026-10-12', '2026-10-16', 'Sick', 'Approved', 'Back pain', NULL, NULL, NULL, 101, 100),
    ('2026-11-09', '2026-11-13', 'Annual', 'Pending', 'Autumn trip', NULL, 107, NULL, NULL, NULL),
    ('2026-12-21', '2026-12-31', 'Annual', 'Pending', 'Year-end holiday', 102, NULL, NULL, NULL, NULL),
    ('2026-12-14', '2026-12-18', 'Annual', 'Approved', 'Conference', 109, NULL, NULL, NULL, 106),
    ('2026-11-23', '2026-11-27', 'Annual', 'Approved', 'Short break', 110, NULL, NULL, NULL, 100),
    ('2026-12-07', '2026-12-09', 'Excuse', 'Approved', 'Exam', NULL, NULL, 105, NULL, 106),
    ('2026-11-16', '2026-11-18', 'Sick', 'Approved', 'Cold', NULL, NULL, 106, NULL, 101);

-- ---------------------------------------------------  UPDATE SPACE ---------------------------------------------
UPDATE doctors SET doc_leave_date = '2026-10-10' WHERE doc_id = 105;
-- --------------------------------------------------  SELECT SPACE ----------------------------------------------
SELECT * FROM doctors;
SELECT * FROM nurses;
SELECT * FROM management;
SELECT * FROM personnels;
SELECT * FROM patients;
SELECT * FROM departments;

SELECT * FROM operations;
SELECT * FROM surgeries;
SELECT * FROM revenues;
SELECT * FROM expenses;
SELECT * FROM emergency;
SELECT * FROM off_days;

SELECT * FROM doctors_count;
SELECT * FROM nurses_count;
SELECT * FROM mgr_count;
SELECT * FROM personnels_count;
SELECT * FROM patients_count;

SELECT doc_fname,doc_lname,op_id FROM doctors d JOIN operations o WHERE d.doc_id= o.doc_id ;
SELECT n.nurse_id ,nurse_fname,nurse_lname FROM nurses n JOIN off_days o WHERE n.nurse_id=o.nurse_id AND leave_type='Sick';
SELECT revenue_surgery,r.op_id FROM revenues r JOIN operations o WHERE r.op_id=o.op_id AND revenue_surgery>20000;
SELECT SUM(exp_water+exp_electricity) AS 'Water and Electricity Expenses' FROM expenses WHERE exp_date<'2026-09-30';
SELECT * FROM operations WHERE surgery='YES' AND status='DONE';

-- ---------------------------------------------------  Testing Examples of Triggers and Constraints --------------------
-- 1) (doc_id 105, hire-date is 2025-08-02):
-- INSERT INTO operations(doc_id,patient_id,prescription_name,op_type,op_date,surgery,status) VALUES (105,104,'Aspirin','Consultation','2010-04-22','NO','PLANNED');

-- 2) (doc_id 109: 2026-12-14..18 not on duty):
--  INSERT INTO operations(doc_id,patient_id,prescription_name,op_type,op_date,surgery,status) VALUES (109,104,'Checkup','Control','2026-12-16','NO','PLANNED');

-- 3) if surgery date is BEFORE op_date (op_id 16's date is 2026-12-10) -> delete op_id 16's first , then delete surgeries' record :
-- DELETE FROM surgeries WHERE op_id = 16;
-- INSERT INTO surgeries(op_id,surgery_room,works_with,surgery_date,surgery_start,surgery_end) VALUES (16,'OR-3',106,'2026-12-09','09:00','11:00');

-- 4) 2 surgeries in same room (op 6: 2025-09-12, OR-1, 08:00-12:00):
-- INSERT INTO operations(doc_id,patient_id,prescription_name,op_type,op_date,surgery,status) VALUES (106,119,'Hernia repair','Treatment','2025-09-12','YES','DONE');
-- INSERT INTO surgeries(op_id,surgery_room,works_with,surgery_date,surgery_start,surgery_end) VALUES (21,'OR-1',NULL,'2025-09-12','11:00','13:00');

-- 5) Invalid sex:
-- INSERT INTO patients(patient_fname,patient_lname,patient_SSN,patient_bdate,patient_pn,patient_sex) VALUES ('Test','Person','99999999','1990-01-01','5999999','X');

-- 6) 2 revenues on same surgery:
-- INSERT INTO revenues(op_id,revenue_surgery) VALUES (6,100);
