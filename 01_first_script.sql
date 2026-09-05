-- creates a new database named 'sql_learning'
CREATE DATABASE IF NOT EXISTS sql_learning; 

-- switches to the 'sql_learning' database
USE sql_learning; 

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT * FROM users;

-- deletes the 'users' table from the database
DROP TABLE users;

-- deletes the 'sql_learning' database
DROP DATABASE sql_learning; 
