
-- Uso de la base de datos anteriormente creado

USE Northwind2

-- Creación de una tabla

CREATE TABLE cliente(
  [CustomerID] [nchar](5) NOT NULL,
  [CompanyName] [nvarchar](40) NOT NULL,
  [Country] [nvarchar](15) NULL,
  CONSTRAINT pk_cliente
  PRIMARY KEY([CustomerID])
)

-- Copia los datos de la base de datos Northwind a la tabla nueva

INSERT INTO cliente
SELECT CustomerID, CompanyName, Country
FROM Northwind.dbo.Customers

-- Ejemplo de un Stored procedure

CREATE PROC spinsertar
    @id nchar(5),
    @name nvarchar(10),
    @pais nvarchar(15)
AS
BEGIN
  DECLARE @id2 nchar(5)
  SET @id2 = 'Hola TDA'
  INSERT INTO cliente
  VALUES(@id,@name,@pais)
END

-- Ejecutar sp

EXEC spinsertar 'xxxxx','El puerco', 'Mexico'


