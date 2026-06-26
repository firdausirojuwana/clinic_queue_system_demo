-- ============================================
--  CLINIC QUEUE MANAGEMENT SYSTEM
--  IMD261 Group Assignment - KCDIM1104B
--  Universiti Teknologi MARA Sungai Petani
-- ============================================
--  Members:
--    Ahmad Danish bin Mohamad Asrulsani  (2024293762)
--    Ammar Firdaus bin Mohamad Azrin     (2024236564)
--    Muhammad Aiman bin Mad Zahudi       (2024415796)
--    Muhamad Daniel Iman bin Mohd Zazuri (2024281242)
--
--  Prepared for: Dr. Mohd Zool Hilmie Bin Mohamed Sawal
--  Database: MySQL / MariaDB (Laragon)
-- ============================================


-- ============================================
-- CLINIC QUEUE MANAGEMENT SYSTEM DATABASE
-- FIXED VERSION (READY TO RUN)
-- ============================================

-- ============================================
-- STEP 1: CREATE DATABASE
-- ============================================

DROP DATABASE IF EXISTS clinic_queue;

CREATE DATABASE clinic_queue;

USE clinic_queue;


-- ============================================
-- STEP 2: CREATE TABLES
-- ============================================

-- --------------------------------------------
-- TABLE 1: PATIENT
-- --------------------------------------------

CREATE TABLE patient (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    ic_number VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(20),
    email VARCHAR(100),
    gender ENUM('Male', 'Female', 'Other'),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- --------------------------------------------
-- TABLE 2: DOCTOR
-- --------------------------------------------

CREATE TABLE doctor (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialty VARCHAR(100) DEFAULT 'General Practice',
    phone VARCHAR(20),
    room_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- --------------------------------------------
-- TABLE 3: APPOINTMENT
-- --------------------------------------------

CREATE TABLE appointment (
    appoint_id INT AUTO_INCREMENT PRIMARY KEY,

    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,

    queue_number INT NOT NULL,

    appointment_datetime DATETIME NOT NULL,

    status ENUM(
        'Waiting',
        'In Consultation',
        'Completed',
        'Cancelled'
    ) DEFAULT 'Waiting',

    symptoms TEXT,
    diagnosis TEXT,

    blood_pressure VARCHAR(20),
    temperature DECIMAL(4,1),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- --------------------------------------------
-- TABLE 4: PRESCRIPTION
-- --------------------------------------------

CREATE TABLE prescription (
    prescript_id INT AUTO_INCREMENT PRIMARY KEY,

    doctor_id INT NOT NULL,
    appoint_id INT NOT NULL,

    presc_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    total_cost DECIMAL(8,2) DEFAULT 0.00,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    FOREIGN KEY (appoint_id)
        REFERENCES appointment(appoint_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


-- --------------------------------------------
-- TABLE 5: MEDICINE
-- --------------------------------------------

CREATE TABLE medicine (
    medicine_id INT AUTO_INCREMENT PRIMARY KEY,

    medicine_name VARCHAR(100) NOT NULL,

    dosage VARCHAR(50),

    unit_price DECIMAL(8,2) NOT NULL DEFAULT 0.00,

    stock_quantity INT NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- --------------------------------------------
-- TABLE 6: PRESCRIPTION_MEDICINE
-- --------------------------------------------

CREATE TABLE prescription_medicine (
    pm_id INT AUTO_INCREMENT PRIMARY KEY,

    prescription_id INT NOT NULL,

    medicine_id INT NOT NULL,

    quantity INT NOT NULL DEFAULT 1,

    FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescript_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- ============================================
-- STEP 3: INSERT SAMPLE DATA
-- ============================================

-- --------------------------------------------
-- PATIENTS
-- --------------------------------------------

INSERT INTO patient
(name, ic_number, phone, email, gender, address)
VALUES

('Adnan',
 '020411-02-0197',
 '017-5650624',
 'adnan12@gmail.com',
 'Male',
 'No. 12, Jalan Mawar, Sungai Petani, Kedah'),

('Siti Aisyah',
 '010523-08-1234',
 '011-2345678',
 'sitiaisyah@gmail.com',
 'Female',
 'No. 5, Jalan Kenanga, Alor Setar, Kedah'),

('Hafiz',
 '990314-04-5678',
 '019-8765432',
 'hafiz99@gmail.com',
 'Male',
 'No. 88, Jalan Dahlia, Kulim, Kedah');


-- --------------------------------------------
-- DOCTORS
-- --------------------------------------------

INSERT INTO doctor
(name, specialty, phone, room_number)
VALUES

('Dr. Farhaan',
 'General Practice',
 '04-4412000',
 'Room 1'),

('Dr. Nurul Ain',
 'General Practice',
 '04-4412001',
 'Room 2'),

('Dr. Zulkifli',
 'General Practice',
 '04-4412002',
 'Room 3');


-- --------------------------------------------
-- APPOINTMENTS
-- --------------------------------------------

INSERT INTO appointment
(
    patient_id,
    doctor_id,
    queue_number,
    appointment_datetime,
    status,
    symptoms,
    diagnosis,
    blood_pressure,
    temperature
)
VALUES

(1, 1, 1,
 '2026-04-24 09:00:00',
 'Completed',
 'Fever, cough',
 'Influenza (Flu)',
 '120/80',
 38.2),

(2, 2, 2,
 '2026-04-24 09:30:00',
 'Completed',
 'Headache, fatigue',
 'Tension headache',
 '118/76',
 37.1),

(3, 1, 3,
 '2026-04-24 10:00:00',
 'Completed',
 'Sore throat, runny nose',
 'Upper respiratory tract infection',
 '115/75',
 37.8),

(1, 3, 1,
 '2026-05-02 08:45:00',
 'Waiting',
 NULL,
 NULL,
 NULL,
 NULL);


-- --------------------------------------------
-- MEDICINES
-- --------------------------------------------

INSERT INTO medicine
(medicine_name, dosage, unit_price, stock_quantity)
VALUES

('Panadol',   '500mg',  2.00, 100),
('Vitamin C', '1000mg', 5.00,  50),
('Clarinase', '5mg',    3.50,  80),
('Strepsils', '8.75mg', 4.00,  60),
('Augmentin', '625mg',  8.00,  40),
('Ibuprofen', '400mg',  2.50,  90);


-- --------------------------------------------
-- PRESCRIPTIONS
-- --------------------------------------------

INSERT INTO prescription
(
    doctor_id,
    appoint_id,
    presc_date,
    total_cost
)
VALUES

(1, 1, '2026-04-24 09:15:00', 12.00),
(2, 2, '2026-04-24 09:45:00', 10.00),
(1, 3, '2026-04-24 10:20:00', 15.50);


-- --------------------------------------------
-- PRESCRIPTION MEDICINES
-- --------------------------------------------

INSERT INTO prescription_medicine
(
    prescription_id,
    medicine_id,
    quantity
)
VALUES

-- Adnan
(1, 1, 2),
(1, 2, 10),

-- Siti Aisyah
(2, 1, 2),
(2, 6, 4),

-- Hafiz
(3, 3, 5),
(3, 4, 3),
(3, 1, 2);


-- ============================================
-- STEP 4: CREATE INDEXES
-- ============================================

CREATE INDEX idx_appointment_date
ON appointment(appointment_datetime);

CREATE INDEX idx_patient_name
ON patient(name);

CREATE INDEX idx_medicine_name
ON medicine(medicine_name);


-- ============================================
-- STEP 5: TRIGGER TO AUTO REDUCE STOCK
-- ============================================

DELIMITER //

CREATE TRIGGER reduce_medicine_stock
AFTER INSERT ON prescription_medicine
FOR EACH ROW
BEGIN

    UPDATE medicine
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE medicine_id = NEW.medicine_id;

END//

DELIMITER ;


-- ============================================
-- STEP 6: SAMPLE QUERIES
-- ============================================

-- --------------------------------------------
-- QUERY 1:
-- VIEW ALL APPOINTMENTS
-- --------------------------------------------

SELECT
    a.appoint_id,
    p.name AS patient_name,
    d.name AS doctor_name,
    a.queue_number,
    a.appointment_datetime,
    a.status,
    a.symptoms,
    a.diagnosis

FROM appointment a

JOIN patient p
ON a.patient_id = p.patient_id

JOIN doctor d
ON a.doctor_id = d.doctor_id

ORDER BY a.appointment_datetime;


-- --------------------------------------------
-- QUERY 2:
-- VIEW PRESCRIPTIONS WITH MEDICINES
-- --------------------------------------------

SELECT
    p.name AS patient_name,

    pr.prescript_id,

    pr.presc_date,

    m.medicine_name,

    m.dosage,

    pm.quantity,

    m.unit_price,

    (pm.quantity * m.unit_price) AS subtotal,

    pr.total_cost

FROM prescription pr

JOIN appointment a
ON pr.appoint_id = a.appoint_id

JOIN patient p
ON a.patient_id = p.patient_id

JOIN prescription_medicine pm
ON pr.prescript_id = pm.prescription_id

JOIN medicine m
ON pm.medicine_id = m.medicine_id

ORDER BY pr.prescript_id;


-- --------------------------------------------
-- QUERY 3:
-- VIEW TODAY'S QUEUE
-- --------------------------------------------

SELECT
    a.queue_number,

    p.name AS patient_name,

    d.name AS doctor_name,

    d.room_number,

    a.status,

    a.appointment_datetime

FROM appointment a

JOIN patient p
ON a.patient_id = p.patient_id

JOIN doctor d
ON a.doctor_id = d.doctor_id

WHERE DATE(a.appointment_datetime) = CURDATE()

ORDER BY a.queue_number;


-- --------------------------------------------
-- QUERY 4:
-- VIEW MEDICINE STOCK
-- --------------------------------------------

SELECT
    medicine_id,

    medicine_name,

    dosage,

    unit_price,

    stock_quantity,

    CASE
        WHEN stock_quantity <= 20 THEN 'LOW STOCK'
        WHEN stock_quantity <= 50 THEN 'Moderate'
        ELSE 'Sufficient'
    END AS stock_status

FROM medicine

ORDER BY stock_quantity ASC;


-- --------------------------------------------
-- QUERY 5:
-- TOTAL APPOINTMENTS PER DOCTOR
-- --------------------------------------------

SELECT
    d.name AS doctor_name,

    d.room_number,

    COUNT(a.appoint_id) AS total_appointments

FROM doctor d

LEFT JOIN appointment a
ON d.doctor_id = a.doctor_id

GROUP BY d.doctor_id

ORDER BY total_appointments DESC;


-- Get all completed appointments for a specific patient
SELECT * FROM appointment
WHERE status = 'Completed' AND patient_id = 1;

-- Get all medicines that are low in stock
SELECT * FROM medicine
WHERE stock_quantity <= 50 AND unit_price > 2.00;

-- Get all patients with a Gmail address
SELECT * FROM patient
WHERE gender = 'Male' AND email LIKE '%@gmail.com';

-- Get all appointments handled by Doctor 1 that are still waiting
SELECT * FROM appointment
WHERE doctor_id = 1 AND status = 'Waiting';

-- Get all prescriptions issued in April 2026 with cost above RM10
SELECT * FROM prescription
WHERE total_cost > 10.00 AND presc_date LIKE '2026-04%';