-- ✅ Task 1: Insert records into the Bookings table(records have already been inserted into the table).



-- ✅ Task 2: Stored Procedure CheckBooking

-- This procedure receives the date and table number, and returns whether it is available or not.

DELIMITER //

CREATE PROCEDURE CheckBooking (
    IN inBookingDate DATE,
    IN inTableNumber INT
)
BEGIN
    DECLARE bookingStatus INT;

    SELECT COUNT(*) INTO bookingStatus
    FROM Bookings
    WHERE BookingDate = inBookingDate
      AND TableNumber = inTableNumber;

    IF bookingStatus > 0 THEN
        SELECT CONCAT('Table ', inTableNumber, 
                      ' is already booked on ', inBookingDate) 
                      AS Status;
    ELSE
        SELECT CONCAT('Table ', inTableNumber, 
                      ' is available on ', inBookingDate) 
                      AS Status;
    END IF;
END //

DELIMITER ;

👉 Execution Example:

CALL CheckBooking('2022-10-10', 5);
CALL CheckBooking('2022-10-10', 3);



-- ✅ Task 3: Stored Procedure AddValidBooking con TRANSACTION

-- This procedure attempts to insert a new reservation, but:

-- If the table is already occupied → ROLLBACK
-- If the table is free → COMMIT

DELIMITER //

CREATE PROCEDURE AddValidBooking (
    IN inBookingDate DATE,
    IN inBookingTime TIME,
    IN inTableNumber INT,
    IN inNumberOfGuests INT,
    IN inCustomerID INT,
    IN inStaffID INT,
    IN inNotes VARCHAR(255)
)
BEGIN
    DECLARE bookingCount INT;

    START TRANSACTION;

    -- Check if the table is already reserved on that date
    SELECT COUNT(*) INTO bookingCount
    FROM Bookings
    WHERE BookingDate = inBookingDate
      AND BookingTime = inBookingTime
      AND TableNumber = inTableNumber;

    IF bookingCount > 0 THEN
        -- If already booked, cancel
        ROLLBACK;
        SELECT CONCAT('Booking declined: Table ', inTableNumber,
                      ' is already booked on ', inBookingDate,
                      ' at ', inBookingTime) AS Status;
    ELSE
        -- If free, insert and confirm
        INSERT INTO Bookings 
        (BookingDate, BookingTime, TableNumber, NumberOfGuests, 
CustomerID, StaffID, Notes)
        VALUES 
            (inBookingDate, inBookingTime, inTableNumber, inNumberOfGuests,
inCustomerID, inStaffID, inNotes);

        COMMIT;
        SELECT CONCAT('Booking successful: Table ', inTableNumber,
                      ' reserved on ', inBookingDate,
                      ' at ', inBookingTime) AS Status;
    END IF;
END //

DELIMITER ;

👉 Execution Example:

-- Successful Case (table available)
CALL AddValidBooking(
    '2022-12-01',        -- inBookingDate
    '19:00:00',          -- inBookingTime
    4,                   -- inTableNumber
    2,                   -- inNumberOfGuests
    1,                   -- inCustomerID
    1,                   -- inStaffID
    'Window seat requested'  -- inNotes
);

-- Failed Case (occupied table)
CALL AddValidBooking(
    '2022-12-01',        
    '19:00:00',          
    4,                   
    3,                   
    2,                   
    2,                   
    'Anniversary dinner'
);

-- Other table/ other schedule
CALL AddValidBooking(
    '2022-12-01',        
    '20:30:00',          
    5,                   
    4,                   
    3,                   
    1,                   
    NULL   -- Notes vacío
);
