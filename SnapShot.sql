-- Creación de instantáneas
sp_helpdb northwind


CREATE DATABASE Northwind_v1 ON
(
  NAME = northwind, 
  FILENAME = 'F:\Data\Nortwind_ss_v1.ss'
) AS SNAPSHOT OF northwind
GO

USE Northwind

SELECT * FROM [Order Details]
GO

DELETE FROM [Order Details]
GO

-- Restauración de Snapshot

use master

RESTORE DATABASE northwind FROM
DATABASE_SNAPSHOT = 'Nortwind_ss_v1'
GO