-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE titles (
    title_id VARCHAR   NOT NULL,
    title VARCHAR   NOT NULL,
    CONSTRAINT pk_titles PRIMARY KEY (
        title_id
     )
);

CREATE TABLE employees (
    emp_no INTEGER   NOT NULL,
    emp_title_id VARCHAR   NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    sex CHAR(1)   NOT NULL,
    hire_date DATE   NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE departments (
    dept_no VARCHAR   NOT NULL,
    dept_name VARCHAR   NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE dept_emp (
    emp_no INTEGER   NOT NULL,
    dept_no VARCHAR   NOT NULL
);

CREATE TABLE dept_manager (
    dept_no VARCHAR   NOT NULL,
    emp_no INTEGER   NOT NULL
);

CREATE TABLE salaries (
    emp_no INTEGER   NOT NULL,
    salary INTEGER   NOT NULL
);

ALTER TABLE employees ADD CONSTRAINT fk_employees_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES titles (title_id);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

--List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT
	employees.emp_no,
	last_name,
	first_name,
	sex,
	salary
FROM
	employees
LEFT JOIN salaries ON salaries.emp_no = employees.emp_no


--List first name, last name, and hire date for employees who were hired in 1986.
SELECT
	first_name,
	last_name,
	hire_date
FROM
	employees
WHERE
	hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY
	hire_date

--List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT
	d.dept_no,
	dept_name,
	m.emp_no,
	last_name,
	first_name
FROM
	departments d
INNER JOIN dept_manager m ON m.dept_no = d.dept_no
INNER JOIN employees e ON e.emp_no = m.emp_no
ORDER BY d.dept_no

--List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT
	e.emp_no,
	last_name,
	first_name,
	de.dept_no,
	dept_name
FROM
	employees e
LEFT JOIN dept_emp de ON de.emp_no = e.emp_no
LEFT JOIN departments d ON d.dept_no = de.dept_no
ORDER BY last_name, first_name

--List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT
	first_name,
	last_name,
	sex
FROM
	employees
WHERE
	first_name = 'Hercules' AND last_name LIKE 'B%'
ORDER BY
	last_name

--List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT
	e.emp_no,
	last_name,
	first_name,
	dept_name
FROM
	employees e
LEFT JOIN dept_emp de ON de.emp_no = e.emp_no
LEFT JOIN departments d ON d.dept_no = de.dept_no
WHERE dept_name = 'Sales'
ORDER BY last_name, first_name

--List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT
	e.emp_no,
	last_name,
	first_name,
	dept_name
FROM
	employees e
LEFT JOIN dept_emp de ON de.emp_no = e.emp_no
LEFT JOIN departments d ON d.dept_no = de.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development'
ORDER BY last_name, first_name

--In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT
	last_name,
	COUNT(last_name)
FROM
	employees
GROUP BY
	last_name
ORDER BY
	last_name
	
--BONUS: Table of salaries by title
SELECT 
	t.title,
	AVG(s.salary)
FROM employees e 
LEFT JOIN salaries s ON s.emp_no = e.emp_no 
LEFT JOIN titles t ON t.title_id = e.emp_title_id
GROUP BY t.title
ORDER BY AVG(s.salary)
