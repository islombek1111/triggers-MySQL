--TRIGGER - means when A happens,  do something B.  
--ex: INSERT,  UPDATE, DELETE
--checks data, handles errors,  auditing tables

SELECT * FROM employees; 

ALTER TABLE employees	
ADD COLUMN salary DECIMAL (10, 2) AFTER hourly_pay;
SELECT * FROM employees;

UPDATE employees
SET salary = hourly_pay * 2080;
SELECT * FROM employees;

--lets create TRIGGER
CREATE TRIGGER before_hourly_pay_update
BEFORE UPDATE ON employees
FOR EACH ROW
SET NEW.salary = (NEW.hourly_pay * 2080) ; 

--lets test it out

SHOW TRIGGERS; 
UPDATE employees
SET hourly_pay = 50
WHERE employee_id = 1; 
SELECT * FROM employees; 

--or
UPDATE employees
SET hourly_pay = hourly_pay + 1;
SELECT * FROM employees; 

--another example
DELETE FROM employees
WHERE employee_id = 6; 
SELECT * FROM employees; 

CREATE TRIGGER before_hourly_pay_insert
BEFORE INSERT ON employees
FOR EACH ROW 
SET NEW.salary =  (NEW.hourly_pay * 2080); 
--insert values for new employees

INSERT INTO employees
VALUES (6, "Sheldon", "Plankton", 10, 
	NULL, "janitor", "2023-01-07");
SELECT * FROM employees; 

--another example
CREATE TABLE expenses (
     expense_id INT PRIMARY KEY,
     expense_name VARCHAR (50), 
     expense_total DECIMAL (10, 2)
); 
SELECT * FROM expenses; 
INSERT INTO expenses
VALUES  (1,"salaries", 0),
	(2,"supplies", 0 ), 
        (3,"taxes", 0 ); 
SELECT * FROM expenses; 
/*lets calculate total expenses 
for salaries along with table employees*/
UPDATE expenses
SET expense_total = (SELECT SUM(salary) FROM employees)
WHERE expense_name = "salaries";
SELECT * FROM expenses; 
--another example
CREATE TRIGGER after_salary_delete
AFTER DELETE ON employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total - OLD.salary
WHERE expense_name = "salaries";
SELECT * FROM expenses; 

--remove a row for testing trigger
DELETE FROM employees
WHERE employee_id = 6; 
SELECT * FROM expenses;

--another example
CREATE TRIGGER after_salary_insert
AFTER INSERT ON employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total + NEW.salary
WHERE expense_name = "salaries"; 

--lets test it  out
INSERT INTO employees
VALUES (6, "Sheldon" , "Plankton", 10, 
	NULL, "janitor", "2023-01-07");
SELECT * FROM expenses;
--another example
CREATE TRIGGER after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
UPDATE expenses
SET expense_total = expense_total + (NEW.salary - OLD.salary)
WHERE expense_name = "salaries";

UPDATE employees	
SET hourly_pay = 100
WHERE employee_id = 1;
SELECT * FROM expenses;
--DONE
