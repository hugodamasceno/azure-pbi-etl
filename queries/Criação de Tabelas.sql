-- Tabela employee
CREATE TABLE IF NOT EXISTS employee (
    Fname varchar(15) NOT NULL,
    Minit char,
    Lname varchar(15) NOT NULL,
    Ssn char(9) PRIMARY KEY,
    Bdate date,
    Address varchar(30),
    Sex char,
    Salary decimal(10,2) CHECK (Salary > 2000.0),
    Super_ssn char(9) REFERENCES employee(Ssn) ON DELETE SET NULL ON UPDATE CASCADE,
    Dno int NOT NULL DEFAULT 1
);

-- Tabela departament
CREATE TABLE IF NOT EXISTS departament (
    Dname varchar(15) NOT NULL,
    Dnumber int PRIMARY KEY,
    Mgr_ssn char(9) NOT NULL,
    Mgr_start_date date, 
    Dept_create_date date,
    CHECK (Dept_create_date < Mgr_start_date),
    UNIQUE (Dname),
    FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn) ON UPDATE CASCADE
);

-- Tabela dept_locations
CREATE TABLE IF NOT EXISTS dept_locations (
    Dnumber int NOT NULL REFERENCES departament(Dnumber) ON DELETE CASCADE ON UPDATE CASCADE,
    Dlocation varchar(15) NOT NULL,
    PRIMARY KEY (Dnumber, Dlocation)
);

-- Tabela project
CREATE TABLE IF NOT EXISTS project (
    Pname varchar(15) NOT NULL,
    Pnumber int PRIMARY KEY,
    Plocation varchar(15),
    Dnum int NOT NULL REFERENCES departament(Dnumber)
);

-- Tabela works_on
CREATE TABLE IF NOT EXISTS works_on (
    Essn char(9) NOT NULL REFERENCES employee(Ssn),
    Pno int NOT NULL REFERENCES project(Pnumber),
    Hours decimal(3,1) NOT NULL,
    PRIMARY KEY (Essn, Pno)
);

-- Tabela dependent
CREATE TABLE IF NOT EXISTS dependent (
    Essn char(9) NOT NULL REFERENCES employee(Ssn),
    Dependent_name varchar(15) NOT NULL,
    Sex char,
    Bdate date,
    Relationship varchar(8),
    PRIMARY KEY (Essn, Dependent_name)
);