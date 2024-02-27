
-- Comprobacion de un store procedure para comprobar si existe la base de datos

CREATE PROC crearBackups
@Database nvarchar(255)
AS
 BEGIN
	 IF exists(select 1 from sys.databases where name = @Database)
	   BEGIN
	     print 'Si existe.';
	   END
     ELSE
	   BEGIN
	     print'La base de datos ' + @Database + ' no existe.';
	   END
  END

 EXEC crearBackups @Database =  'Bd2';



-- Tipo de backup

ALTER PROC crearBackups
@Database nvarchar(255),
@TypeBackup nvarchar(200)
AS
 BEGIN
	 IF exists(select 1 from sys.databases where name = @Database)
	   BEGIN
	     if @TypeBackup in ('Full','Log','Differential')
		   BEGIN
		     
			 IF @TypeBackup = 'Full'
			    BEGIN
			      print 'El tipo de backup es full';
			    END

			 ELSE IF @TypeBackup = 'Log'
			    BEGIN
			      print 'El tipo de backup es Log';
			    END

			 ELSE IF @TypeBackup = 'Differential'
			    BEGIN
			      print 'El tipo de backup es differential';
			    END
            END
			
			 ELSE
			 
			    BEGIN
			      print 'Elige cualquier de estas opciones Full, Log o Differential';
			    END
	        END
     ELSE
	   BEGIN
	     print'La base de datos ' + @Database + ' no existe.';
	   END
  END


 EXEC crearBackups 
 @Database = 'Bd1',
 @TypeBackup ='FULL';

 
 -- Obtener la fecha

 ALTER PROC crearBackups
@Database nvarchar(255),
@TypeBackup nvarchar(200)
AS
 BEGIN
   declare @FechaBackup nvarchar(10)
   set @FechaBackup = REPLACE(CONVERT(NVARCHAR(20),GETDATE(),120), ':', '_')

	 IF exists(select 1 from sys.databases where name = @Database)
	   BEGIN
	     if @TypeBackup in ('Full','Log','Differential')
		   BEGIN
		     
			 IF @TypeBackup = 'Full'
			    BEGIN
			      print 'El tipo de backup es full' + @FechaBackup;
			    END

			 ELSE IF @TypeBackup = 'Log'
			    BEGIN
			      print 'El tipo de backup es Log';
			    END

			 ELSE IF @TypeBackup = 'Differential'
			    BEGIN
			      print 'El tipo de backup es differential';
			    END
            END
			
			 ELSE
			 
			    BEGIN
			      print 'Elige cualquier de estas opciones Full, Log o Differential';
			    END
	        END
     ELSE
	   BEGIN
	     print'La base de datos ' + @Database + ' no existe.';
	   END
  END

  EXEC crearBackups 
 @Database = 'Bd1',
 @TypeBackup ='FULL';










 -- Se agrega la Ruta y los tipos de backups

ALTER PROC crearBackups
@Database nvarchar(255),
@TypeBackup nvarchar(200),
@Ruta nvarchar(max)
AS
 BEGIN
   DECLARE @Existe INT;
   DECLARE @Hora nvarchar(5)
   SET @Hora = REPLACE(CONVERT(NVARCHAR(20), GETDATE(), 108), ':', '_');
   DECLARE @FechaBackup nvarchar(10)
   SET @FechaBackup = REPLACE(CONVERT(NVARCHAR(20),GETDATE(),120), ':', '_');

     -- Activar 
					    
	   EXEC Sp_configure 'show advanced options', 1;
	   RECONFIGURE;
						     
	   EXEC Sp_configure 'xp_cmdshell', '1';
   	   RECONFIGURE;

	-- Declaracion de variables
       
	   DECLARE @cmd VARCHAR(500);
	   DECLARE @Resultado TABLE (OUTPUT NVARCHAR(255));
	   DECLARE @Crear VARCHAR(1000);
	   DECLARE @RutaArchivo NVARCHAR(255);
	   DECLARE @ComandoBackup NVARCHAR(MAX);

	 IF exists(select 1 from sys.databases where name = @Database)
	   BEGIN
	     if @TypeBackup in ('Full','Log','Differential')
		   BEGIN
		     
			 IF @TypeBackup = 'Full'
			    BEGIN  

				 print 'El tipo de backup es full';

					  -- Verifica si el directorio existe utilizando xp_fileexist si no lo crea
                 
					   SET @cmd = 'DIR "' + @Ruta + '"';
					   EXEC xp_cmdshell @cmd;

					   IF NOT EXISTS(SELECT*FROM @Resultado WHERE OUTPUT LIKE '%' + @Ruta + '%')
					     BEGIN
							 SET @Crear = 'mkdir ' + @Ruta + '\'+ @Database+'\full\';
							 EXEC xp_cmdshell @Crear;
						 END

						 -- Código para crear el backup


						   SET @RutaArchivo = @Ruta + '\' + @Database + '\full\' + @Database + '_' +
						   @TypeBackup + '_' + @FechaBackup + '.bak'

						   SET @ComandoBackup = 'BACKUP DATABASE ' + QUOTENAME(@Database) + ' TO DISK = '''
						    + @RutaArchivo + ''' WITH NAME = ''backup completo_'+ @FechaBackup + '_V'+ @Hora+''';';

						EXEC sp_executesql @ComandoBackup;
	
			    END

			 ELSE IF @TypeBackup = 'Log'
			  BEGIN
			      print 'El tipo de backup es Log';

			     -- Verifica si el directorio existe utilizando xp_fileexist si no lo crea

				  SET @cmd = 'DIR "' + @Ruta + '"';
				  EXEC xp_cmdshell @cmd;

				  IF NOT EXISTS(SELECT*FROM @Resultado WHERE OUTPUT LIKE '%' + @Ruta + '%')
				     BEGIN
				       SET @Crear = 'mkdir ' + @Ruta + '\'+ @Database+'\log\';
				       EXEC xp_cmdshell @Crear;
		         	 END

					 -- Código para crear el backup

					 SET @RutaArchivo = @Ruta + '\' + @Database + '\log\' + @Database + '_' +
			    		 @TypeBackup + '_' + @FechaBackup + '.bak'

         			SET @ComandoBackup = 'BACKUP LOG ' + QUOTENAME(@Database) + ' TO DISK = '''
                        + @RutaArchivo + ''' WITH NO_TRUNCATE, NAME = ''backup log'+ @FechaBackup+ '_V'+ @Hora +''';';

        		  EXEC sp_executesql @ComandoBackup;
              END

			 ELSE IF @TypeBackup = 'Differential'
			    BEGIN
			      print 'El tipo de backup es differential';

				 -- Verifica si el directorio existe utilizando xp_fileexist si no lo crea

				  SET @cmd = 'DIR "' + @Ruta + '"';
				  EXEC xp_cmdshell @cmd;

				  IF NOT EXISTS(SELECT*FROM @Resultado WHERE OUTPUT LIKE '%' + @Ruta + '%')
				     BEGIN
				       SET @Crear = 'mkdir ' + @Ruta + '\'+ @Database+'\differential\';
				       EXEC xp_cmdshell @Crear;
		         	 END

					 -- Código para crear el backup
				     
					 SET @RutaArchivo = @Ruta + '\' + @Database + '\differential\' + @Database + '_' +
			    			     @TypeBackup + '_' + @FechaBackup + '.bak'

         						 SET @ComandoBackup = 'BACKUP DATABASE ' + QUOTENAME(@Database) + ' TO DISK = '''
                                 + @RutaArchivo + ''' WITH NAME = ''backup differential_'+ @FechaBackup + '_V'+ @Hora +''';';

        						EXEC sp_executesql @ComandoBackup;
			    END
            END
			
			 ELSE
			 
			    BEGIN
			      print 'Elige cualquier de estas opciones Full, Log o Differential';
			    END
	        END
     ELSE
	   BEGIN
	     print'La base de datos ' + @Database + ' no existe.';
	   END

	   -- Dashabilitar xp_cmdshell (por seguridad)
	     EXEC sp_configure 'xp_cmdshell', '0';
		 RECONFIGURE;
  END


-- Ejecutar el SP
 EXEC crearBackups 
 @Database = 'HD1',
 @TypeBackup ='Differential',
 @Ruta = 'D:\BbHD';


 restore headeronly 
from disk = 'D:\BbHD\HD1\differential\HD1_Differential_2024-02-27.bak'
