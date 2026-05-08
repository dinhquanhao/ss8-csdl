create database CompanyDB;

use CompanyDB;

create table Department (
    dept_id int primary key auto_increment not null,
    dept_name varchar(100) not null,
    location varchar(100)
);

create table Employee (
    emp_id int primary key auto_increment not null,
    emp_name varchar(100) not null,
    gender int default 1,
    birth_date date,
    salary decimal(10,2),
    dept_id int,
    
    foreign key (dept_id) references Department(dept_id)
);

create table Project (
    project_id int primary key auto_increment not null,
    project_name varchar(150) not null,
    emp_id int,
    start_date date default (current_date),
    end_date date,
    
    foreign key (emp_id) references Employee(emp_id)
);

alter table Employee
add email varchar(100) unique;

alter table Project
modify Project_name varchar(200);

alter table Project
add constraint check_date
check (end_date >= start_date);

INSERT INTO Department (dept_name, location)
VALUES
('IT', 'Ha Noi'),
('HR', 'HCM'),
('Marketing', 'Da Nang');

INSERT INTO Employee (emp_name, gender, birth_date, salary, dept_id, email)
VALUES
('Nguyen Van A', 1, '1990-01-15', 1500, 1, 'a@gmail.com'),
('Tran Thi B', 0, '1995-05-20', 1200, 1, 'b@gmail.com'),
('Le Minh C', 1, '1988-10-10', 2000, 2, 'c@gmail.com'),
('Pham Thi D', 0, '1992-12-05', 1800, 3, 'd@gmail.com');

INSERT INTO Project (project_name, emp_id, start_date, end_date)
VALUES
('Website Redesign', 1, '2024-01-01', '2024-06-01'),
('Recruitment System', 3, '2024-02-01', '2024-08-01'),
('Marketing Campaign', 4, '2024-03-01', NULL);

update Employee
set salary = salary + 200
where dept_id = 1;

delete from Project
where end_date < '2024-12-31'