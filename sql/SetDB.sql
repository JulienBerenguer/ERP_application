--------------- TABLES ---------------

-- User
DROP TABLE IF EXISTS `User`;
CREATE TABLE `User` (
    idUser INT AUTO_INCREMENT PRIMARY KEY,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    role ENUM('user', 'admin')
);
INSERT INTO `User` (username, password, role) VALUES
    ("user", "user", "user"),
    ("admin", "admin", "admin");


-- Company
DROP TABLE IF EXISTS `Company`;
CREATE TABLE `Company` (
    idCompany INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT NOT NULL,
    balance FLOAT NOT NULL,
    country TEXT(2)
);
INSERT INTO `Company` (name, balance, country) VALUES
    ("Company1", 10000, "US"),
    ("Company2", 100.5, "GB");


-- Product
DROP TABLE IF EXISTS `Product`;
CREATE TABLE `Product` (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT NOT NULL,
    price FLOAT NOT NULL,
    tax FLOAT NOT NULL, -- In percentage
    stock INT NOT NULL
);
INSERT INTO `Product` (name, price, tax, stock) VALUES
    ("Product1", 1, 20.5, 100),
    ("Product2", 10, 10, 10),
    ("Product3", 50, 5.5, 2);


-- Provider & Client
DROP TABLE IF EXISTS `Market`;
CREATE TABLE `Market` (
    idMarket INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('Provider', 'Client'),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    country TEXT(2)
);
INSERT INTO `Market` (name, type, address, country) VALUES
    ("Provider1", "Provider", "42, Sesame Street, Washington", "US"),
    ("Provider2", "Provider", "10 Island Street, London", "GB"),
    ("Client1", "Client", "20 Cloud Street, Georgia", "US"),
    ("Client2", "Client", "17 Lancaster Street, York", "GB");

/*-- Provider
DROP TABLE IF EXISTS `Provider`;
CREATE TABLE `Provider` (
    idProvider INT NOT NULL AUTO_INCREMENT,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    country TEXT(2)
    PRIMARY KEY (idProvider)
);
INSERT INTO `Provider` (name, address, country) VALUES
    ("Provider1", "42, Sesame Street, Washington", "US"),
    ("Provider2", "10 Island Street", "GB");



-- Client
DROP TABLE IF EXISTS `Client`;
CREATE TABLE `Client` (
    idClient INT NOT NULL AUTO_INCREMENT,
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    country TEXT(2)
    PRIMARY KEY (idClient)
);
INSERT INTO `Client` (name, address, country) VALUES
    ("Client1", "20 Cloud Street, Georgia", "US"),
    ("Client2", "17 Lancaster Street, York", "GB");*/



-- Employee
DROP TABLE IF EXISTS `Employee`;
CREATE TABLE `Employee` (
    idEmployee INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT NOT NULL,
    birthday DATE NOT NULL,
    country TEXT(2),
    idCompany INT NOT NULL,
    firstDayInCompany DATE NOT NULL,
    FOREIGN KEY (idCompany) 
        REFERENCES Company (idCompany) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE
);
INSERT INTO `Employee` (name, birthday, country, idCompany, firstDayInCompany) VALUES
    ("Employee1", "2000-01-01", "US", 1, "2020-01-01"),
    ("Employee2", "2003-01-01", "US", 1, "2021-12-25"),
    ("Employee3", "1996-01-01", "GB", 2, "2019-10-07"),
    ("Employee4", "1987-01-01", "GB", 2, "2002-08-09");



-- Transaction
DROP TABLE IF EXISTS `Transaction`;
CREATE TABLE `Transaction` (
    idTransaction INT AUTO_INCREMENT PRIMARY KEY,
    idCompany INT NOT NULL,
    idMarket INT NOT NULL,
    idEmployee INT NOT NULL,
    idProduct INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (idCompany) 
        REFERENCES Company (idCompany) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE,
    FOREIGN KEY (idMarket) 
        REFERENCES Market (idMarket) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE,
    FOREIGN KEY (idEmployee) 
        REFERENCES Employee (idEmployee) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE,
    FOREIGN KEY (idProduct) 
        REFERENCES Product (idProduct) 
        ON UPDATE RESTRICT 
        ON DELETE CASCADE
);
INSERT INTO `Transaction` (idCompany, idMarket, idEmployee, idProduct, quantity) VALUES
    (1, 1, 1, 1, 1),
    (2, 4, 4, 3, -3);


--------------- VIEWS ---------------
-- Company
DROP VIEW IF EXISTS V_Company;
CREATE VIEW V_Company AS
    SELECT 
        * 
    FROM 
        Company
    ORDER BY idCompany
;


-- Product
DROP VIEW IF EXISTS V_Product;
CREATE VIEW V_Product AS
    SELECT 
        idProduct,
        name,
        price,
        tax, 
        price*(1+(tax/100)) AS TotalPrice,
        stock 
    FROM 
        Product
    ORDER BY idProduct
;

-- Provider
DROP VIEW IF EXISTS V_Provider;
CREATE VIEW V_Provider AS
    SELECT 
        idMarket,
        name,
        address,
        country
    FROM 
        Market
    WHERE
        type = 'Provider'
    ORDER BY idMarket
;

-- Client
DROP VIEW IF EXISTS V_Client;
CREATE VIEW V_Client AS
    SELECT 
        idMarket,
        name,
        address,
        country
    FROM 
        Market
    WHERE
        type = 'Client'
    ORDER BY idMarket
;

-- Employee
DROP VIEW IF EXISTS V_Employee;
CREATE VIEW V_Employee AS
    SELECT 
        * 
    FROM 
        Employee
    ORDER BY idEmployee
;

DROP VIEW IF EXISTS V_Employee_Detailled;
CREATE VIEW V_Employee_Detailled AS
    SELECT 
        E.idEmployee,
        E.name,
        E.birthday,
        E.country,
        C.name AS CompanyName,
        E.firstDayInCompany
    FROM 
        Employee E
    INNER JOIN
        Company C
    ON 
        E.idCompany = C.idCompany
    ORDER BY E.idEmployee
;


-- Transaction
DROP VIEW IF EXISTS V_Transaction;
CREATE VIEW V_Transaction AS
    SELECT 
        *
    FROM 
        Transaction
    ORDER BY idTransaction
;

DROP VIEW IF EXISTS V_Transaction_Detailled;
CREATE VIEW V_Transaction_Detailled AS
    SELECT 
        T.idTransaction,
        C.name AS CompanyName,
        M.name AS MarketName,
        M.type AS MarketType,
        E.name AS EmployeeName,
        P.name AS ProductName,
        T.quantity
    FROM 
        Transaction T
    INNER JOIN
        Company C
    ON 
        T.idCompany = C.idCompany
    INNER JOIN
        Market M
    ON 
        T.idMarket = M.idMarket
    INNER JOIN
        Employee E
    ON 
        T.idEmployee = E.idEmployee
    INNER JOIN
        Product P
    ON 
        T.idProduct = P.idProduct
    ORDER BY T.idTransaction
;


--------------- PROCEDURES ---------------
-- Company
-- N/A

-- Product
-- N/A

-- Provider & Client
DROP PROCEDURE IF EXISTS P_Market;
CREATE PROCEDURE P_Market(
	IN  _idMarket INT,
	OUT MarketType TEXT        -- If an transaction can be made
)

    SELECT 
        type
    INTO
        MarketType
    FROM 
        Market
    WHERE
        idMarket = _idMarket
;

DROP PROCEDURE IF EXISTS P_CanBuy;
DELIMITER $$
CREATE PROCEDURE P_CanBuy(
	IN  _idCompany INT,
	IN  _idProduct INT,
	OUT CanBuy INT        -- If an transaction can be made
)
BEGIN
    CASE
        WHEN 
        (
            -- Condition (the balance of the company must be superior at the total price of the product)
            (
                SELECT 
                    balance
                FROM 
                    Company C 
                WHERE 
                    C.idCompany = _idCompany
            )
            >=
            (
                SELECT 
                    TotalPrice
                FROM 
                    V_Product P
                WHERE 
                    P.idProduct = _idProduct
            )
        ) THEN
            SET CanBuy = 0;     -- Can make the transaction
        ELSE
            SET CanBuy = 1;     -- Can't make the transaction
    END CASE;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS P_CanSell;
DELIMITER $$
CREATE PROCEDURE P_CanSell(
	IN  _idProduct INT,
    IN  _quantity INT,
	OUT CanSell INT        -- If an transaction can be made
)
BEGIN
    CASE
        WHEN 
        (
            -- Condition (the stock of the company must be superior at the demand)
            SELECT 
                stock
            FROM 
                Product P
            WHERE 
                P.idProduct = _idProduct
            >=
            _quantity
        ) THEN
            SET CanSell = 0;     -- Can make the transaction
        ELSE
            SET CanSell = 1;     -- Can't make the transaction
    END CASE;
END$$
DELIMITER ;


-- Employee
-- N/A

-- Transaction
DROP PROCEDURE IF EXISTS P_CanMakeTransaction;
CREATE PROCEDURE P_CanMakeTransaction(
	IN  _idCompany INT,
	IN  _idMarket INT,
	IN  _idEmployee INT,
	IN  _idProduct INT,
	OUT CanMakeTransaction INT        -- If an transaction can be made
)

	SELECT 
        COUNT(*) 
    INTO 
        CanMakeTransaction
    FROM 
        Company C
    INNER JOIN
        Market M
    ON 
        M.idMarket = _idMarket
    INNER JOIN
        Employee E
    ON 
        E.idEmployee = _idEmployee
    INNER JOIN
        Product P
    ON 
        P.idProduct = _idProduct
    WHERE 
        C.idCompany = _idCompany
;

DROP PROCEDURE IF EXISTS P_MakeTransaction;
DELIMITER $$
CREATE PROCEDURE P_MakeTransaction (
	IN  _idCompany INT,
	IN  _idMarket INT,
	IN  _idEmployee INT,
	IN  _idProduct INT,
	IN  _quantity INT
)
BEGIN
    SET FOREIGN_KEY_CHECKS = OFF;

    CALL P_CanMakeTransaction(_idCompany, _idMarket, _idEmployee, _idProduct, @CanMakeTransaction);
    CALL P_Market(_idMarket, @MarketType);
    CALL P_CanBuy(_idCompany, _idProduct, @CanBuy);
    CALL P_CanSell(_idProduct, _quantity, @CanSell);

	CASE   
        -- If the values selected are correct
        WHEN (SELECT @CanMakeTransaction <> 0) AND (_quantity > 0) THEN 
            BEGIN
                -- If it's a client or a provider
                CASE
                    -- Provider, we add the product
                    WHEN (SELECT @MarketType = 'Provider') AND (SELECT @CanBuy = 0) THEN
                        -- Balance
                        UPDATE 
                            Company C
                        INNER JOIN 
                            V_Product P
                        ON 
                            P.idProduct = _idProduct
                        SET 
                            C.balance = C.balance - P.TotalPrice
                        WHERE 
                            idCompany = _idCompany;

                        -- Stock
                        UPDATE 
                            Product P
                        SET 
                            P.stock = P.stock + _quantity
                        WHERE 
                            P.idProduct = _idProduct;

                        -- Transaction
                        INSERT INTO `Transaction` (idCompany, idMarket, idEmployee, idProduct, quantity) 
                        VALUES
                            (_idCompany, _idMarket, _idEmployee, _idProduct, _quantity);
                    -- Client, we substract the product
                    WHEN (SELECT @MarketType = 'Client') AND (SELECT @CanSell = 0) THEN
                         -- Balance
                        UPDATE 
                            Company C
                        INNER JOIN 
                            V_Product P
                        ON 
                            P.idProduct = _idProduct
                        SET 
                            C.balance = C.balance + P.TotalPrice
                        WHERE 
                            idCompany = _idCompany;

                        -- Stock
                        UPDATE 
                            Product P
                        SET 
                            P.stock = P.stock - _quantity
                        WHERE 
                            P.idProduct = _idProduct;

                        -- Transaction
                        INSERT INTO `Transaction` (idCompany, idMarket, idEmployee, idProduct, quantity) 
                        VALUES
                            (_idCompany, _idMarket, _idEmployee, _idProduct, _quantity);
                    -- Neither client nor provider
                END CASE;
            END;
    END CASE;
    SET FOREIGN_KEY_CHECKS = ON;
END$$