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
CREATE VIEW Customer_Orders_View AS
SELECT 
    c.Custom_PC_OrderID, 
    u.Name AS Customer_Name, 
    c.CPU, c.GPU, c.Motherboard, c.RAM, 
    c.TotalPrice, c.VirtualBuildDate
FROM Custom_PC_Orders c
JOIN Users u ON c.UserID = u.UserNo;
