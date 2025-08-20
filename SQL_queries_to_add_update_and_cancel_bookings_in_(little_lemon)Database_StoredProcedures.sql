-- ✅ Task 1: Stored Procedure AddBooking

-- This procedure inserts a new record into the Bookings table.

DELIMITER //

CREATE PROCEDURE AddBooking (
    IN inBookingID INT,
    IN inBookingDate DATE,
    IN inBookingTime TIME,
    IN inTableNumber INT,
    IN inNumberOfGuests INT,
    IN inCustomerID INT,
    IN inStaffID INT,
    IN inNotes VARCHAR(255)
)
BEGIN
    INSERT INTO Bookings (
        BookingID, 
        BookingDate, 
        BookingTime, 
        TableNumber, 
        NumberOfGuests, 
        CustomerID, 
        StaffID, 
        Notes
    )
    VALUES (
        inBookingID, 
        inBookingDate, 
        inBookingTime, 
        inTableNumber, 
        inNumberOfGuests, 
        inCustomerID, 
        inStaffID, 
        inNotes
    );

    SELECT CONCAT('Booking ', inBookingID, ' has been successfully added.') AS Message;
END //

DELIMITER ;

-- 👉 Example of Use:

CALL AddBooking(
    10,             -- BookingID
    1,              -- CustomerID
    '2022-12-01',   -- BookingDate
    '19:00:00',     -- BookingTime
    3,              -- TableNumber
    4,              -- NumberOfGuests
    2,              -- StaffID
    NULL            -- Notes
);


CALL AddBooking(
    11,
    2,
    '2022-12-02',
    '20:00:00',
    5,
    2,
    3,
    'Anniversary dinner'
);


CALL AddBooking(
    12,
    3,
    '2022-12-03',
    '18:30:00',
    1,
    6,
    1,
    'Window seat, please'
);



-- ✅ Task 2: Stored Procedure UpdateBooking

-- This procedure allows you to modify the date of an existing reservation.

 DELIMITER //

 CREATE PROCEDURE UpdateBooking (
     IN inBookingID INT,
     IN inBookingDate DATE
 )
 BEGIN
     UPDATE Bookings
     SET BookingDate = inBookingDate
     WHERE BookingID = inBookingID;

     SELECT CONCAT('Booking ', inBookingID, ' has been updated to ', inBookingDate) AS Message;
 END //

 DELIMITER ;

 -- 👉 Example of use:

 CALL UpdateBooking(2, '2022-12-10');
 
 
 
 -- ✅ Task 3: Stored Procedure CancelBooking

 -- This procedure removes a reservation from the Bookings table.

 DELIMITER //

 CREATE PROCEDURE CancelBooking (
     IN inBookingID INT
 )
 BEGIN
     DELETE FROM Bookings
     WHERE BookingID = inBookingID;

     SELECT CONCAT('Booking ', inBookingID, ' has been cancelled.') AS Message;
 END //

 DELIMITER ;

 -- 👉 Example of Use:

 CALL CancelBooking(3);
 
 
-- 🎯 OVERVIEW:

-- AddBooking → Insert a new booking.
-- UpdateBooking → Change the date of an existing booking.
-- CancelBooking → Delete a booking.