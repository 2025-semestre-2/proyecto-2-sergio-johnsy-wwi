-- 1. Crear el distribuidor en SANJOSE

USE [master];

DECLARE @distributor SYSNAME;
SELECT @distributor = @@SERVERNAME;

EXEC sp_adddistributor @distributor = @distributor, @password = N'SJ_2025*';
GO
EXEC sp_adddistributiondb 
    @database = N'distribution', 
    @data_folder = N'/var/opt/mssql/Data', 
    @log_folder = N'/var/opt/mssql/Data', 
    @log_file_size = 2, 
    @min_distretention = 0, 
    @max_distretention = 72, 
    @history_retention = 48, 
    @deletebatchsize_xact = 5000, 
    @deletebatchsize_cmd = 2000, 
    @security_mode = 1
;
GO

-- 2. Crear publicador en SANJOSE

USE [distribution];

IF (NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'UIProperties' AND type = 'U ')) 
    CREATE TABLE UIProperties(id INT) 
IF (EXISTS (SELECT * FROM ::fn_listextendedproperty('SnapshotFolder', 'user', 'dbo', 'table', 'UIProperties', NULL, NULL))) 
    EXEC sp_updateextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
ELSE 
    EXEC sp_addextendedproperty N'SnapshotFolder', N'/var/opt/mssql/ReplData', 'user', dbo, 'table', 'UIProperties';
GO

DECLARE @publisher SYSNAME;
SELECT @publisher = @@SERVERNAME;

EXEC sp_adddistpublisher 
    @publisher = @publisher, 
    @distribution_db = N'distribution', 
    @security_mode = 0, 
    @login = N'sa', 
    @password = N'SJ_2025*', 
    @working_directory = N'/var/opt/mssql/ReplData', 
    @trusted = N'false', 
    @thirdparty_flag = 0, 
    @publisher_type = N'MSSQLSERVER'
;
GO

-- 3. Crear la publicación desde el Wizard (Repl-SJ-WWI)

-- 4. Agregar la base subscriptora (CORP) a la publicación desde SANJOSE

------

USE [Sucursal_SJ];
EXEC sp_addsubscription 
    @publication = N'Repl-Corp-WWI', 
    @subscriber = '192.168.100.95',   -- nombre del servidor CORP o su IP
    @destination_db = N'Corporativo', 
    @subscription_type = N'Push',
    @sync_type = N'replication support only',
    @article = N'all', 
    @update_mode = N'read only',
    @subscriber_type = 0
;

EXEC sp_addpushsubscription_agent 
    @publication = N'Repl-Corp-WWI', 
    @subscriber = '192.168.100.95', 
    @subscriber_db = N'Corporativo', 
    @subscriber_login = N'corp', 
    @subscriber_password = N'WWI2025*Corp', 
    @subscriber_security_mode = 0, 
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
    @dts_package_location = N'Distributor'
;
GO

EXEC sp_addsubscription 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = 'LIMON', 
	@destination_db = N'Sucursal_LI', 
	@subscription_type = N'Push',
	@sync_type = N'replication support only',
	@article = N'all', @update_mode = N'read only',
	@subscriber_type = 0
;

EXEC sp_addpushsubscription_agent 
	@publication = N'Repl-Corp-WWI', 
	@subscriber = 'LIMON', 
	@subscriber_db = N'Sucursal_LI', 
	@subscriber_login = N'sa',
    @subscriber_password = N'LI_2025*',
	@subscriber_security_mode = 0, 
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
	@dts_package_location = N'Distributor'
;
GO

-- Eliminar la suscripción push (esto elimina el agente asociado)
USE [Sucursal_SJ];
EXEC sp_dropsubscription
    @publication = N'Repl-SJ-WWI',
    @subscriber = N'CORP',  -- el nombre que usaste
    @destination_db = N'Corporativo',
    @article = N'all';
GO

-- 5. Agregar el nodo al diagrama Peer-to-Peer
