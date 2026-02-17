/* ============================================================
   STORED PROCEDURES OPTIMIZADOS - LOGISTIC_FOODS
   ============================================================ */

USE Logistic_Foods;

/* ============================================================
   SP_REGISTER
   ============================================================ */
DROP PROCEDURE IF EXISTS SP_REGISTER;
DELIMITER //

CREATE PROCEDURE SP_REGISTER(
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_phone VARCHAR(11),
    IN p_image VARCHAR(250),
    IN p_email VARCHAR(100),
    IN p_password_hash VARCHAR(255),
    IN p_rol INT,
    IN p_notification_token VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO person (firstName, lastName, phone, image, state)
    VALUES (p_firstName, p_lastName, p_phone, p_image, 1);

    INSERT INTO users (users, email, passwordd, persona_id, rol_id, notification_token)
    VALUES (p_firstName, p_email, p_password_hash, LAST_INSERT_ID(), p_rol, p_notification_token);

    COMMIT;
END//

DELIMITER ;

/* ============================================================
   SP_LOGIN
   ============================================================ */
DROP PROCEDURE IF EXISTS SP_LOGIN;
DELIMITER //

CREATE PROCEDURE SP_LOGIN(IN p_email VARCHAR(100))
BEGIN
    SELECT 
        p.uid,
        p.firstName,
        p.lastName,
        p.image,
        p.phone,
        u.email,
        u.passwordd,
        u.rol_id,
        u.notification_token
    FROM users u
    INNER JOIN person p ON p.uid = u.persona_id
    WHERE u.email = p_email
      AND p.state = 1
    LIMIT 1;
END//

DELIMITER ;

/* ============================================================
   SP_RENEWTOKENLOGIN
   ============================================================ */
DROP PROCEDURE IF EXISTS SP_RENEWTOKENLOGIN;
DELIMITER //

CREATE PROCEDURE SP_RENEWTOKENLOGIN(IN p_uid INT)
BEGIN
    SELECT 
        p.uid,
        p.firstName,
        p.lastName,
        p.image,
        p.phone,
        u.email,
        u.rol_id,
        u.notification_token
    FROM person p
    INNER JOIN users u ON p.uid = u.persona_id
    WHERE p.uid = p_uid
      AND p.state = 1;
END//

DELIMITER ;

/* ============================================================
   SP_UPDATE_PROFILE
   ============================================================ */
DROP PROCEDURE IF EXISTS SP_UPDATE_PROFILE;
DELIMITER //

CREATE PROCEDURE SP_UPDATE_PROFILE(
    IN p_uid INT,
    IN p_firstName VARCHAR(50),
    IN p_lastName VARCHAR(50),
    IN p_phone VARCHAR(11)
)
BEGIN
    UPDATE person
    SET firstName = p_firstName,
        lastName  = p_lastName,
        phone     = p_phone
    WHERE uid = p_uid
      AND state = 1;
END//

DELIMITER ;

/* ============================================================
   SP_USER_BY_ID
   ============================================================ */
DROP PROCEDURE IF EXISTS SP_USER_BY_ID;
DELIMITER //

CREATE PROCEDURE SP_USER_BY_ID(IN p_uid INT)
BEGIN
    SELECT 
        p.uid,
        p.firstName,
        p.lastName,
        p.phone,
        p.image,
        u.email,
        u.rol_id,
        u.notification_token
    FROM person p
    INNER JOIN users u ON p.uid = u.persona_id
    WHERE p.uid = p_uid
      AND p.state = 1;
END//

DELIMITER ;

/* ============================================================
   SP_ADD_CATEGORY
   ============================================================ */
DROP PROCEDURE IF EXISTS SP_ADD_CATEGORY;
DELIMITER //

CREATE PROCEDURE SP_ADD_CATEGORY(
    IN p_category VARCHAR(50),
    IN p_description VARCHAR(100)
)
BEGIN
    INSERT INTO categories (category, description)
    VALUES (p_category, p_description);
END//

DELIMITER ;

/* ============================================================
   ÍNDICES RECOMENDADOS
   ============================================================ */

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_delivery ON orders(delivery_id);
CREATE INDEX idx_products_name ON products(nameProduct);
