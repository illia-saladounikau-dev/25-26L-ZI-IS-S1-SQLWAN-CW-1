-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
DECLARE @Litera char(1) = 'I';
deCLARE @Cyfra int = 0;
SELECT CustomerID, FirstName, LastName
FROM SalesLT.Customer
WHERE (LastName LIKE @Litera + '%') AND (CustomerID % 10 = @Cyfra);
-- =============================================
-- Zadanie 2
-- =============================================
DECLARE @X char(1) = 'I';
DECLARE @Produkty TABLE (
	ProductID int,
	Name nvarchar(50),
	ListPrice money
);
INSERT INTO @Produkty (ProductID, Name, ListPrice)
SELECT ProductID, Name, ListPrice
FROM SalesLT.Product
WHERE Name LIKE '%' + @X + '%'
-- =============================================
-- Zadanie 3
-- =============================================
DECLARE @X char(1) = 'I';
SELECT Customer.CustomerID, FirstName, LastName, City
INTO #KlienciMiasta
FROM SalesLT.Customer
JOIN SalesLT.CustomerAddress ON Customer.CustomerID = CustomerAddress.CustomerID
JOIN SalesLT.Address ON CustomerAddress.AddressID = Address.AddressID
WHERE City LIKE @X + '%';

SELECT *
FROM #KlienciMiasta;

DROP TABLE #KlienciMiasta;
-- =============================================
-- Zadanie 4
-- =============================================
CREATE SCHEMA Student_0 AUTHORIZATION dbo;
GO

DECLARE @X char(1) = 'I';

CREATE TABLE Student_0.ProduktyI (
ProductID	int, -- identyfikator produktu
Name	nvarchar(100), -- nazwa produktu
Category	nvarchar(100), -- nazwa kategorii
ListPrice	money -- cena katalogowa
);

SELECT ProductID, Product.Name ,ProductCategory.Name AS Category, ListPrice
INTO Produkty_I
FROM SalesLT.Product
JOIN SalesLT.ProductCategory ON Product.ProductCategoryID = ProductCategory.ProductCategoryID
WHERE ProductCategory.Name LIKE '%' + @X + '%';

SELECT * FROM Produkty_I;
-- =============================================
-- Zadanie 5
-- =============================================
DECLARE @N int = 0;

DECLARE @Podsumowanie TABLE (
    Category nvarchar(100),
    SredniaCena money
);

INSERT INTO @Podsumowanie (Category, SredniaCena)
SELECT ProductCategory.Name, AVG(ListPrice)
FROM SalesLT.Product
JOIN SalesLT.ProductCategory ON Product.ProductCategoryID = ProductCategory.ProductCategoryID
WHERE ProductCategory.ProductCategoryID % 10 = @N
GROUP BY ProductCategory.Name;

SELECT * 
FROM @Podsumowanie;
-- =============================================
-- Zadanie 6
-- =============================================
CREATE SCHEMA [226360] AUTHORIZATION dbo;
GO
ALTER SCHEMA [226360] TRANSFER SalesLT.Customer;
ALTER SCHEMA [226360] TRANSFER SalesLT.CustomerAddress;