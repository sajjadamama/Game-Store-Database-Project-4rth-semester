create database gameStore;
use gameStore;
-- 1. Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'customer') NOT NULL DEFAULT 'customer'
);

-- 2. Games Table
CREATE TABLE Games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    genre VARCHAR(50),
    platform VARCHAR(50)
);

-- 3. Inventory Table
CREATE TABLE Inventory (
    game_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE
);

-- 4. Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('processing', 'shipped', 'delivered') DEFAULT 'processing',
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- 5. Order_Items Table (Many-to-Many: Orders ↔ Games)
CREATE TABLE Order_Items (
    order_id INT,
    game_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, game_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE
);

-- 6. Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);
-- 7. Cart Table (Temporary Cart for Users)
CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    game_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES Games(game_id) ON DELETE CASCADE
);

-- insert into users
INSERT INTO Users (username, email, password, role)
VALUES
('admin2', 'admin2@gamestore.com', 'hashed_admin2_pass', 'admin'),
('customer3', 'cust3@email.com', 'hashed_pass3', 'customer'),
('customer4', 'cust4@email.com', 'hashed_pass4', 'customer');

-- insert into games
INSERT INTO Games (title, description, price, genre, platform)
VALUES
('Cyberpunk 2077', 'Futuristic open-world RPG.', 39.99, 'RPG', 'PC'),
('Call of Duty: Modern Warfare', 'First-person shooter.', 59.99, 'Shooter', 'Xbox'),
('The Witcher 3', 'Fantasy adventure RPG.', 29.99, 'RPG', 'PC');
-- insert into inventry
INSERT INTO Inventory (game_id, stock_quantity)
VALUES
(1, 20),
(2, 30),
(3, 10);
--  insert into orders
INSERT INTO Orders (user_id, order_date, total_amount, status)
VALUES
(1, NOW(), 39.99, 'processing'),
(2, NOW(), 89.98, 'processing');
-- pyments
INSERT INTO Payments (order_id, payment_method, payment_status)
VALUES
(3, 'Credit Card', 'completed'),
(4, 'PayPal', 'completed');
-- Insert data into order_items for Order 1
INSERT INTO order_items (order_id, game_id, quantity, price)
VALUES
(3, 1, 1, 29.99),  -- 1 unit of Game 1
(4, 2, 1, 19.99);  -- 1 unit of Game 2

DELIMITER //

CREATE TRIGGER update_inventory_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    -- Update stock in Inventory after an order is placed
    UPDATE Inventory
    SET stock = stock - NEW.quantity
    WHERE game_id = NEW.game_id;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER restore_inventory_after_order_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    -- Restore stock in Inventory after an order is canceled
    UPDATE Inventory
    SET stock = stock + OLD.quantity
    WHERE game_id = OLD.game_id;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER check_stock_before_insert
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;

    -- Get the available stock for the game being ordered
    SELECT stock INTO available_stock
    FROM Inventory
    WHERE game_id = NEW.game_id;

    -- Check if enough stock is available
    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough stock available for this game';
    END IF;
END //

DELIMITER ;
INSERT INTO Inventory (game_id, stock_quantity) VALUES
(1, FLOOR(RAND() * 100) + 1),
(2, FLOOR(RAND() * 100) + 1),
(3, FLOOR(RAND() * 100) + 1);

SELECT* from users;
ALTER TABLE Inventory CHANGE COLUMN stock_quantity stock INT;
ALTER TABLE users ADD COLUMN status VARCHAR(50);
ALTER TABLE Users MODIFY status VARCHAR(50) DEFAULT 'unblocked';

UPDATE Users SET status = 'unblocked' WHERE status IS NULL;
SET SQL_SAFE_UPDATES = 0;

INSERT INTO Users (username, password,email, status, role)
VALUES ('alishaHashmi', 'alQadeer$01','hashmialisha3500@gmail.com', 'unblocked', 'admin');
