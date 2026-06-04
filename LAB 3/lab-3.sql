-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
-- Baza danych dołącza konkretne kolumny do ostatecznego wyniku
    SELECT 
        soh.SalesOrderID,
        soh.ShipDate,
        a.City,
        a.StateProvince,
        p.Name AS ProductName,
        pd.Description,
        sod.OrderQty,
        sod.LineTotal
-- Optymalizator zapytania prawdopodobnie zacznie od tabel silnie filtrowanych wykorzystując przeszukiwanie indeksów
    FROM 
        SalesLT.SalesOrderHeader soh
-- Łączymy 6 tabeli, baza danych wykorzysta łączenie w pętli dla małych zbiorów i haszowanie dla większych relacji
    JOIN 
        SalesLT.Address a ON soh.ShipToAddressID = a.AddressID
    JOIN 
        SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
    JOIN 
        SalesLT.Product p ON sod.ProductID = p.ProductID
    JOIN 
        SalesLT.ProductModelProductDescription pmpd ON p.ProductModelID = pmpd.ProductModelID
    JOIN 
        SalesLT.ProductDescription pd ON pmpd.ProductDescriptionID = pd.ProductDescriptionID
    WHERE 
        a.City IN ('London', 'Cambridge', 'Oxford')
        AND pmpd.Culture = 'en'
        AND soh.ShipDate IS NOT NULL
    ORDER BY 
-- Sortowanie obciąża RAM/SWAP(page file w windowsie)
        soh.ShipDate DESC, a.City ASC;
-- =============================================
-- Zadanie 2
-- =============================================
-- Baza danych domyślnie robiłaby pełny skan tabeli przez LIKE, indeks pozwala wprowadzić szybki seek
CREATE NONCLUSTERED INDEX IX_Product_ProductNumber_Covering
ON SalesLT.Product (ProductNumber)
INCLUDE (Name, StandardCost, ProductCategoryID);

-- Wyciągamy konkretne dane, więc funkcje agregujące wymuszą zbudowanie tablic haszujących w tle
SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName,
    SUM(sod.LineTotal) AS TotalRevenue,
    AVG(p.StandardCost) AS AvgCost,
    (SUM(sod.LineTotal) - SUM(sod.UnitPrice * sod.OrderQty)) AS ProfitMargin
-- Zoptymalizowane indeksy, które zrobiliśmy wyżej zaczynają działać od tego momentu
FROM SalesLT.Product p
JOIN SalesLT.ProductCategory pc 
    ON p.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN SalesLT.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
-- Filtr mocno ucina ilość danych do przeszukiwania
WHERE (p.ProductNumber = '705' OR p.ProductNumber LIKE 'B%')
  AND ISNULL(sod.UnitPrice, 0) > 0
-- Grupowanie przypisze zsumowane wartości do kategorii, wywołany Hash Match
GROUP BY p.Name, pc.Name
ORDER BY TotalRevenue DESC;
-- =============================================
-- Zadanie 3
-- =============================================
-- W SSMS:  1) tools -> SQL Server Profiler -> *zalogowanie do bazy jak w SSMS*
--          2) w okienku "Trace Properties": -> Events Selection -> Zaznaczenie show all events
--          3) Odznaczenie wszystkich domyślnie wybranych opcji, zaznaczenie wszystkiego w zakładce "Security Audit"
--          4) Run
-- =============================================
-- Zadanie 4
-- =============================================
-- Odświeżenie statystyki na produktach, żeby optymalizator nie robił błędów w estymacji liczby wierszy (fullscan czyta wszystko i robi dokładny histogram)
UPDATE STATISTICS SalesLT.Product WITH FULLSCAN;