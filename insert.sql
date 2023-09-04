ALTER TABLE users
ADD bantime TIMESTAMP,
ADD banreason VARCHAR(500);

DELIMITER $$

CREATE TRIGGER before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE new_banid VARCHAR(10);

    WHILE NOT done DO
        SET new_banid = CONCAT(
            LPAD(FLOOR(RAND() * 1000), 3, '0'), '-', 
            SUBSTRING(MD5(RAND()), 1, 3)
        );

        IF NOT EXISTS (
            SELECT 1 FROM users WHERE banid = new_banid
        ) THEN
            SET done = 1;
        END IF;
    END WHILE;

    SET NEW.banid = new_banid;
END;
$$

DELIMITER ;	