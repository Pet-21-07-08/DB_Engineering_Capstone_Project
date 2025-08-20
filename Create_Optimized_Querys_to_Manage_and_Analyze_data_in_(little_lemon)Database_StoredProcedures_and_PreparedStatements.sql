-- Task 1: Stored Procedure to Get Maximum Ordered Quantity

-- We want a procedure called GetMaxQuantity that retrieves the maximum quantity from OrderItems.

DELIMITER //

CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(Quantity) AS MaxQuantity
    FROM OrderItems;
END //

DELIMITER ;

-- Call the procedure
CALL GetMaxQuantity();



-- Task 2: Prepared Statement to Get Order Details for a Customer.

-- We want a prepared statement called GetOrderDetail that returns OrderID, Quantity, and TotalCost for a given CustomerID.

-- Prepare the statement
PREPARE GetOrderDetail FROM
'SELECT o.OrderID, oi.Quantity, oi.TotalCost
 FROM Orders o
 JOIN Bookings b ON o.BookingID = b.BookingID
 JOIN OrderItems oi ON o.OrderID = oi.OrderID
 WHERE b.CustomerID = ?';

-- Set the input variable
SET @id = 1;

-- Execute the prepared statement with the variable
EXECUTE GetOrderDetail USING @id;

-- Optional: Deallocate the prepared statement after use
DEALLOCATE PREPARE GetOrderDetail;



-- Task 3: Stored Procedure to Cancel an Order

-- We want a procedure called CancelOrder that deletes an order based on its OrderID.

DELIMITER //

CREATE PROCEDURE CancelOrder(IN orderID INT)
BEGIN
    -- Delete from OrderDeliveryStatus first (to respect foreign key)
    DELETE FROM OrderDeliveryStatus
    WHERE OrderID = orderID;

    -- Delete from OrderItems
    DELETE FROM OrderItems
    WHERE OrderID = orderID;

    -- Delete from Orders
    DELETE FROM Orders
    WHERE OrderID = orderID;
    
    -- Display confirmation message
    SELECT CONCAT('Order with ID = ', orderID, ' has been successfully cancelled.') AS ConfirmationMessage;
    
ELSE
    -- If it doesn't exist, show error
    SELECT CONCAT('Order with ID = ', orderID, ' does not exist.') AS ErrorMessage;
    
    END IF;
END //

DELIMITER ;

-- Example call to cancel order with ID = 3
CALL CancelOrder(3);
