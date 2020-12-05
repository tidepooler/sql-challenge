-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/kciWTU
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE TABLE "titles" (
    "title_id" VARCHAR PRIMARY KEY,
    "title" VARCHAR NOT NULL
);

CREATE TABLE "employees" (
	"emp_no" INT PRIMARY KEY,
	"emp_title_id" VARCHAR NOT NULL,
  	FOREIGN KEY (emp_title_ID) REFERENCES titles(title_id),
	"birth_date" DATE NOT NULL,
    "first_name" VARCHAR NOT NULL,
    "last_name" VARCHAR NOT NULL,
    "sex" VARCHAR NOT NULL,
    "hire_date" DATE NOT NULL
);

CREATE TABLE "salaries" (
	"emp_no" INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    "salary" MONEY NOT NULL
);

CREATE TABLE "departments" (
	"dept_no" VARCHAR PRIMARY KEY,
    "dept_name" VARCHAR NOT NULL
);

CREATE TABLE "dept_manager" (
	"dept_no" VARCHAR NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    "emp_no" INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE "dept_emp" (
    "emp_no" INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    "dept_no" VARCHAR NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

--SELECT COLUMN HEADERS FROM EACH TABLE

SELECT * FROM TITLES;
SELECT * FROM EMPLOYEES;
SELECT * FROM SALARIES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM DEPT_MANAGER;
SELECT * FROM DEPT_EMP;

--IMPORT TABLES INTO DB
--CHECK DATA IN DB TABLES

SELECT * FROM TITLES;
SELECT * FROM EMPLOYEES;
SELECT * FROM SALARIES;
SELECT * FROM DEPARTMENTS;
SELECT * FROM DEPT_EMP;
SELECT * FROM DEPT_MANAGER;

--List the following details of each employee: 
--employee number, last name, first name, sex, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
JOIN salaries AS s
ON (e.emp_no = s.emp_no)
GROUP BY e.emp_no, s.salary;

--List first name, last name, and hire date for employees 
--who were hired in 1986.

SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(year FROM "hire_date") = 1986;

--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, 
--last name, first name.
SELECT m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name
FROM dept_manager as m
	JOIN departments as d
	ON (m.dept_no = d.dept_no)
		JOIN employees as e
		ON (m.emp_no = e.emp_no);

--List the department of each employee with the following information: 
--employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
	JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
	JOIN departments AS d
	ON (de.dept_no = d.dept_no);

--List first name, last name, and sex for employees whose first name is 
--"Hercules" and last names begin with "B."

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--List all employees in the Sales department, including their 
--employee number, last name, first name, and department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
	JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
		JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales';

--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and 
--department name.

SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
	JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
		JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales' OR d.dept_name = 'Development';


--In descending order, list the frequency count of employee last names, 
--i.e., how many employees share each last name.
SELECT employees.last_name, COUNT(employees.last_name) AS "Last Name Count"
FROM employees
GROUP BY employees.last_name
ORDER BY "Last Name Count" DESC;