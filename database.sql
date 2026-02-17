/* ============================================================
   DATABASE: LOGISTIC_FOODS
   ============================================================ */

DROP DATABASE IF EXISTS Logistic_Foods;
CREATE DATABASE Logistic_Foods
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE Logistic_Foods;

/* ============================================================
   TABLE: roles
   ============================================================ */
CREATE TABLE roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rol VARCHAR(50) NOT NULL,
    description VARCHAR(100) NOT NULL,
    state BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO roles (rol, description) VALUES
('Admin', 'System Administrator'),
('Client', 'Application Client'),
('Delivery', 'Delivery Person');


/* ============================================================
   TABLE: person
   ============================================================ */
CREATE TABLE person (
    uid INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    phone VARCHAR(15),
    image VARCHAR(255),
    state BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


/* ============================================================
   TABLE: addresses
   ============================================================ */
CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(100),
    reference VARCHAR(100),
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    persona_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_address_person
        FOREIGN KEY (persona_id)
        REFERENCES person(uid)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;


/* ============================================================
   TABLE: users
   ============================================================ */
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    persona_id INT NOT NULL,
    rol_id INT NOT NULL,
    notification_token VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_person
        FOREIGN KEY (persona_id)
        REFERENCES person(uid)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_user_role
        FOREIGN KEY (rol_id)
        REFERENCES roles(id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;


/* ============================================================
   TABLE: categories
   ============================================================ */
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    description VARCHAR(100),
    state BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;


/* ============================================================
   TABLE: products
   ============================================================ */
CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nameProduct VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(11,2) NOT NULL,
    stock INT DEFAULT 0,
    status BOOLEAN DEFAULT TRUE,
    category_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;


/* ============================================================
   TABLE: image_product
   ============================================================ */
CREATE TABLE image_product (
    id INT PRIMARY KEY AUTO_INCREMENT,
    picture VARCHAR(255),
    product_id INT NOT NULL,
    CONSTRAINT fk_image_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;


/* ============================================================
   TABLE: orders
   ============================================================ */
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    delivery_id INT,
    address_id INT NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    status VARCHAR(50) DEFAULT 'PENDING',
    receipt VARCHAR(100),
    amount DECIMAL(11,2),
    pay_type VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_order_client
        FOREIGN KEY (client_id)
        REFERENCES person(uid)
        ON UPDATE CASCADE,
    CONSTRAINT fk_order_delivery
        FOREIGN KEY (delivery_id)
        REFERENCES person(uid)
        ON UPDATE CASCADE,
    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)
        REFERENCES addresses(id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;


/* ============================================================
   TABLE: order_details
   ============================================================ */
CREATE TABLE order_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(11,2) NOT NULL,
    CONSTRAINT fk_detail_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_detail_product
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;


/* ============================================================
   INDEXES FOR PERFORMANCE
   ============================================================ */
CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_product_category ON products(category_id);
CREATE INDEX idx_order_status ON orders(status);
CREATE INDEX idx_order_client ON orders(client_id);
CREATE INDEX idx_order_delivery ON orders(delivery_id);
CREATE INDEX idx_product_name ON products(nameProduct);
