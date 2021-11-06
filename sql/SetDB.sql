DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    id INT NOT NULL AUTO_INCREMENT,
    username TEXT NOT NULL,
    password TEXT NOT NULL,
    PRIMARY KEY (ID)
);
INSERT INTO `users` (username, password) VALUES
    ("admin","password"),
    ("Alice","this is my password"),
    ("Job","12345678");