-- =============================================
-- Illia
-- Saladounikau
-- 226360
-- =============================================
-- =============================================
-- Zadanie 1
-- =============================================
USE master;
GO

CREATE LOGIN [226360]
WITH PASSWORD = 'S1ln3H@sl0!',
CHECK_EXPIRATION = ON, CHECK_POLICY = ON;
GO

USE AdventureWorksLT2022;
GO
CREATE USER [226360] FOR LOGIN [226360];
GO
-- =============================================
-- Zadanie 2
-- =============================================
USE AdventureWorksLT2022;
GO

GRANT CONTROL ON SCHEMA :: SalesLT TO [226360];
-- =============================================
-- Zadanie 3
-- =============================================
USE AdventureWorksLT2022;
GO

REVOKE CONTROL ON SCHEMA :: SalesLT FROM [226360];
GO

GRANT SELECT ON SalesLT.Product TO [226360];
GO

GRANT SELECT, UPDATE ON [226360].Customer(FirstName) TO [226360];
GO