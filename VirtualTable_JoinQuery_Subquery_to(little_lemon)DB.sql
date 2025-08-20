--  ✅ Task 1: Create a Virtual Table (View)

--  We want an OrdersView that shows OrderID, Quantity, and Cost for all orders where Quantity > 2.

-- ==========================================================
-- Task 1: Virtual table (VIEW) for orders with quantity > 2
-- ==========================================================
CREATE OR REPLACE VIEW OrdersView AS
SELECT 
    oi.OrderID,
    oi.Quantity,
    oi.TotalCost
FROM OrderItems AS oi
WHERE oi.Quantity > 2;

-- Test the view
SELECT * FROM OrdersView;

-- ==================================================================
-- Task 2: Join query across Customers, Orders, Menu, and OrderItems
-- ==================================================================
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderID,
    SUM(oi.TotalCost) AS OrderTotal,
    m.ItemName AS MenuItem
FROM Customers AS c
JOIN Bookings AS b
    ON c.CustomerID = b.CustomerID
JOIN Orders AS o
    ON b.BookingID = o.BookingID
JOIN OrderItems AS oi
    ON o.OrderID = oi.OrderID
JOIN Menu AS m
    ON oi.MenuID = m.MenuID
GROUP BY c.CustomerID, o.OrderID, m.ItemName
HAVING SUM(oi.TotalCost) > 150
ORDER BY OrderTotal ASC;

-- Join query with MenuCategories.CategoryName column
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderID,
    SUM(oi.TotalCost) AS OrderTotal,
    m.ItemName AS MenuItem,
    mc.CategoryName
FROM Customers AS c
JOIN Bookings AS b
    ON c.CustomerID = b.CustomerID
JOIN Orders AS o
    ON b.BookingID = o.BookingID
JOIN OrderItems AS oi
    ON o.OrderID = oi.OrderID
JOIN Menu AS m
    ON oi.MenuID = m.MenuID
JOIN MenuCategories AS mc
    ON m.CategoryID = mc.CategoryID
GROUP BY c.CustomerID, o.OrderID, m.ItemName, mc.CategoryName
HAVING SUM(oi.TotalCost) > 150
ORDER BY OrderTotal ASC;

-- =======================================================
-- Task 3: Subquery with ANY
-- =======================================================
SELECT 
    m.ItemName
FROM Menu AS m
WHERE m.MenuID = ANY (
    SELECT oi.MenuID
    FROM OrderItems AS oi
    WHERE oi.Quantity > 2
);

-- Find menu items with more than 2 orders, including CategoryName
SELECT 
    m.ItemName,
    mc.CategoryName
FROM Menu AS m
JOIN MenuCategories AS mc
    ON m.CategoryID = mc.CategoryID
WHERE m.MenuID IN (
    SELECT oi.MenuID
    FROM OrderItems AS oi
    GROUP BY oi.MenuID
    HAVING SUM(oi.Quantity) > 2
)
ORDER BY m.ItemName;
