-- =======================================================
-- 1️⃣ Insert data in StaffRoles and Staff tables
-- =======================================================
INSERT INTO StaffRoles (RoleName, Description) VALUES 
('Manager','Manages restaurant operations'),
('Chef','Prepares food orders'),
('Waiter','Serves customers');

INSERT INTO Staff (RoleID, LastName, FirstName, Salary, HireDate, Phone, Email)
VALUES
(1,'Smith','John',5000,'2025-01-01','555-1111','john.smith@example.com'),
(2,'Brown','Emma',3000,'2025-01-15','555-2222','emma.brown@example.com'),
(3,'Taylor','Liam',2500,'2025-02-01','555-3333','liam.taylor@example.com');

-- =======================================================
-- 2️⃣ Insert data in Customers table
-- =======================================================
INSERT INTO Customers (FirstName, LastName, Phone, Email, StreetAddress, City, Country)
VALUES
('Alice','Johnson','555-1010','alice.j@example.com','123 Main St','CityA','CountryX'),
('Bob','Williams','555-2020','bob.w@example.com','456 Elm St','CityB','CountryX'),
('Carol','Davis','555-3030','carol.d@example.com','789 Oak St','CityC','CountryX');

-- =======================================================
-- 3️⃣ Insert data in MenuCategories and Menu tables
-- =======================================================
INSERT INTO MenuCategories (CategoryName, Description) VALUES 
('Starter','Appetizers'),
('Main Course','Main dishes'),
('Dessert','Sweet dishes');

INSERT INTO Menu (ItemName, CategoryID, Price)
VALUES
('Bruschetta',1,50),
('Caesar Salad',1,60),
('Grilled Salmon',2,200),
('Margherita Pizza',2,200),
('Tiramisu',3,300),
('Chocolate Lava Cake',3,300);

-- ================================================================
-- 4️⃣ Insert data in Bookings table (each Customer have a Booking)
-- ================================================================
INSERT INTO Bookings (BookingDate, BookingTime, TableNumber, NumberOfGuests, CustomerID, StaffID)
VALUES
('2025-08-19','18:00:00',1,4,1,3),
('2025-08-19','19:00:00',2,3,2,3),
('2025-08-19','20:00:00',3,2,3,3),
('2022-10-10','19:00:00',5,2,1,1),
('2022-11-12','20:00:00',3,4,3,1),
('2022-10-11','18:30:00',2,3,2,1),
('2022-10-13','21:00:00',2,2,1,1);

-- ============================================================
-- 5️⃣ Insert data in Orders table (each Booking have an Order)
-- ============================================================
INSERT INTO Orders (BookingID, StaffID, OrderDate, Status)
VALUES
(1,3,NOW(),'Pending'),
(2,3,NOW(),'Pending'),
(3,3,NOW(),'Pending');

-- ==================================================================
-- 6️⃣ Insert data in OrderItems table (each Order with Quantity > 2)
-- ==================================================================
INSERT INTO OrderItems (OrderID, MenuID, Quantity, PriceEach)
VALUES
(1,3,3,200), -- Grilled Salmon
(1,4,2,200), -- Margherita Pizza
(2,3,4,200),
(2,5,3,300),
(3,4,3,200),
(3,6,4,300);

-- =======================================================
-- 7️⃣ Insert data in OrderDeliveryStatus table (optional)
-- =======================================================
INSERT INTO OrderDeliveryStatus (OrderID, Status, StaffID)
VALUES
(1,'Delivered',3),
(2,'On the way',3),
(3,'Preparing',3);-- your code goes here
