
-- Ejemplo de crear un base de datos con stored procedure

create proc spcreacionbd
@nombre nvarchar(100)
as
begin
 declare @script nvarchar(100)
 set @script ='Create database ' + @nombre
 exec sp_executesql @script
 end

-- Código para ejecutar el stored procedure de creación de base de datos 

 EXEC spcreacionbd @nombre = 'Bd1';

 -- Stored procedure para crear base de datos avanzado

CREATE PROC spcreatebd
    @nombrebd nvarchar(100),
    @nombredt nvarchar(50),
    @urlfilenamedt nvarchar(100),
    @filenamedt nvarchar(50),
    @sizedt int,
    @filegrowth int,
    @nombrelg nvarchar(50),
    @urlfilenamelg nvarchar(100),
    @filenamelg nvarchar(50),
    @sizelg int,
    @filegrowlg int
 AS
 BEGIN
  Declare @script nvarchar(max)
  SET @script = '
  CREATE DATABASE ' + @nombrebd + '
  ON PRIMARY
  (NAME = ''' + @nombredt + '_data'',
  FILENAME = '''+ @urlfilenamedt + '\' + @filenamedt + '.mdf'',
  SIZE = '+ CONVERT(nvarchar(10), @sizedt) + 'MB,
  FILEGROWTH = ' + CONVERT(nvarchar(10), @filegrowth) + '%)
  LOG ON
  (NAME = '''+ @nombrelg +'_log'',
  FILENAME = ''' + @urlfilenamelg + '\' + @filenamelg + '.ldf'',
  SIZE = ' + CONVERT(nvarchar(10), @sizelg) + 'MB,
  FILEGROWTH = ' + CONVERT(nvarchar(10), @filegrowlg) + '%)'
  EXEC sp_executesql @script
END

--Código para ejecutar el stored procedure 

EXEC spcreatebd 
@nombrebd = 'Bd2', 
@nombredt = 'Bd2', 
@urlfilenamedt = 'C:\sqlserver\data', @filenamedt = 'bd2',
@sizedt = 50, @filegrowth = 25, 
@nombrelg = 'Bd2', 
@urlfilenamelg = 'C:\sqlserver\log', @filenamelg = 'bd2',
@sizelg = 25, @filegrowlg = 25;