-- =============================================
-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
CREATE TYPE dbo.I0_surname FROM NVARCHAR(50) NOT NULL;

ALTER TABLE [226360].[Customer] 
ALTER COLUMN LastName dbo.I0_surname NOT NULL;

ALTER TABLE [226360].[Customer] 
SET (SYSTEM_VERSIONING = OFF);
GO
-- Aby zmienić typ trzeba było wyłączyć wersjonowanie włączone podczas poprzednich zadań, inaczej występował błąd.
ALTER TABLE [226360].[CustomerHistory] 
ALTER COLUMN LastName dbo.I0_surname;
-- =============================================
-- Zadanie 2
-- =============================================
DECLARE @ProductInfo NVARCHAR(MAX) = N'{[
    {"ProductID": 900, "NewPrice" : 100},
    {"ProductID": 901, "NewPrice" : 200},
    {"ProductID": 902, "NewPrice" : 300},
    {"ProductID": 903, "NewPrice" : 400},
    {"ProductID": 904, "NewPrice" : 500},
]}';

-- Stworzenie widoku z wykorzystaniem zmiennej jest niemożliwe, występuje błąd: 'Must declare the scalar variable', oraz 'CREATE VIEW' must be the first statement in a query batch' w przypadku kiedy wszystko jest połączone.

-- =============================================
-- Zadanie 3
-- =============================================
CREATE VIEW SalesLT.[226360_order] AS
SELECT TOP 100 PERCENT
    ProductID, 
    Name, 
    ListPrice
FROM SalesLT.Product
ORDER BY ListPrice DESC
-- =============================================
-- Zadanie 4
-- =============================================
-- Cena odnowionych (refurbished) produktów jest 90% od zwykłej, wyświetlenie ceny odnowionych produktów.
CREATE VIEW [Student_0.MyLogicView] AS
SELECT 
    ProductID, 
    Name AS ProductName, 
    ListPrice AS StandardPrice,
    ListPrice * 0.9 AS RefurbishedPrice
FROM SalesLT.Product
GO
-- =============================================
-- Zadanie 5
-- =============================================
-- Zwracamy 10 najkorzystniejszych zniżek:
CREATE VIEW [Student_0.v_Top10RefurbishedDeals] AS
SELECT TOP 10
    ProductID,
    ProductName,
    StandardPrice,
    RefurbishedPrice,
    (StandardPrice - RefurbishedPrice) AS DiscountAmount
FROM [Student_0.MyLogicView]
ORDER BY DiscountAmount DESC;