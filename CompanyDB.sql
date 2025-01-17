USE [master]
GO
/****** Object:  Database [CompanyDB]    Script Date: 11/6/2024 2:55:05 PM ******/
CREATE DATABASE [CompanyDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CompanyDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\CompanyDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CompanyDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\CompanyDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [CompanyDB] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CompanyDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CompanyDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CompanyDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CompanyDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CompanyDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CompanyDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [CompanyDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CompanyDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CompanyDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CompanyDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CompanyDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CompanyDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CompanyDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CompanyDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CompanyDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CompanyDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CompanyDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CompanyDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CompanyDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CompanyDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CompanyDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CompanyDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CompanyDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CompanyDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CompanyDB] SET  MULTI_USER 
GO
ALTER DATABASE [CompanyDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CompanyDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CompanyDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CompanyDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CompanyDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CompanyDB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CompanyDB] SET QUERY_STORE = ON
GO
ALTER DATABASE [CompanyDB] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [CompanyDB]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employee]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[Age] [int] NOT NULL,
	[TelNo] [nvarchar](20) NOT NULL,
	[Salary] [decimal](19, 2) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Department] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Department] ADD  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Employee] ADD  DEFAULT (getdate()) FOR [UpdateDate]
GO
ALTER TABLE [dbo].[Employee]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Department] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Employee] CHECK CONSTRAINT [FK_Employee_Department]
GO
/****** Object:  StoredProcedure [dbo].[SP_CreateEmployees]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Create stored procedure to insert 5000 employees
CREATE PROCEDURE [dbo].[SP_CreateEmployees]
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @max INT = 500;
    DECLARE @name NVARCHAR(20);
    DECLARE @departmentId INT;
    DECLARE @address NVARCHAR(100);
    DECLARE @age INT;
    DECLARE @telNo NVARCHAR(15);
    DECLARE @salary DECIMAL(19,2);

    WHILE @i <= @max
    BEGIN
        -- Generate random name
        SET @name = LEFT(CAST(NEWID() AS NVARCHAR(MAX)), 20);

        -- Select random DepartmentId
        SELECT @departmentId = Id 
        FROM Department 
        ORDER BY NEWID();
        
        -- Generate random address
        SET @address = LEFT(CAST(NEWID() AS NVARCHAR(MAX)), 100);

        -- Generate random age between 21 and 60
        SET @age = FLOOR(RAND() * (60 - 21 + 1)) + 21;

        -- Generate random telephone number
        SET @telNo = LEFT(CAST(ABS(CHECKSUM(NEWID())) AS NVARCHAR), 15);

        -- Generate random salary between 2000 and 15000
        SET @salary = CAST((2000 + (RAND() * (15000 - 2000))) AS DECIMAL(19,2));

        -- Insert employee record
        INSERT INTO Employee (DepartmentId, Name, Address, Age, TelNo, Salary, CreatedDate, UpdateDate)
        VALUES (@departmentId, @name, @address, @age, @telNo, @salary, GETDATE(), GETDATE());

        SET @i = @i + 1;
    END
END;

GO
/****** Object:  StoredProcedure [dbo].[SP_Edit_Department]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Edit a Department
CREATE PROCEDURE [dbo].[SP_Edit_Department]
    @Id INT,
    @Name NVARCHAR(100),
    @UpdateDate DATETIME
AS
BEGIN
    UPDATE Department
    SET Name = @Name, UpdateDate = @UpdateDate
    WHERE Id = @Id;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Edit_Employee]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Edit an Employee
CREATE PROCEDURE [dbo].[SP_Edit_Employee]
    @Id INT,
    @DepartmentId INT,
    @Name NVARCHAR(100),
    @Address NVARCHAR(500),
    @Age INT,
    @TelNo NVARCHAR(20),
    @Salary DECIMAL(19,2),
    @UpdateDate DATETIME
AS
BEGIN
    UPDATE Employee
    SET DepartmentId = @DepartmentId, Name = @Name, Address = @Address, Age = @Age, TelNo = @TelNo, Salary = @Salary, UpdateDate = @UpdateDate
    WHERE Id = @Id;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_Departments]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure to Get All Departments
CREATE PROCEDURE [dbo].[SP_GET_Departments]
AS
BEGIN
    SELECT * FROM Department;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_Employee_ById]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GET_Employee_ById]
    @Id INT
AS
BEGIN
    SELECT Id, Name, Address, Age, TelNo, Salary, DepartmentId
    FROM Employees
    WHERE Id = @Id
END
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_Employees]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Get All Employees
CREATE PROCEDURE [dbo].[SP_GET_Employees]
AS
BEGIN
    SELECT e.*, d.Name AS DepartmentName FROM Employee e
    JOIN Department d ON e.DepartmentId = d.Id;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Department]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Insert a New Department
CREATE PROCEDURE [dbo].[SP_Insert_Department]
    @Name NVARCHAR(100),
    @CreatedDate DATETIME,
    @UpdateDate DATETIME
AS
BEGIN
    INSERT INTO Department (Name, CreatedDate, UpdateDate)
    VALUES (@Name, @CreatedDate, @UpdateDate);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_Employee]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Insert a New Employee
CREATE PROCEDURE [dbo].[SP_Insert_Employee]
    @DepartmentId INT,
    @Name NVARCHAR(100),
    @Address NVARCHAR(500),
    @Age INT,
    @TelNo NVARCHAR(20),
    @Salary DECIMAL(19,2),
    @CreatedDate DATETIME,
    @UpdateDate DATETIME
AS
BEGIN
    INSERT INTO Employee (DepartmentId, Name, Address, Age, TelNo, Salary, CreatedDate, UpdateDate)
    VALUES (@DepartmentId, @Name, @Address, @Age, @TelNo, @Salary, @CreatedDate, @UpdateDate);
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Remove_Department]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Remove a Department
CREATE PROCEDURE [dbo].[SP_Remove_Department]
    @Id INT
AS
BEGIN
    DELETE FROM Department WHERE Id = @Id;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Remove_Employee]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Stored Procedure to Remove an Employee
CREATE PROCEDURE [dbo].[SP_Remove_Employee]
    @Id INT
AS
BEGIN
    DELETE FROM Employee WHERE Id = @Id;
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_Update_Employee]    Script Date: 11/6/2024 2:55:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Update_Employee]
    @Id INT,
    @Name NVARCHAR(100),
    @Address NVARCHAR(255),
    @Age INT,
    @TelNo NVARCHAR(50),
    @Salary DECIMAL(18,2),
    @DepartmentId INT
AS
BEGIN
    UPDATE Employees
    SET Name = @Name,
        Address = @Address,
        Age = @Age,
        TelNo = @TelNo,
        Salary = @Salary,
        DepartmentId = @DepartmentId
    WHERE Id = @Id
END
GO
USE [master]
GO
ALTER DATABASE [CompanyDB] SET  READ_WRITE 
GO
