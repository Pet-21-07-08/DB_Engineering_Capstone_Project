-- Minimal, limpio y corregido (MySQL 8.0+). Motor InnoDB y utf8mb4.
SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- Opcional: crea un schema
-- CREATE SCHEMA IF NOT EXISTS little_lemon DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- USE little_lemon;

-- =======================================================
-- Tablas de catálogos pequeños
-- =======================================================
CREATE TABLE IF NOT EXISTS StaffRoles (
  RoleID      INT AUTO_INCREMENT PRIMARY KEY,
  RoleName    VARCHAR(50) NOT NULL UNIQUE,
  Description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS MenuCategories (
  CategoryID    INT AUTO_INCREMENT PRIMARY KEY,
  CategoryName  VARCHAR(50) NOT NULL UNIQUE,
  Description   TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =======================================================
-- Nucleares
-- =======================================================
CREATE TABLE IF NOT EXISTS Staff (
  StaffID         INT AUTO_INCREMENT PRIMARY KEY,
  RoleID          INT NOT NULL,
  LastName        VARCHAR(50) NOT NULL,
  FirstName       VARCHAR(50) NOT NULL,
  Salary          DECIMAL(10,2) NOT NULL,
  HireDate        DATE NOT NULL,
  TerminationDate DATE NULL,
  Active          BOOLEAN NOT NULL DEFAULT TRUE,
  Phone           VARCHAR(20) NOT NULL UNIQUE,
  Email           VARCHAR(100) NOT NULL UNIQUE,
  CONSTRAINT fk_staff_role
    FOREIGN KEY (RoleID) REFERENCES StaffRoles(RoleID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Customers (
  CustomerID    INT AUTO_INCREMENT PRIMARY KEY,
  FirstName     VARCHAR(50) NOT NULL,
  MiddleName    VARCHAR(50) NULL,
  LastName      VARCHAR(50) NOT NULL,
  Gender        ENUM('Male','Female','Other') NULL,
  DateOfBirth   DATE NULL,
  Phone         VARCHAR(20) NOT NULL UNIQUE,
  Email         VARCHAR(100) NOT NULL UNIQUE,
  StreetAddress VARCHAR(100) NOT NULL,
  City          VARCHAR(50) NOT NULL,
  State         VARCHAR(50) NULL,
  PostalCode    VARCHAR(12) NULL,
  Country       VARCHAR(56) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Menu (
  MenuID      INT AUTO_INCREMENT PRIMARY KEY,
  ItemName    VARCHAR(100) NOT NULL,
  CategoryID  INT NOT NULL,
  Description TEXT,
  Price       DECIMAL(10,2) NOT NULL,
  Calories    INT NULL,
  Vegetarian  BOOLEAN NOT NULL DEFAULT FALSE,
  Available   BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_menu_category
    FOREIGN KEY (CategoryID) REFERENCES MenuCategories(CategoryID),
  CONSTRAINT chk_menu_price CHECK (Price >= 0),
  CONSTRAINT chk_menu_calories CHECK (Calories IS NULL OR Calories >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Bookings (
  BookingID       INT AUTO_INCREMENT PRIMARY KEY,
  BookingDate     DATE NOT NULL,
  BookingTime     TIME NOT NULL,
  TableNumber     INT NOT NULL,
  NumberOfGuests  INT NOT NULL,
  CustomerID      INT NOT NULL,
  StaffID         INT NOT NULL,
  Notes           TEXT NULL,
  CONSTRAINT fk_bookings_customer
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
  CONSTRAINT fk_bookings_staff
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
  CONSTRAINT chk_bookings_guests CHECK (NumberOfGuests > 0),
  CONSTRAINT uq_bookings_table UNIQUE (BookingDate, BookingTime, TableNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS Orders (
  OrderID    INT AUTO_INCREMENT PRIMARY KEY,
  BookingID  INT NOT NULL,
  StaffID    INT NOT NULL,
  OrderDate  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Status     ENUM('Pending','In Progress','Delivered','Cancelled') NOT NULL DEFAULT 'Pending',
  CONSTRAINT fk_orders_booking
    FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
  CONSTRAINT fk_orders_staff
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS OrderItems (
  OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
  OrderID     INT NOT NULL,
  MenuID      INT NOT NULL,
  Quantity    INT NOT NULL,
  PriceEach   DECIMAL(10,2) NOT NULL,
  TotalCost   DECIMAL(12,2) AS (Quantity * PriceEach) STORED,
  CONSTRAINT fk_orderitems_order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CONSTRAINT fk_orderitems_menu
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID),
  CONSTRAINT chk_orderitems_qty CHECK (Quantity > 0),
  CONSTRAINT chk_orderitems_price CHECK (PriceEach >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS OrderDeliveryStatus (
  DeliveryID   INT AUTO_INCREMENT PRIMARY KEY,
  OrderID      INT NOT NULL UNIQUE,
  DeliveryDate DATE NULL,
  DeliveryTime TIME NULL,
  Status       ENUM('Preparing','On the way','Delivered','Cancelled') NOT NULL,
  StaffID      INT NOT NULL,
  Comments     VARCHAR(255) NULL,
  CONSTRAINT fk_delivery_order
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
  CONSTRAINT fk_delivery_staff
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =======================================================
-- Índices útiles (no exagerados)
-- =======================================================
CREATE INDEX idx_bookings_customer ON Bookings(CustomerID);
CREATE INDEX idx_bookings_staff ON Bookings(StaffID);
CREATE INDEX idx_orders_booking ON Orders(BookingID);
CREATE INDEX idx_orderitems_order ON OrderItems(OrderID);
CREATE INDEX idx_orderitems_menu ON OrderItems(MenuID);
