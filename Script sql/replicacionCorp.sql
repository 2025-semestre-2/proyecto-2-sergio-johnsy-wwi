-- 1. LINKED SERVERS 
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'sql_li')
    EXEC sp_dropserver @server = N'sql_li', @droplogins = 'droplogins';
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'sql_sj')
    EXEC sp_dropserver @server = N'sql_sj', @droplogins = 'droplogins';
GO


EXEC sp_addlinkedserver 
    @server = N'sql_li',
    @srvproduct = N'',
    @provider = N'SQLNCLI',
    @datasrc = N'172.20.0.12';
GO

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = N'sql_li',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'sa',
    @rmtpassword = N'LI_2025';
GO

EXEC sp_addlinkedserver 
    @server = N'sql_sj',
    @srvproduct = N'',
    @provider = N'SQLNCLI',
    @datasrc = N'172.20.0.11';
GO

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = N'sql_sj',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'sa',
    @rmtpassword = N'SJ_2025*';
GO


-- En el nodo que será distribuidor
USE [master];
DECLARE @distributor SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'WWI2025*Corp';

-- Agregar distribuidor
EXEC sp_adddistributor 
    @distributor = @distributor, 
    @password = @password;

-- Crear base de datos de distribución
EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.CORP\MSSQL\DATA', 
    @log_folder = N'C:\Program Files\Microsoft SQL Server\MSSQL16.CORP\MSSQL\DATA', 
    @security_mode = 0,
	@login = N'corp',
    @password = @password;
GO






USE [distribution];
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U ')
    CREATE TABLE UIProperties(id INT);
IF EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))
    EXEC sp_updateextendedproperty N'SnapshotFolder', N'C:\Program Files\Microsoft SQL Server\MSSQL16.CORP\MSSQL\repldata', 'user', dbo, 'table', 'UIProperties';
ELSE
    EXEC sp_addextendedproperty N'SnapshotFolder', N'C:\Program Files\Microsoft SQL Server\MSSQL16.CORP\MSSQL\repldata', 'user', dbo, 'table', 'UIProperties';

DECLARE @publisher SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'WWI2025*Corp';
EXEC sp_adddistpublisher 
    @publisher = @publisher, 
    @distribution_db = N'distribution', 
    @security_mode = 0, 
    @login = N'corp', 
    @password = @password,
    @working_directory = N'C:\Program Files\Microsoft SQL Server\MSSQL16.CORP\MSSQL\repldata', 
    @trusted = N'false', 
    @publisher_type = N'MSSQLSERVER';




GO










-- 6. Desde el nodo que creó la publicación


USE [Corporativo];

EXEC sp_addsubscription 
	@publication = N'RepliCorp', 
	@subscriber = N'sql_li', 
	@destination_db = N'Sucursal_LI', 
	@subscription_type = N'Push',
	@sync_type = N'replication support only',
	@article = N'all', @update_mode = N'read only',
	@subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
	@publication = N'RepliCorp', 
	@subscriber = N'sql_li', 
	@subscriber_db = N'Sucursal_LI', 
	@job_login = NULL, 
	@job_password = NULL, 
	@subscriber_security_mode = 0,
	@subscriber_login = N'sa',        
    @subscriber_password = N'LI_2025*',
	@frequency_type = 64, 
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0, 
	@frequency_subday = 0, 
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959, 
	@active_start_date = 20241023,
	@active_end_date = 99991231,
	@enabled_for_syncmgr = N'False',
	@dts_package_location = N'Distributor';

-- Suscriptor: CORP
EXEC sp_addsubscription 
	@publication = N'RepliCorp', 
	@subscriber = N'sql_sj', 
	@destination_db = N'Sucursal_SJ', 
	@subscription_type = N'Push',
	@sync_type = N'replication support only',
	@article = N'all', @update_mode = N'read only',
	@subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
	@publication = N'RepliCorp', 
	@subscriber = N'sql_sj', 
	@subscriber_db = N'Sucursal_SJ', 
	@job_login = NULL, 
	@job_password = NULL, 
	@subscriber_security_mode = 0,
	@subscriber_login = N'sa',        
    @subscriber_password = N'SJ_2025*',
	@frequency_type = 64, 
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0, 
	@frequency_subday = 0, 
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959, 
	@active_start_date = 20241023,
	@active_end_date = 99991231,
	@enabled_for_syncmgr = N'False',
	@dts_package_location = N'Distributor';
GO


DROP DATABASE Corporativo




USE distribution;
SELECT * FROM MSpublications;
SELECT * FROM MSsubscriptions;


DELETE FROM MSsubscriptions
DELETE FROM MSpublications

USE master;

EXEC sp_dropdistpublisher @publisher = N'CORP'

EXEC sp_dropdistributiondb @database = N'distribution';
EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1;










