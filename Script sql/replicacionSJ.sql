--Replicaciones entre las 3 bases

-- Se crea el publicador, se ejecuta en cada servidor
--si da error de carpeta crear en esta ruta
--C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL la carpeta ReplData 
--y darle permisos de lectura y escritura


USE [distribution];

IF (NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U')) 
    CREATE TABLE UIProperties(id INT);

IF (EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))) 
    EXEC sp_updateextendedproperty 
        N'SnapshotFolder', 
        N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\ReplData', 
        'user', dbo, 'table', 'UIProperties';
ELSE 
    EXEC sp_addextendedproperty 
        N'SnapshotFolder', 
        N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\ReplData', 
        'user', dbo, 'table', 'UIProperties';
GO

DECLARE @publisher SYSNAME;
DECLARE @distributorlogin AS SYSNAME;
DECLARE @distributorpassword AS SYSNAME;
SET @publisher = @@SERVERNAME;
SET @distributorlogin = N'sj';
SET @distributorpassword = N'WWI2025SJ*';

EXEC sp_adddistpublisher 
    @publisher = @publisher, 
    @distribution_db = N'distribution', 
    @security_mode = 0, 
    @login = @distributorlogin, 
    @password = @distributorpassword, 
    @working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\ReplData', 
    @trusted = N'false', 
    @thirdparty_flag = 0, 
    @publisher_type = N'MSSQLSERVER';
GO


-- Crear la publicacion desde el ssms, en los tres servidores


--Agregar los nodos





--pruebas
