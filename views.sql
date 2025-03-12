CREATE VIEW View_Users AS
SELECT UserNo, Name, Age, Address, Gender, PhoneNo FROM Users;
CREATE VIEW View_Chipset_Compatibility AS
SELECT Chipset, SupportedCPUs, SupportedRAMTypes, MaxRAMFrequency FROM Chipset_Compatibility;
CREATE VIEW View_Custom_PC_Orders AS
SELECT 
    C.Build_No,
    U.Name AS CustomerName,
    C.CPU, 
    C.GPU, 
    C.Chipset, 
    C.Motherboard, 
    C.RAM, 
    C.PrimaryStorage, 
    C.SecondaryStorage, 
    C.PSU, 
    C.Cooling, 
    C.Case, 
    C.TotalPrice, 
    C.VirtualBuildDate
FROM Custom_PC_Orders C
JOIN Users U ON C.UserID = U.UserNo;
