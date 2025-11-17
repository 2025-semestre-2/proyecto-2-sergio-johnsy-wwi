-- 1. LINKED SERVERS 
IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'sql_corp')
    EXEC sp_dropserver @server = N'sql_corp', @droplogins = 'droplogins';
GO

IF EXISTS (SELECT 1 FROM sys.servers WHERE name = N'sql_li')
    EXEC sp_dropserver @server = N'sql_li', @droplogins = 'droplogins';
GO


EXEC sp_addlinkedserver 
    @server = N'sql_corp',
    @srvproduct = N'',
    @provider = N'SQLNCLI',
    @datasrc = N'192.168.100.95';
GO

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = N'sql_corp',
    @useself = N'False',
    @locallogin = NULL,
    @rmtuser = N'corp',
    @rmtpassword = N'WWI2025*Corp';
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
    @rmtpassword = N'LI_2025*';
GO


-- 2. CREAR EL DISTRIBUIDOR
USE [master];
DECLARE @distributor SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'SJ_2025*';

EXEC sp_adddistributor @distributor = @distributor, @password = @password;

EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'/var/opt/mssql/data', 
    @log_folder = N'/var/opt/mssql/data', 
    @security_mode = 0,
	@login = N'sa',
    @password = @password;

GO

--3. CONFIGURAR CARPETA DE SNAPSHOTS
USE [distribution];
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U ')
    CREATE TABLE UIProperties(id INT);
IF EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))
    EXEC sp_updateextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
ELSE
    EXEC sp_addextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';

--4. CONFIGURAR EL PUBLICADOR
DECLARE @publisher SYSNAME = @@SERVERNAME;
DECLARE @password SYSNAME = N'SJ_2025*';
EXEC sp_adddistpublisher 
    @publisher = @publisher, 
    @distribution_db = N'distribution', 
    @security_mode = 0, 
    @login = N'sa', 
    @password = @password,
    @working_directory = N'/var/opt/mssql/ReplData', 
    @trusted = N'false', 
    @publisher_type = N'MSSQLSERVER';

-- 5. CREAR LA PUBLICACION EN SSMS

EXEC sp_replicationdboption 
    @dbname = N'Sucursal_SJ',
    @optname = N'publish',
    @value = N'true';
GO

EXEC sp_replicationdboption 
    @dbname = N'Sucursal_SJ',
    @optname = N'subscribe',
    @value = N'true';  


USE [Sucursal_SJ];
EXEC sp_helppublication;
-- 6. Desde el nodo que creó la publicación
EXEC sp_addsubscription 
    @publication = N'RepliSJ', 
    @subscriber = N'sql_li', 
    @destination_db = N'Sucursal_LI', 
    @subscription_type = N'Push', 
    @sync_type = N'replication support only', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
    @publication = N'RepliSJ', 
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
    @publication = N'RepliSJ', 
    @subscriber = N'sql_corp', 
    @destination_db = N'Corporativo', 
    @subscription_type = N'Push', 
    @sync_type = N'replication support only', 
    @article = N'all', 
    @update_mode = N'read only', 
    @subscriber_type = 0;

EXEC sp_addpushsubscription_agent 
    @publication = N'RepliSJ', 
	@subscriber = N'sql_corp', 
	@subscriber_db = N'Corporativo', 
	@job_login = NULL, 
	@job_password = NULL, 
	@subscriber_security_mode = 0,
	@subscriber_login = N'corp',        
    @subscriber_password = N'WWI2025*Corp',
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






USE distribution;
SELECT * FROM MSpublications;
SELECT * FROM MSsubscriptions;


DELETE FROM MSsubscriptions
DELETE FROM MSpublications

USE master;

EXEC sp_dropdistpublisher @publisher = N'SANJOSE';

EXEC sp_dropdistributiondb @database = N'distribution';
EXEC sp_dropdistributor @no_checks = 1, @ignore_distributor = 1;

SELECT * FROM sys.dm_exec_sessions 
WHERE database_id = DB_ID('distribution');

