-- Se crea el distribuidor, se ejecuta en cada servidor

USE  [master];

DECLARE @distributor AS SYSNAME;
DECLARE @password AS SYSNAME;
SET @distributor = @@SERVERNAME;
SET @password = N'WWI2025LI*';   --se cambia el password si es diferente

EXECUTE sp_adddistributor
    @distributor = @distributor,
    @password= @password;

EXEC sp_adddistributiondb 
	@database = N'distribution', 
	@data_folder = N'/var/opt/mssql/data', 
	@log_folder = N'/var/opt/mssql/data', 
	@log_file_size = 2, 
	@min_distretention = 0, 
	@max_distretention = 72, 
	@history_retention = 48, 
	@deletebatchsize_xact = 5000, 
	@deletebatchsize_cmd = 2000, 
	@security_mode = 1
;
GO

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
SET @distributorlogin = N'li';
SET @distributorpassword = N'WWI2025LI*';

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
