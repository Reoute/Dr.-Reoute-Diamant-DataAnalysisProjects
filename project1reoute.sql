--ReouteProject1 --
CREATE DATABASE ReouteProject_4
go
USE ReouteProject_4
go

Create table Projects
(
ProjectsID INT identity (1,1) not null, 
Projectname nvarchar (20) not null,
Projectstart datetime not null,
Projectend datetime not null,
ProjectsLocation nvarchar (60) null,
constraint id_project primary key (ProjectsID), 
constraint project_date check (Projectend> Projectstart)
)

Create table Employees
(
EmployeeID INT identity (1,1) not null,
Firstname nvarchar (10) not null,
Lastname nvarchar (20) not null,
AccessProjectsPermissions nvarchar (10) not null DEFAULT ('VIEW'),
Birthdate datetime not null constraint ckBirthdate check (Birthdate<getdate ()), 
Hiredate datetime not null constraint ckHiredate check (Hiredate< getdate ()),
Adress nvarchar (30) null,
City nvarchar (15) null,
Phone nvarchar (12) not null unique,
constraint id_employees primary key (EmployeeID)
)


create table Emp_Projects
(ProjectsID INT not null,
Projectname nvarchar (20) not null,
EmployeeID INT not null,
Lastname nvarchar (20) not null,
constraint project_emp primary key (ProjectsID, EmployeeID),
constraint id_project1 foreign key (ProjectsID) references Projects(ProjectsID),
constraint id_emp foreign key (EmployeeID) references  Employees(EmployeeID)
)

create table Service_type
(Servicetype int not null,
servicename nvarchar(15) not null,
constraint type_service primary key (Servicetype)
)

Create table Suppliers
(
Supplierid INT identity (1,1) not null,
Suppliername nvarchar(35) not null,
ServiceType1 int not null,
ContactName nvarchar(20)null,
ContactTitle nvarchar(30)null,
MailAddress nvarchar(30)not null unique,
City nvarchar (15) not null,
Phone nvarchar (15) not null unique,
HomePage ntext null,
constraint id_supplier primary key (Supplierid),
constraint type_supplier1 foreign key (Servicetype1) references Service_type(Servicetype)
)


 create table projects_suppliers
( ProjectsID INT not null,
Projectname nvarchar (20) not null,
Supplierid INT not null,
Suppliername nvarchar(35) not null,
constraint project_sup primary key (ProjectsID, Supplierid),
constraint id_proj foreign key (ProjectsID) references Projects(ProjectsID),
constraint id_sup foreign key (Supplierid) references Suppliers (SupplierID)
)

Create table Contracts
(
ContractID int identity (1,1) not null,
ProjectsID INT not null,
Supplierid INT not null,
ContractName nvarchar(35) not null,
ServiceType1 int not null,
ContractStartDate datetime not null, 
ContractEndDate datetime not null,
ContractScope money not null constraint ch_contractscope check (ContractScope>0),
ContractRealIndex nvarchar(30)not null default ('CPI'),
constraint id_contract primary key (ContractID),
constraint id_projcont foreign key (ProjectsID) references projects (ProjectsID),
constraint id_projsup foreign key (Supplierid) references suppliers (Supplierid),
constraint type_contract1 foreign key (ServiceType1) references Service_type(Servicetype)
)



Create table Accounts
(
AccountID INT identity (1,1) not null,
ContractID INT not null, 
AccountName nvarchar(30)null,
AccountType nvarchar(15) not null,
AccountRate MONEY not null constraint ch_AccountRate check (AccountRate>0),
AccountsDate datetime not null, 
constraint id_account primary key (AccountID),
constraint id_accountscontract foreign key (ContractID) references Contracts(ContractID)
)

alter table Accounts
add AccountLinkMonth as datename (month, AccountsDate)


 
INSERT INTO Projects VALUES ('MetroNorth','2022-12-01','2024-12-31','Haifa Krayot Road')
INSERT INTO Projects VALUES ('MetroSouth','2021-11-06', '2023-12-31', 'Haifa TiratCarmel Road') 
INSERT INTO Projects VALUES ('LRTNofit','2022-10-04', '2024-06-30', 'Haifa-Nazareth road')
INSERT INTO Projects VALUES ('LRTDan','2022-06-04', '2024-01-01', NULL)
INSERT INTO Projects VALUES ('Road6North','2022-01-01', '2024-03-01', 'Someh Junction')

INSERT INTO Employees VALUES('IDO', 'DIAMANT', DEFAULT, '1982-06-30', '2023-07-16', null, 'HAIFA', '0508345671') 
INSERT INTO Employees VALUES('REOUTE', 'DREY', 'ACTION', '1985-01-16', '2020-06-16', 'SHAUL 8 HAIFA', null, '0576663331')
INSERT INTO Employees VALUES('MAY', 'HAIM', DEFAULT, '1995-01-30', '2022-02-01', null, 'BAT YAM', '0542112194')
INSERT INTO Employees VALUES('GUY', 'DRAY', 'ACTION', '1980-04-30', '2015-01-01', 'OREN 14 REHOVOT', 'REHOVOT', '0542112197')
INSERT INTO Employees VALUES('TAL', 'ATAR', DEFAULT, '2000-01-30', '2024-02-18', 'RAKEFET 10 HAIFA', 'HAIFA', '057444562')
INSERT INTO Employees VALUES('OMER', 'COHEN', 'ACTION', '1983-07-16', '2000-01-01', 'NARKISIIM 12 TEL AVIA', 'TEL AVIV', '0508426001')
INSERT INTO Employees VALUES('GAL', 'MADAI', DEFAULT, '1985-05-16', '2001-02-01', 'NEHOSHET 17 BAT YAM', 'BAT YAM', '0542112193')
INSERT INTO Employees VALUES('OFEG', 'SHARONI', DEFAULT, '1984-02-20', '2003-03-03', 'HAHAROSHET 20 NETNYA', 'NETANYA', '0508426009')

insert into emp_projects values (1, 'MetroNorth', 1, 'DIAMANT') 
insert into emp_projects values (1, 'MetroNorth', 2, 'DREY') 
insert into emp_projects values (2,'MetroSouth', 3, 'HAIM') 
insert into emp_projects values (2, 'MetroSouth', 4, 'DRAY') 
insert into emp_projects values (3, 'LRTNofit', 5, 'ATAR')
insert into emp_projects values (3, 'LRTNofit', 6,'COHEN') 
insert into emp_projects values (4, 'LRTDan',7,'MADAI')
insert into emp_projects values (4, 'LRTDan', 8,'SHARONI')
insert into emp_projects values (3,'LRTNofit', 1,'DIAMANT') 
insert into emp_projects values (3, 'LRTNofit', 2, 'DREY') 
insert into emp_projects values (1, 'MetroNorth', 3,'HAIM') 
insert into emp_projects values (1, 'MetroNorth', 4,'DRAY') 
insert into emp_projects values (4, 'LRTDan', 5,'ATAR')
insert into emp_projects values (4, 'LRTDan', 6, 'COHEN') 
insert into emp_projects values (5, 'Road6North', 7,'MADAI')
insert into emp_projects values (5, 'Road6North', 8,'SHARONI')

INSERT INTO Suppliers VALUES ('ACKERSTEIN Urban Infrastructures', 1, 'SHIR HEN', 'Sales Representative', 'Shir@ackerstein.co.il', 
'RAMAT GAN', '1700500959', null)
INSERT INTO Suppliers VALUES ('AMAV Transportation and Traffic', 2, 'MARK RENDER', 'Infrastructure Engineer', 
'Mark.AM@gmail.com', 'HAIFA', '037549954', 'https://amav.net')
INSERT INTO Suppliers VALUES ('URBANICS', 3, 'NOA MATA', 'Environmental Consultant', 'NOA.UR@gmail.com', 
'TEL AVIV', '036102826', 'https://urbanics.co.il')
INSERT INTO Suppliers VALUES ('GREEN Constraction', 1, 'GAYA NEVO', null, 'GAYA.GR@GMAIL.COM', 
'KFAR SABA', '097672191', 'http://www.green-construction.co.il')
INSERT INTO Suppliers VALUES ('Gordon Architects & Urban Planners',2, null, null, 'Office1@gordon-ltd.co.il',
'TIRAT CARMEL', '048580077', 'https://gordon-ltd.co.il')

insert into projects_suppliers values (1, 'MetroNorth', 1, 'ACKERSTEIN Urban Infrastructures') 
insert into projects_suppliers values (1, 'MetroNorth', 3, 'URBANICS') 
insert into projects_suppliers values (1, 'MetroNorth', 5, 'Gordon Architects & Urban Planners') 
insert into projects_suppliers values (2, 'MetroSouth', 2, 'AMAV Transportation and Traffic') 
insert into projects_suppliers values (2, 'MetroSouth', 4, 'GREEN Constraction')
insert into projects_suppliers values (3, 'LRTNofit', 1, 'ACKERSTEIN Urban Infrastructures') 
insert into projects_suppliers values (3, 'LRTNofit', 5, 'Gordon Architects & Urban Planners')
insert into projects_suppliers values (4, 'LRTDan', 2, 'AMAV Transportation and Traffic') 
insert into projects_suppliers values (4, 'LRTDan', 4,'GREEN Constraction') 
insert into projects_suppliers values (5, 'Road6North',  3, 'URBANICS') 
insert into projects_suppliers values (5, 'Road6North', 5, 'Gordon Architects & Urban Planners')

INSERT INTO Contracts VALUES (1,1, 'ACKERSTEIN_MetroN', 1, '2022-12-01', '2024-12-31', 1000000, 'CCI')
INSERT INTO Contracts VALUES (1,3, 'URBANICS_MetroN', 3, '2022-12-01','2024-12-31', 2500000, default)
INSERT INTO Contracts VALUES (1,5, 'GordonArch_MetroN', 2, '2022-12-01','2024-12-31', 3000000, default)
INSERT INTO Contracts VALUES (2,2, 'AMAV_MetroS', 2, '2021-11-06', '2023-12-31', 5000000, default)
INSERT INTO Contracts VALUES (2,4,'GREEN_MetroS', 1, '2021-11-06', '2023-12-31', 1000000, 'CCI')
INSERT INTO Contracts VALUES (3,1, 'ACKERSTEIN_LRTN', 1, '2022-10-04', '2024-06-30', 1000000, 'CCI')
INSERT INTO Contracts VALUES (3,5, 'Gordon_LRTN', 2, '2022-10-04', '2024-06-30', 5000000, default)
INSERT INTO Contracts VALUES (4,2, 'AMAV_LRTD', 2, '2022-06-04', '2024-01-01', 2000000, default)
INSERT INTO Contracts VALUES (4,4,'GREEN_LRTD', 1, '2022-06-04', '2024-01-01', 2500000, 'CCI')
INSERT INTO Contracts VALUES (5,3, 'URBANICS_Road6', 3, '2022-06-01', '2024-03-01', 1000000, default)
INSERT INTO Contracts VALUES (5,5, 'Gordon_Road6', 2, '2022-06-01', '2024-03-01', 2000000, default)

INSERT INTO Servicetype values (1, 'Contractors')
INSERT INTO Servicetype values (2, 'Planners')
INSERT INTO Servicetype values (3, 'Consultants')

INSERT INTO Accounts values (1,'ADV_ACKERSTEIN_MetroN', 'ADVANCE', 100000, '2022-12-01')
 INSERT INTO Accounts values (1,'PAR_ACKERSTEIN_MetroN','PARTIAL', 500000, '2023-12-31')
 INSERT INTO Accounts values (2,'ADV_URBANICS_MetroN', 'ADVANCE', 250000, '2022-12-01')
 INSERT INTO Accounts values (2,'PAR_URBANICS_MetroN', 'PARTIAL', 900000, '2023-12-31')
 INSERT INTO Accounts values (3,'ADV_GordonArch_MetroN', 'ADVANCE', 300000, '2022-12-01')
 INSERT INTO Accounts values (3, null,'PARTIAL', 1500000, '2023-12-31')
 INSERT INTO Accounts values (4,'PAR_AMAV_MetroS','PARTIAL', 2000000, '2021-07-01')
 INSERT INTO Accounts values (4,'FIN_AMAV_MetroS', 'FINAL', 3000000, '2023-12-31')
 INSERT INTO Accounts values (5,'PAR_GREEN_MetroS', 'PARTIAL', 100000, '2021-09-01')
 INSERT INTO Accounts values (5,'FIN_GREEN_MetroS', 'FINAL', 900000, '2023-12-31')
 INSERT INTO Accounts values (6,'ADV_ACKERSTEIN_LRTN', 'ADVANCE', 200000, '2022-10-04')
 INSERT INTO Accounts values (6,'PAR_ACKERSTEIN_LRTN', 'PARTIAL', 300000, '2024-01-30')
 INSERT INTO Accounts values (7,'ADV_Gordon_LRTN', 'ADVANCE', 500000, '2022-10-04')
 INSERT INTO Accounts values (7,'PAR_Gordon_LRTN', 'PARTIAL', 1500000, '2024-02-28')
 INSERT INTO Accounts values (8,'PAR_AMAV_LRTD', 'PARTIAL', 200000, '2022-07-01')
 INSERT INTO Accounts values (8,'FIN_AMAV_LRTD', 'FINAL', 1800000, '2024-01-01')
 INSERT INTO Accounts values (9,'PAR_GREEN_LRTD', 'PARTIAL', 250000, '2022-08-01')
 INSERT INTO Accounts values (9,'FIN_GREEN_LRTD','FINAL', 2250000, '2024-01-01')
 INSERT INTO Accounts values (10,'ADV_URBANICS_Road6', 'ADVANCE', 100000, '2022-06-01')
 INSERT INTO Accounts values (10,'PAR_URBANICS_Road6', 'PARTIAL', 500000, '2023-02-01')
 INSERT INTO Accounts values (11,'ADV_Gordon_Road6','ADVANCE', 200000, '2022-06-01')
 INSERT INTO Accounts values (11,'PAR_Gordon_Road6','PARTIAL', 900000, '2023-04-01')


 
