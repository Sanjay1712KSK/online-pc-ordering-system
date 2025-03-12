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
    -- Get the next available Build_No value
    SELECT AUTO_INCREMENT INTO next_id
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'Custom_PC_Orders';
    
    -- Assign the computed ID
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
    
    -- Extract PSU wattage (handles NULL cases safely)
    SET psu_watts = COALESCE(CAST(REGEXP_SUBSTR(NEW.PSU, '[0-9]+') AS UNSIGNED), 0);
    
    -- Validate wattage requirement
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


