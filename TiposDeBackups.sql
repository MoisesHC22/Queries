-- Backup completo

backup database northwind
to disk ='D:\Northwind\backups\full\northwins.bak'
with name= 'Backup Completo 23_02_2024'


 -- Visualizar el interior del archivo .bak
 restore headeronly
 from disk= 'D:\Northwind\backups\full\northwins.bak'


 use Northwind

 --Agregar datos a northwind
 insert into customers (customerid, companyname, country)
 values('DE1','Backups ex','Brazil'),
  ('DE2','.net company','India'),
  ('DE3','spring boot c','Germany')


-- Backup de log

  backup log northwind
  to disk = 'D:\Northwind\backups\logs\northwins.bak'
  with name = 'backup log 23_02_2024 '

-- Visualizar el interior del archivo .bak
  restore headeronly 
  from disk = 'D:\Northwind\backups\logs\northwind.bak'

-- Agregar datos a northwind
  insert into customers (customerid, companyname, country)
  values('DE4','Backups ex2', 'Brazil2'),
  ('DE5','.net company2', 'India2')


-- Backup differential
   backup database northwind
   to disk = 'D:\Northwind\backups\differential\northwins.bak'
   with name = 'Backup differencial 23_02_24', differential

-- Agregar datos a northwind
   insert into customers (customerid, companyname, country)
   values('DE6','Backups ex3', 'Brazil3'),
   ('DE7','.net company3', 'India3')

-- Eliminar la base de datos
use master
drop database northwind


-- Restaurar la base de datos northwind (Completo)
-- Visualizar el interior de archivo .bak

restore headeronly 
from disk = 'D:\Northwind\backups\full\northwind.bak'

restore database northwind 
from disk='D:\Northwind\backups\full\northwind.bak'
with file=1, recovery

-- Comprobar los registros

use northwind
select * from Customers

-- Restaurar el backup completo y uno diferencial

use master
drop database northwind

-- Visualizar el interior del archivo .bak
restore headeronly
from disk = 'D:\Northwind\backups\full\northwind.bak'

restore database northwind 
from disk='D:\Northwind\backups\full\northwind.bak'
with file=1, norecovery

restore database northwind 
from disk='D:\Northwind\backups\differential\northwind.bak'
with file=1, recovery

-- Comprobar la actualización

use master
select*from customers

use master
drop database northwind

-- Visualizar el interior del archivo .bak
restore headeronly 
from disk = 'D:\Northwind\backups\differential\northwind.bak'

restore database northwind 
from disk='D:\Northwind\backups\differential\northwind.bak'
with file=1, recovery