# testmysql

You can create an user for tests like this:


```sql
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';
```