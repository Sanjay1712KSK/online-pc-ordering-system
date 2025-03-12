-- Demo VALUE Insertion
-- insert into Users(Name,Age,Address,gender,PhoneNo,password_hash)values("Sanjay Kumar S",19,"1/235 xyz street,city","Male","+919487044111",sha2('1712',256));
/*INSERT INTO Users (Name, Age, Address, Gender, PhoneNo, password_hash) VALUES
('Alice Johnson', 25, '123 Main St', 'Female', '9876543210', 'hashed_password1'),
('Bob Smith', 30, '456 Elm St', 'Male', '8765432109', 'hashed_password2'),
('Charlie Brown', 22, '789 Oak St', 'Male', '7654321098', 'hashed_password3');
*/
/*INSERT INTO Chipset_Compatibility (Chipset, SupportedCPUs, SupportedRamTypes, MaxRamFrequencyMHZ, MinPSUWatts) VALUES
('B550', JSON_ARRAY('Ryzen 5 5600X', 'Ryzen 7 5800X', 'Ryzen 9 5900X'), 'DDR4', 3200, 500),
('Z690', JSON_ARRAY('Core i5-12600K', 'Core i7-12700K', 'Core i9-12900K'), 'DDR5', 4800, 600),
('X670', JSON_ARRAY('Ryzen 7 7700X', 'Ryzen 9 7900X'), 'DDR5', 6000, 650);
*/
/*INSERT INTO Custom_PC_Orders 
(UserID, CPU, GPU, Chipset, Motherboard, RAM, PrimaryStorage, SecondaryStorage, PSU, Cooling, `Case`, AdditionalParts, TotalPrice)
VALUES
(1, 'Ryzen 5 5600X', 'RTX 3060', 'B550', 'ASUS TUF Gaming B550', 'DDR4 3200MHz 16GB', 
 'Samsung 970 EVO 1TB', 'Seagate Barracuda 2TB', '550W Bronze', 'Cooler Master Hyper 212', 
 'NZXT H510', '{"RGB_Fans": 2}', 1200.50),

(2, 'Core i7-12700K', 'RTX 4070 Super', 'Z690', 'MSI MAG Z690', 'DDR5 4800MHz 32GB', 
 'WD Black SN850 2TB', NULL, '750W Gold', 'Corsair AIO Liquid', 
 'Lian Li PC-O11', '{"Extra_USB_Card": 1}', 2200.99),

(3, 'Ryzen 9 7900X', 'RX 7900 XT', 'X670', 'Gigabyte X670 AORUS Master', 'DDR5 6000MHz 64GB', 
 'Samsung 990 PRO 2TB', 'Crucial MX500 1TB', '850W Platinum', 'NZXT Kraken X73', 
 'Corsair 4000D', '{"Vertical_GPU_Mount": true}', 2800.75);
*/
-- To verify password
-- SELECT * FROM Users WHERE PhoneNo = "<Your value here>" AND password_hash = SHA2(<Your password here>, 256);
-- Testing errors
/*INSERT INTO Custom_PC_Orders (UserID, CPU, GPU, Chipset, Motherboard, RAM, PrimaryStorage, PSU, Cooling, `Case`, AdditionalParts, TotalPrice)
VALUES
(1, 'Ryzen 7 7700X', 'RTX 4070', 'Z690', 'MSI MAG Z690', 'DDR5 4800MHz 32GB', 'WD Black SN850 1TB', '650W Gold', 'Corsair AIO', 'NZXT H710', NULL, 1800.00);
*/