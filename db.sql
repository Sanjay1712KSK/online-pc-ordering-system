/*create database pc;
use pc;
CREATE TABLE Users (
    UserID INT UNIQUE DEFAULT (FLOOR(RAND() * (999999 - 100000 + 1)) + 100000),
    UserNo INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Age INT CHECK (Age >= 0),
    Address VARCHAR(50),
    Gender ENUM('Male', 'Female') NOT NULL,
    PhoneNo VARCHAR(13) UNIQUE NOT NULL,
    LastModified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    password_hash VARCHAR(255) NOT NULL
);*/
/*CREATE TABLE Chipset_Compatibility (
    Chipset VARCHAR(50) PRIMARY KEY,  
    SupportedCPUs JSON NOT NULL,
    SupportedRamTypes SET('DDR3', 'DDR4', 'DDR5') NOT NULL,
    MaxRamFrequencyMHZ int NOT NULL,
    MinPSUWatts int not null default 300
);*/
/*create table Custom_PC_Orders(
Build_No INT AUTO_INCREMENT PRIMARY KEY,  -- Auto-increment column
    Custom_PC_OrderID VARCHAR(20) NOT NULL UNIQUE, 
UserID int not null,
CPU varchar(100) not null,
GPU varchar(100) not null,
Chipset varchar(50) not null,
Motherboard varchar(50) not null,
RAM varchar(100) not null,
PrimaryStorage varchar(100) not null,
SecondaryStorage varchar(100) null,
PSU varchar(100) not null,
Cooling varchar(100) not null,
`Case` varchar(100) not null,
AdditionalParts JSON null,
FULLTEXT (CPU, GPU, Motherboard),
TotalPrice DECIMAL(10,2) CONSTRAINT chk_TotalPrice CHECK (TotalPrice >= 0),
VirtualBuildDate timestamp default current_timestamp,
Last_Modified timestamp default current_timestamp on update current_timestamp,
foreign key (UserID) references Users(UserNo) ON DELETE CASCADE,
foreign key (Chipset) references Chipset_Compatibility(Chipset)
);
DELIMITER //
CREATE TRIGGER before_insert_CustomPC
BEFORE INSERT ON Custom_PC_Orders
FOR EACH ROW
BEGIN
    SET NEW.Custom_PC_OrderID = CONCAT('PC', NEW.Build_No);
END;
DELIMITER ;
DELIMITER //
CREATE TRIGGER before_insert_CustomPC
BEFORE INSERT ON Custom_PC_Orders
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    SELECT AUTO_INCREMENT INTO next_id
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Custom_PC_Orders' AND TABLE_SCHEMA = DATABASE();
    SET NEW.Custom_PC_OrderID = CONCAT('PC', LPAD(next_id, 6, '0'));
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER Check_RAM_Chipset_Compatibility
BEFORE INSERT ON Custom_PC_Orders
FOR EACH ROW
BEGIN
    DECLARE max_freq INT;
    DECLARE ram_type VARCHAR(10);
    DECLARE ram_freq INT;
    SELECT MaxRamFrequencyMHZ, SupportedRamTypes 
    INTO max_freq, ram_type
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;
    SET ram_freq = CAST(REGEXP_SUBSTR(NEW.RAM, '[0-9]+') AS UNSIGNED);
    IF ram_freq > max_freq THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected RAM exceeds chipset max frequency!';
    END IF;
    IF FIND_IN_SET(SUBSTRING_INDEX(NEW.RAM, ' ', 1), ram_type) = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected RAM type is not compatible with the chipset!';
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER Check_PSU_Wattage
BEFORE INSERT ON Custom_PC_Orders
FOR EACH ROW
BEGIN
    DECLARE min_watts INT;
    DECLARE psu_watts INT;
    SELECT MinPSUWatts 
    INTO min_watts
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;
    SET psu_watts = IFNULL(CAST(REGEXP_SUBSTR(NEW.PSU, '[0-9]+') AS UNSIGNED), 0);
    IF psu_watts < min_watts THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected PSU does not meet the minimum wattage requirement!';
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER Check_CPU_Chipset_Compatibility
BEFORE INSERT ON Custom_PC_Orders
FOR EACH ROW
BEGIN
    DECLARE valid_cpu JSON;
    -- Fetch supported CPUs for the given chipset
    SELECT SupportedCPUs 
    INTO valid_cpu
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;

    -- Check if the new CPU exists in the SupportedCPUs JSON list
    IF JSON_SEARCH(valid_cpu, 'one', NEW.CPU) IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected CPU is not compatible with the chipset!';
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER Hash_Password_Before_Insert
BEFORE INSERT ON Users
FOR EACH ROW
BEGIN
    SET NEW.password_hash = SHA2(NEW.password_hash, 256);
END;
//
DELIMITER ;
*/
-- Speeding Up queries
/*ALTER TABLE Custom_PC_Orders ADD INDEX idx_UserID (UserID);
ALTER TABLE Custom_PC_Orders ADD INDEX idx_Chipset (Chipset);
ALTER TABLE Users ADD INDEX idx_PhoneNo (PhoneNo);
ALTER TABLE Custom_PC_Orders MODIFY COLUMN SecondaryStorage VARCHAR(100) DEFAULT 'None';
*/
/*CREATE TABLE Use_Cases (
    UseCase_ID INT AUTO_INCREMENT PRIMARY KEY,
    UseCase_Name VARCHAR(255) NOT NULL UNIQUE,
    Metadata JSON NOT NULL
);
INSERT INTO Use_Cases (UseCase_Name, Metadata) VALUES
('Office PC Basic', 
 JSON_OBJECT(
    'Recommended_CPU', 'Intel Core i3 / Ryzen 3',
    'Recommended_GPU', 'Integrated Graphics',
    'Recommended_RAM', '8GB DDR4',
    'Recommended_Storage', '256GB SSD + 1TB HDD',
    'Expected_Budget', '$300 - $500'
 )),
('Gaming Starter', 
 JSON_OBJECT(
    'Recommended_CPU', 'Intel Core i5 / Ryzen 5',
    'Recommended_GPU', 'GTX 1650 / RX 6500 XT',
    'Recommended_RAM', '16GB DDR4 3200MHz',
    'Recommended_Storage', '512GB SSD + 1TB HDD',
    'Expected_Budget', '$600 - $800'
 )),
('Gaming Pro', 
 JSON_OBJECT(
    'Recommended_CPU', 'Intel Core i5 / Ryzen 7',
    'Recommended_GPU', 'RTX 3060 / RX 6700 XT',
    'Recommended_RAM', '16GB DDR4 3600MHz',
    'Recommended_Storage', '1TB NVMe SSD',
    'Expected_Budget', '$900 - $1200'
 )),
('Content Creator PC', 
 JSON_OBJECT(
    'Recommended_CPU', 'Intel Core i7 / Ryzen 7',
    'Recommended_GPU', 'RTX 4060 Ti / RX 6800',
    'Recommended_RAM', '32GB DDR5 5200MHz',
    'Recommended_Storage', '1TB NVMe SSD + 2TB HDD',
    'Expected_Budget', '$1200 - $1500'
 )),
('Pro Video Editing Rig', 
 JSON_OBJECT(
    'Recommended_CPU', 'Intel Core i9 / Ryzen 9',
    'Recommended_GPU', 'RTX 4070 Ti / RX 7900 XT',
    'Recommended_RAM', '32GB DDR5 6000MHz',
    'Recommended_Storage', '2TB NVMe SSD + 4TB HDD',
    'Expected_Budget', '$2000 - $2500'
 )),
('Ultimate Gaming PC', 
 JSON_OBJECT(
    'Recommended_CPU', 'Intel Core i9 / Ryzen 9',
    'Recommended_GPU', 'RTX 4090 / RX 7900 XTX',
    'Recommended_RAM', '32GB DDR5 6000MHz',
    'Recommended_Storage', '2TB NVMe SSD',
    'Expected_Budget', '$3000+'
 )),
('AI Workstation', 
 JSON_OBJECT(
    'Recommended_CPU', 'AMD Threadripper / Intel Xeon',
    'Recommended_GPU', 'RTX 6000 Ada / H100',
    'Recommended_RAM', '128GB DDR5 ECC',
    'Recommended_Storage', '4TB NVMe SSD',
    'Expected_Budget', '$5000+'
 )),
('Extreme Ultimate Build', 
 JSON_OBJECT(
    'Recommended_CPU', 'AMD Threadripper 7995WX / Intel Xeon W9-3495X',
    'Recommended_GPU', 'RTX 4090 x 2 / RX 7900 XTX x 2',
    'Recommended_RAM', '256GB DDR5 ECC',
    'Recommended_Storage', '8TB NVMe SSD + 10TB HDD',
    'Expected_Budget', '$10,000+'
 ));
CREATE TABLE Predefined_PC_Builds (
    Build_ID INT AUTO_INCREMENT PRIMARY KEY,
    UseCase_ID INT NOT NULL, 
    UserID INT NOT NULL,  
    Build_Name VARCHAR(255) NOT NULL UNIQUE,
    Components JSON NOT NULL,  
    TotalPrice DECIMAL(10,2) CHECK (TotalPrice >= 0),
    Created_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Last_Modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CPU VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.CPU'))) STORED,
    GPU VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.GPU'))) STORED,
    RAM VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.RAM'))) STORED,
    Storage VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.PrimaryStorage'))) STORED,
    Motherboard VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.Motherboard'))) STORED,
    `Case` VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.Case'))) STORED,
    Cooler VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.Cooler'))) STORED,
    PSU VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.PSU'))) STORED,
    Monitor VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.Monitor'))) STORED,
    Accessories VARCHAR(255) GENERATED ALWAYS AS (JSON_UNQUOTE(JSON_EXTRACT(Components, '$.Accessories'))) STORED,
    FOREIGN KEY (UseCase_ID) REFERENCES Use_Cases(UseCase_ID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserNo) ON DELETE CASCADE,
    INDEX idx_cpu (CPU),
    INDEX idx_gpu (GPU),
    INDEX idx_ram (RAM),
    INDEX idx_storage (Storage),
    INDEX idx_motherboard (Motherboard),
    INDEX idx_case (`Case`),
    INDEX idx_cooler (Cooler),
    INDEX idx_psu (PSU),
    INDEX idx_monitor (Monitor),
    INDEX idx_accessories (Accessories)
);
INSERT INTO Predefined_PC_Builds (UseCase_ID, UserID, Build_Name, Components, TotalPrice) VALUES
(1, 1, 'Basic Office PC', 
 JSON_OBJECT(
    'CPU', 'Intel Core i3-13100',
    'GPU', 'Integrated UHD Graphics 730',
    'RAM', '8GB DDR4 2666MHz',
    'PrimaryStorage', '256GB NVMe SSD',
    'PSU', '450W Bronze'
 ), 450.00),
(2, 2, 'Gaming Starter Pack', 
 JSON_OBJECT(
    'CPU', 'AMD Ryzen 5 5600',
    'GPU', 'GTX 1650 4GB',
    'RAM', '16GB DDR4 3200MHz',
    'PrimaryStorage', '512GB NVMe SSD',
    'PSU', '500W Bronze'
 ), 750.00),
(3, 3, 'Mid-Tier Gaming PC', 
 JSON_OBJECT(
    'CPU', 'Intel Core i5-12600KF',
    'GPU', 'RTX 3060 12GB',
    'RAM', '16GB DDR4 3600MHz',
    'PrimaryStorage', '1TB NVMe SSD',
    'PSU', '600W Gold'
 ), 1100.00),
(4, 4, 'Content Creator Build', 
 JSON_OBJECT(
    'CPU', 'AMD Ryzen 7 7700X',
    'GPU', 'RTX 4060 Ti 16GB',
    'RAM', '32GB DDR5 5200MHz',
    'PrimaryStorage', '1TB NVMe SSD + 2TB HDD',
    'PSU', '750W Gold'
 ), 1400.00),
(5, 5, 'Professional Video Editing Workstation', 
 JSON_OBJECT(
    'CPU', 'Intel Core i9-13900K',
    'GPU', 'RTX 4070 Ti 12GB',
    'RAM', '32GB DDR5 6000MHz',
    'PrimaryStorage', '2TB NVMe SSD + 4TB HDD',
    'PSU', '850W Platinum'
 ), 2300.00),
(6, 6, 'Ultimate Gaming Beast', 
 JSON_OBJECT(
    'CPU', 'AMD Ryzen 9 7950X3D',
    'GPU', 'RTX 4090 24GB',
    'RAM', '32GB DDR5 6000MHz',
    'PrimaryStorage', '2TB NVMe SSD',
    'PSU', '1000W Platinum'
 ), 3500.00),
(7, 7, 'AI Training Machine', 
 JSON_OBJECT(
    'CPU', 'AMD Threadripper PRO 5995WX',
    'GPU', 'NVIDIA RTX 6000 Ada',
    'RAM', '128GB DDR5 ECC',
    'PrimaryStorage', '4TB NVMe SSD',
    'PSU', '1200W Titanium'
 ), 7000.00),
(8, 8, 'Extreme Ultimate Workstation', 
 JSON_OBJECT(
    'CPU', 'AMD Threadripper 7995WX',
    'GPU', 'RTX 4090 x 2',
    'RAM', '256GB DDR5 ECC',
    'PrimaryStorage', '8TB NVMe SSD + 10TB HDD',
    'PSU', '1500W Titanium'
 ), 12000.00);*/