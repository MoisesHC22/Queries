-- Creaciòn de una nueva base de datos
CREATE DATABASE NortwindTest
ON PRIMARY
(
    NAME = NorthwindTestData,
	FILENAME = 'E:\data1\NorthwindTestData.mdf',
	SIZE=50MB,
	FILEGROWTH=25%
)
LOG ON
(
    NAME = NorthwindTestLog,
	FILENAME = 'E:\data1\NorthwindTestLog.ldf',
	SIZE=50MB,
	FILEGROWTH=25%
)

-- Creaciòn de grupos adicionales
ALTER DATABASE NortwindTest
ADD FILEGROUP Data1
GO

ALTER DATABASE NortwindTest
ADD FILEGROUP Data2
GO

ALTER DATABASE NortwindTest
ADD FILEGROUP Data3
GO

-- Asociar Archivos a los FILEGROUPS

ALTER DATABASE NortwindTest
ADD FILE(NAME='NortwindTestParte1',
FILENAME='L:\Data\NortwindTestParte1.ndf',
SIZE=15MB,
FILEGROWTH=25%)
TO FILEGROUP Data1
GO

ALTER DATABASE NortwindTest
ADD FILE(NAME='NortwindTestParte2',
FILENAME='L:\Data\NortwindTestParte2.ndf',
SIZE=15MB,
FILEGROWTH=25%)
TO FILEGROUP Data2
GO

ALTER DATABASE NortwindTest
ADD FILE(NAME='NortwindTestParte3',
FILENAME='L:\Data\NortwindTestParte3.ndf',
SIZE=15MB,
FILEGROWTH=25%)
TO FILEGROUP Data3
GO

-- Funciòn de particiòn
use NortwindTest
GO

CREATE PARTITION FUNCTION funcionparticion (VARCHAR(5))
AS RANGE right FOR VALUES('I', 'P');

-- Esquema de particion (Se le indica las diferentes divisiones
-- que decreto la funciòn de particiòn para conocer a que filegroup
-- correspondera)
CREATE PARTITION SCHEME esquemaejemplo
AS PARTITION funcionparticion
TO (Data1, Data2, Data3)