-- =============================================
-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
CREATE TABLE SalesLT.ProductPriceHistory (
    HistoryID INT IDENTITY PRIMARY KEY,
    ProductID INT,
    OldPrice MONEY,
    NewPrice MONEY,
    ChangedDate DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE OR ALTER TRIGGER SalesLT.trg_ProductPriceHistory
ON SalesLT.Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO SalesLT.ProductPriceHistory (ProductID, OldPrice, NewPrice)
    SELECT 
        i.ProductID,
        d.ListPrice AS OldPrice,
        i.ListPrice AS NewPrice
    FROM inserted i
    JOIN deleted d ON i.ProductID = d.ProductID
    WHERE ISNULL(d.ListPrice, -1) <> ISNULL(i.ListPrice, -1);
END;
GO
-- =============================================
-- Zadanie 2
-- =============================================
CREATE TABLE [226360].DeletedCustomersLog (
    LogID INT IDENTITY PRIMARY KEY,
    CustomerID INT,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    LogDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER [226360].trg_CustomerDel
ON [226360].Customer
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [226360].DeletedCustomersLog (CustomerID, FirstName, LastName)
    SELECT d.CustomerID, d.FirstName, d.LastName
    FROM deleted d
    JOIN SalesLT.SalesOrderHeader soh ON d.CustomerID = soh.CustomerID;

    DELETE c
    FROM [226360].Customer c
    INNER JOIN deleted d ON c.CustomerID = d.CustomerID
    WHERE c.CustomerID NOT IN (
        SELECT CustomerID FROM SalesLT.SalesOrderHeader
    );
END;
GO
-- =============================================
-- Zadanie 3
-- =============================================
WITH CategoryHierarchy AS
(
    SELECT 
        ProductCategoryID,
        ParentProductCategoryID,
        CAST(Name AS NVARCHAR(MAX)) AS CategoryPath
    FROM SalesLT.ProductCategory
    WHERE ParentProductCategoryID IS NULL

    UNION ALL

    SELECT 
        c.ProductCategoryID,
        c.ParentProductCategoryID,
        CAST(ch.CategoryPath + ' -> ' + c.Name AS NVARCHAR(MAX))
    FROM SalesLT.ProductCategory c
    JOIN CategoryHierarchy ch 
         ON c.ParentProductCategoryID = ch.ProductCategoryID
)
SELECT CategoryPath
FROM CategoryHierarchy
ORDER BY CategoryPath;
-- =============================================
-- Zadanie 4
-- =============================================
CREATE TABLE SalesLT.PriceIncreaseLog (
    LogID INT IDENTITY PRIMARY KEY,
    ProductID INT,
    OldPrice MONEY,
    NewPrice MONEY,
    LogDate DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER SalesLT.trg_Product_BlockBigPriceIncrease
ON SalesLT.Product
AFTER UPDATE
AS
BEGIN
    IF EXISTS(
        SELECT 1 
        FROM inserted i
        JOIN deleted d ON i.ProductID = d.ProductID
        WHERE i.ListPrice > (d.ListPrice * 1.20)
    )
    BEGIN
        INSERT INTO SalesLT.PriceIncreaseLog (ProductID, OldPrice, NewPrice)
        SELECT i.ProductID, d.ListPrice, i.ListPrice
        FROM inserted i
        JOIN deleted d ON i.ProductID = d.ProductID
        WHERE i.ListPrice > (d.ListPrice * 1.20);

        RAISERROR('Cena nie może być zwiększona więcej niż 20%!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
-- =============================================
-- Zadanie 5
-- =============================================
CREATE TABLE SalesLT.DatabaseAuditLog (
    LogID INT IDENTITY PRIMARY KEY,
    OperationDescription NVARCHAR(200),
    ChangedBy SYSNAME DEFAULT SYSTEM_USER,
    ChangedAt DATETIME2 DEFAULT SYSDATETIME()
);
GO

CREATE TRIGGER trg_DDL
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO SalesLT.DatabaseAuditLog (OperationDescription)
    VALUES ('Odbyła się operacja [CREATE|ALTER|DROP] TABLE zrobiona przez' + ORIGINAL_LOGIN());
END;
GO
-- =============================================
-- Zadanie 6
-- =============================================
CREATE TABLE SalesLT.ProductReview (
    ReviewID INT IDENTITY PRIMARY KEY,
    ProductID INT, 
    Rating INT,
    Comments NVARCHAR(MAX)
);

WITH TopRateProducts AS
(
    SELECT 
        p.ProductID,
        p.Name AS ProductName,
        r.Rating
    FROM SalesLT.Product p
    JOIN SalesLT.ProductReview r ON p.ProductID = r.ProductID
    WHERE r.Rating = 5
),
ProductWithCategory AS
(
    SELECT 
        trp.ProductName,
        c.Name AS CategoryName
    FROM TopRateProducts trp
    JOIN SalesLT.ProductCategory c ON trp.ProductID = c.ProductCategoryID
)
SELECT * FROM ProductWithCategory
ORDER BY CategoryName;