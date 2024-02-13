-- Creación de una base de datos
create database Northwind2
on primary 
(name=Northwind1_data, filename='C:\sqlserver\data\northwind1.mdf', 
size=50MB, -- Mínimo es de 512kb, el predeterminado es de 8MB
filegrowth=25% -- Por default es alrededor del 10%
)
log on 
(
  name=Northwind1_Log, filename='C:\sqlserver\log\nortwind1.ldf',
  size=25MB,
  filegrowth=25%
)
go

use Northwind2

-- Creación de Files Groups

ALTER DATABASE Northwind2 ADD FILEGROUP GRUPODATA1
ALTER DATABASE Northwind2 ADD FILEGROUP GRUPODATA2
ALTER DATABASE Northwind2 ADD FILEGROUP GRUPODATA3

-- Eliminar un archivo creado

ALTER DATABASE Northwind2
REMOVE FILE Northwind1_data_secundario;


-- Asociar archivos a Filegroups
ALTER DATABASE Northwind2
ADD FILE(
   NAME=Northwind1_data_secundario,
   filename='C:\sqlserver\data\northwind1_data_secundario.ndf',
   size=15MB,
   maxsize=50MB,
   FILEGROWTH=1MB)
   TO FILEGROUP GRUPODATA1

ALTER DATABASE Northwind2
ADD FILE(
   NAME=Northwind1_data_secundario2,
   filename='C:\sqlserver\data\northwind1_data_secundario2.ndf',
   size=15MB,
   maxsize=50MB,
   FILEGROWTH=1MB)
   TO FILEGROUP GRUPODATA2

ALTER DATABASE Northwind2
ADD FILE(
   NAME=Northwind1_data_secundario3,
   filename='C:\sqlserver\data\northwind1_data_secundario3.ndf',
   size=15MB,
   maxsize=50MB,
   FILEGROWTH=1MB)
   TO FILEGROUP GRUPODATA3