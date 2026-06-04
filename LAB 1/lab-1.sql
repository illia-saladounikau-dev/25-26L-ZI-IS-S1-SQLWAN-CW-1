-- =============================================
-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
SELECT *
FROM SalesLT.Customer
WHERE LastName
LIKE 'I%'
-- =============================================
-- Zadanie 2
-- =============================================
SELECT FirstName, LastName, EmailAddress
FROM SalesLT.Customer
WHERE CustomerID
LIKE '%0'
-- =============================================
-- Zadanie 3
-- =============================================
SELECT Name, ListPrice, ProductNumber 
FROM SalesLT.Product WHERE Name LIKE '%I%'
-- =============================================
-- Zadanie 4
-- =============================================
SELECT AVG(p.ListPrice) AS AvgPrice
FROM SalesLT.Product p
GROUP BY p.ProductCategoryID
HAVING p.ProductCategoryID % 10 = 0
-- =============================================
-- Zadanie 5
-- =============================================
SELECT DISTINCT City
FROM SalesLT.CustomerAddress ca
JOIN SalesLT.Address a ON ca.AddressID = a.AddressID
WHERE City LIKE 'I%'
-- =============================================
-- Zadanie 6
-- =============================================
INSERT INTO SalesLT.Customer (FirstName, LastName, CompanyName, EmailAddress)
VALUES ('Illia', 'Saladounikau', 'Lab0', 'Illia.Saladounikau@lab0.com')
-- Wstawienie zgodne z instrukcją w zadaniu jest niemożliwe ponieważ kolumna PasswordHash nie może mieć NULL:
-- Cannot insert the value NULL into column 'PasswordHash', table 'AdventureWorksLT2022.SalesLT.Customer'; column does not allow nulls. INSERT fails.
SELECT * 
FROM SalesLT.Customer 
WHERE EmailAddress = 'Illia.Saladounikau@lab0.com'
-- Wyświetlenie nie działa ponieważ wstawienie jest niemożliwe
-- =============================================
-- Zadanie 7
-- =============================================
INSERT INTO SalesLT.ProductCategory (Name)
VALUES ('Special-I');

INSERT INTO SalesLT.ProductCategory (Name)
VALUES ('Extra-0');
-- =============================================
-- Zadanie 8
-- =============================================
SELECT p.Name, p.ProductNumber, pc.Name as ProductCategoryName
INTO ProductsCategories226360
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc ON p.ProductCategoryID = pc.ProductCategoryID
WHERE (p.Name LIKE 'I%' AND p.Name LIKE '%I')
  OR pc.Name LIKE '%I%';

ALTER TABLE ProductsCategories226360
ADD OwnerId varchar(6) NOT NULL
DEFAULT '226360';
-- =============================================
-- Zadanie 9
-- =============================================
SELECT ProductCategoryName, COUNT(*) as Count
FROM ProductsCategories226360
GROUP BY ProductCategoryName