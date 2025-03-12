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
CREATE TABLE Chipset_Compatibility (
    Chipset VARCHAR(50) PRIMARY KEY,  
    SupportedCPUs TEXT NOT NULL,
    SupportedRamTypes TEXT not null,
    MaxRamFrequencyINmHZ int NOT NULL
);
create table Custom_PC_Orders(
Custom_PC_OrderID int unique default (FLOOR(RAND() * (999999 - 100000 + 1)) + 100000),
Build_No int auto_increment primary key,
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
Case varchar(100) not null,
AdditionalParts TEXT null,
TotalPrice DECIMAL(10,2),
VirtualBuildDate timestamp default current_timestamp,
Last_Modified timestamp default current_timestamp on update current_timestamp,
foreign key (UserID) references Users(UserNo) ON DELETE CASCADE,
foreign key (Chipset) references Chipset_Compatibility(Chipset)
);
DELIMITER //
CREATE TRIGGER Check_CPU_Chipset_Compatibility
BEFORE INSERT ON Custom_PC_Orders
FOR EACH ROW
BEGIN
    DECLARE valid_cpu TEXT;
    SELECT SupportedCPUs 
    INTO valid_cpu
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;
    IF NOT FIND_IN_SET(NEW.CPU, valid_cpu) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected CPU is not compatible with the chipset!';
    END IF;
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
    SELECT MaxRAMFrequency, SupportedRAMTypes 
    INTO max_freq, ram_type
    FROM Chipset_Compatibility 
    WHERE Chipset = NEW.Chipset;
    IF CAST(SUBSTRING_INDEX(NEW.RAM, ' ', -1) AS UNSIGNED) > max_freq THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected RAM exceeds chipset max frequency!';
    END IF;
    IF NOT FIND_IN_SET(SUBSTRING_INDEX(NEW.RAM, ' ', 1), ram_type) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Selected RAM type is not compatible with the chipset!';
    END IF;

END;
//
DELIMITER ;


