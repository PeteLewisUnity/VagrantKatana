USE mysql;
FLUSH PRIVILEGES;
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'mypassword';
GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'localhost';
  
CREATE SCHEMA `katana-dev` DEFAULT CHARACTER SET utf8;
