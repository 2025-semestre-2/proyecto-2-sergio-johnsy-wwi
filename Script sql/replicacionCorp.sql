--Replicaciones entre las 3 bases

--configurar el distribuidor, solo en el corporativo
USE [master];

DECLARE @distributor AS SYSNAME;
DECLARE @password AS SYSNAME;
SET @distributor = @@SERVERNAME;
SET @password = N'WWI2025Corp*';  -- Cambia el password si es diferente

-- Configurar el distribuidor
EXECUTE sp_adddistributor
    @distributor = @distributor,
    @password = @password;
GO

-- Crear la base de datos de distribución
EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA', 
    @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA', 
    @log_file_size = 2, 
    @min_distretention = 0, 
    @max_distretention = 72, 
    @history_retention = 48, 
    @deletebatchsize_xact = 5000, 
    @deletebatchsize_cmd = 2000, 
    @security_mode = 1;
GO

-- Se crea el publicador
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
SET @distributorlogin = N'corp';
SET @distributorpassword = N'WWI2025Corp*';

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