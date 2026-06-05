-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================

-- Aby zbudować musiałem zmienić schemat z SalesLT na 226360 w funkcji [ufnGetCustomerInformation] aby naprawić błędy. Link do repo z plikiem .dacpac (plik znajduje się w folderze 'LAB 5'):
-- https://github.com/illia-saladounikau-dev/25-26L-ZI-IS-S1-SQLWAN-CW-1
-- (git@github.com:illia-saladounikau-dev/25-26L-ZI-IS-S1-SQLWAN-CW-1.git / https://github.com/illia-saladounikau-dev/25-26L-ZI-IS-S1-SQLWAN-CW-1.git)

-- =============================================
-- Zadanie 2
-- =============================================

ALTER TABLE [226360].[Customer]
ADD 
    SysStartTime DATETIME2 GENERATED ALWAYS AS ROW START NOT NULL DEFAULT SYSUTCDATETIME(),
    SysEndTime DATETIME2 GENERATED ALWAYS AS ROW END NOT NULL DEFAULT CONVERT(DATETIME2, '9999-12-31 23:59:59.9999999'),
    PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);

ALTER TABLE [226360].[Customer]
SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = [226360].[CustomerHistory]));
GO
-- =============================================
-- Zadanie 3
-- =============================================
UPDATE [226360].[Customer] SET LastName = 'Kowalski1' WHERE CustomerID = 100;
GO
UPDATE [226360].[Customer] SET LastName = 'Kowalski2' WHERE CustomerID = 100;
GO
UPDATE [226360].[Customer] SET LastName = 'Kowalski3' WHERE CustomerID = 100;
GO

UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 1;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 2;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 3;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 4;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 5;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 6;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 7;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 8;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 9;
GO
UPDATE [226360].[Customer] SET FirstName = 'Jan', LastName = 'Kowalski' WHERE CustomerID = 10;

INSERT INTO [226360].[Customer] (NameStyle, FirstName, LastName, PasswordsHash, PasswordSalt, rowguid, ModifiedDate)
VALUES  (0, 'Jan', 'Iwanowicz', '', '', NEWID(), GETDATE()),
        (0, 'Jan', 'Iwanowicz', '', '', NEWID(), GETDATE()),
        (0, 'Jan', 'Iwanowicz', '', '', NEWID(), GETDATE()),
        (0, 'Jan', 'Iwanowicz', '', '', NEWID(), GETDATE()),
        (0, 'Jan', 'Iwanowicz', '', '', NEWID(), GETDATE());
-- =============================================
-- Zadanie 4
-- =============================================
SELECT * FROM [226360].[Customer]
FOR SYSTEM_TIME ALL
WHERE CustomerID = 100;
-- =============================================
-- Zadanie 5
-- =============================================
SELECT *
FROM [226360].[Customer]
FOR SYSTEM_TIME AS OF '2026-06-04 22:22:22.2222';
-- =============================================
-- Zadanie 6
-- =============================================
CREATE XML SCHEMA COLLECTION [SalesLT].[ProductAttributeSchema] AS N'
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="ProductData">
        <xs:complexType>
            <xs:sequence>
                <xs:element name="Weight" type="xs:decimal" minOccurs="0" />
                <xs:element name="Color" type="xs:string" minOccurs="0" />
                <xs:element name="Material" type="xs:string" minOccurs="0" />
                <xs:element name="CountryOfOrigin" type="xs:string" minOccurs="0" />
                <xs:element name="FrameSize" type="xs:int" minOccurs="0" />
            </xs:sequence>
        </xs:complexType>
    </xs:element>
</xs:schema>';
GO
CREATE TABLE [SalesLT].[ProductAttribute] (
    AttributeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    Attributes XML([SalesLT].[ProductAttributeSchema]),
    CONSTRAINT FK_ProductAttrbute_ProductID FOREIGN KEY (ProductID) REFERENCES [SalesLT].[Product](ProductID)
);
-- =============================================
-- Zadanie 7
-- =============================================
INSERT INTO [SalesLT].[ProductAttribute] (ProductID, Attributes)
VALUES  (901, '<ProductData><Weight>1</Weight><Color>Red</Color><Material>Carbon</Material><CountryOfOrigin>PL</CountryOfOrigin><FrameSize>35</FrameSize></ProductData>'),
        (902, '<ProductData><Weight>2</Weight><Color>Red</Color><Material>Carbon</Material><CountryOfOrigin>PL</CountryOfOrigin><FrameSize>35</FrameSize></ProductData>'),
        (903, '<ProductData><Weight>3</Weight><Color>Red</Color><Material>Carbon</Material><CountryOfOrigin>PL</CountryOfOrigin><FrameSize>35</FrameSize></ProductData>'),
        (904, '<ProductData><Weight>4</Weight><Color>Red</Color><Material>Carbon</Material><CountryOfOrigin>PL</CountryOfOrigin><FrameSize>35</FrameSize></ProductData>'),
        (905, '<ProductData><Weight>5</Weight><Color>Red</Color><Material>Carbon</Material><CountryOfOrigin>PL</CountryOfOrigin><FrameSize>35</FrameSize></ProductData>');
-- =============================================
-- Zadanie 8
-- =============================================
UPDATE [SalesLT].[ProductAttribute]
SET Attributes.modify('replace value of (/ProductData/Material)[1] with "Ivory"');
GO
-- =============================================
-- Zadanie 9
-- =============================================
DECLARE @Y varchar(6) = '226360'
DECLARE @json NVARCHAR(MAX) = N'{
    "A": "1",
    "B": "2",
    "C": "3"
}';
SET @json = JSON_MODIFY(@json, '$.A', @Y);