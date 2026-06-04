-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
-- Indeks klastrowy aby posortować dane wg. productid oraz vendorid
CREATE CLUSTERED INDEX CX_ProductVendor_ProductID_VendorID 
ON SalesLT.ProductVendor (ProductID, VendorID);

-- Indeks klastrowy ułatwi zapytania o części rowerów
CREATE CLUSTERED INDEX CX_ProductBOM_Parent_Component
ON SalesLT.ProductBOM (ParentProductID, ComponentProductID);

-- Indeks klastrowy do ułatwienia zapytań, data aby ułatwić porządkowanie wg daty oraz id vendorów
CREATE CLUSTERED INDEX CX_VendorPriceHistory_VendorID_QuoteDate
ON SalesLT.VendorPriceHistory (VendorID, QuoteDate);

-- Indeks klastrowy do ułatwienia zapytań, data aby ułatwić porządkowanie wg daty oraz id sprzedaży
CREATE CLUSTERED INDEX CX_ShipmentTrackingEvents_SalesOrderID_EventDate
ON SalesLT.ShipmentTrackingEvents (SalesOrderID, EventDate);
-- =============================================
-- Zadanie 2
-- =============================================
CREATE NONCLUSTERED INDEX IX_Vendor_Active_Name_AccountNumber
ON SalesLT.Vendor (Name, AccountNumber)
WHERE ActiveFlag = 1;
-- =============================================
-- Zadanie 3
-- =============================================
-- 
CREATE NONCLUSTERED INDEX IX_Product_ProductCategoryID_Covering
ON SalesLT.Product (ProductCategoryID)
INCLUDE (ListPrice);

-- Zapytanie do weryfikacji:
SELECT 
    ProductCategoryID, 
    ListPrice 
FROM SalesLT.Product 
WHERE ProductCategoryID = 5;

-- Indeks filtrujący, przyspiesza wyszukiwanie niezrealizowanych zamówień za pomocą pomijania innych
CREATE NONCLUSTERED INDEX IX_SalesOrderHeader_NotProcessed
ON SalesLT.SalesOrderHeader (OrderDate)
WHERE ShipDate is NULL;

-- Zapytanie do weryfikacji:
SELECT 
    SalesOrderID, 
    OrderDate 
FROM SalesLT.SalesOrderHeader 
WHERE ShipDate IS NULL;

-- Standardowy indeks nieklastrowy, przyspiesza wyszukiwanie klientów po dokładnym adresie mailowym
CREATE NONCLUSTERED INDEX IX_Customer_Mail
ON SalesLT.Customer (EmailAddress);

-- Zapytanie do weryfikacji działania:
SELECT *
FROM SalesLT.Customer
WHERE EmailAddress = 'orlando0@adventure-works.com';
-- =============================================
-- Zadanie 4
-- =============================================
ALTER INDEX CX_VendorPriceHistory_VendorID_QuoteDate
ON SalesLT.VendorPriceHistory
REBUILD WITH (FILLFACTOR = 25);
-- =============================================
-- Zadanie 5
-- =============================================
CREATE TABLE SalesLT.ProductReviews (
    ReviewID INT IDENTITY(1,1) NOT NULL,
    ProductID INT NOT NULL,
    CustomerID INT NOT NULL,
    Rating INT NOT NULL,
    Comment NVARCHAR(600),
    IsPublished BIT DEFAULT 0
);

-- Indeks klastrowy dodany za pomocą ALTER TABLE jako klucz główny
ALTER TABLE SalesLT.ProductReviews
ADD CONSTRAINT PK_ProductReviews PRIMARY KEY CLUSTERED (ReviewID);

-- Relacja do 1 istniejącej tabeli (Product) dodana przez ALTER TABLE
ALTER TABLE SalesLT.ProductReviews
ADD CONSTRAINT FK_ProductReviews_Product FOREIGN KEY (ProductID) REFERENCES SalesLT.Product(ProductID);

-- Relacja do 2 istniejącej tabeli (Customer) dodana przez ALTER TABLE
ALTER TABLE SalesLT.ProductReviews
ADD CONSTRAINT FK_ProductReviews_Customer FOREIGN KEY (CustomerID) REFERENCES SalesLT.Customer(CustomerID);

-- Indeks pokrywający do ułatwienia wyszukiwania opinii
CREATE NONCLUSTERED INDEX IX_ProductReviews_ProductID
ON SalesLT.ProductReviews (ProductID)
INCLUDE (Rating, Comment);

-- Indeks filtrujący który pomaga szybciej znaleźć opinie do wyświetlania
CREATE NONCLUSTERED INDEX IX_ProductReviews_Public
ON SalesLT.ProductReviews (Rating)
WHERE IsPublished = 1;